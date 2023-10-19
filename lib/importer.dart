import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;

class Changes {
  final int removed;
  final int modified;
  final int added;

  Changes({
    this.removed = 0,
    this.modified = 0,
    this.added = 0,
  });

  static Changes fromIterables<T>(Iterable<T> oldIt, Iterable<T> newIt) {
    return Changes(
      removed: oldIt.count((e) => !newIt.contains(e)),
      modified: newIt.count((e) => oldIt.contains(e)),
      added: newIt.count((e) => !oldIt.contains(e)),
    );
  }

  @override
  String toString() => '$removed | $modified | $added';
}

class _CpGroup {
  final GsAchievementGroup data;
  _CpGroup(this.data);

  @override
  bool operator ==(Object other) {
    if (other is! _CpGroup) return false;
    return data.id == other.data.id &&
        data.name == other.data.name &&
        data.icon == other.data.icon &&
        data.version == other.data.version &&
        data.namecard == other.data.namecard &&
        data.rewards == other.data.rewards &&
        data.achievements == other.data.achievements;
  }

  @override
  int get hashCode => data.hashCode;
}

class _CpAchievement {
  final GsAchievement data;
  _CpAchievement(this.data);

  @override
  bool operator ==(Object other) {
    if (other is! _CpAchievement) return false;
    return data.id == other.data.id &&
        data.name == other.data.name &&
        data.group == other.data.group &&
        data.hidden == other.data.hidden &&
        data.version == other.data.version &&
        data.type == other.data.type &&
        data.phases.length == other.data.phases.length &&
        data.phases
            .zip(
              other.data.phases,
              (a, b) =>
                  a.id == b.id && a.desc == b.desc && a.reward == b.reward,
            )
            .all((e) => e);
  }

  @override
  int get hashCode => data.hashCode;
}

abstract final class Importer {
  static Future<(Changes, Changes)?> importAchievementsFromAmbrJson(
    String path,
  ) async {
    final file = File(path);
    if (!await file.exists()) return null;
    final data = jsonDecode(await file.readAsString()) as Map;

    final groups = <Map<String, dynamic>>[];
    final achievements = <Map<String, dynamic>>[];

    Map<String, dynamic> parseAchievement(
      String groupName,
      List<Map<String, dynamic>> list,
    ) {
      final first = list.first;
      final name = first['name'] as String? ?? '';
      return {
        'id': '$groupName $name'.toDbId(),
        'name': name,
        'type': first.containsKey('commissions') ? 'commission' : '',
        'group': groupName.toDbId(),
        'hidden': first['hidden'],
        'version': first['ver'] as String? ?? '1.0',
        'phases': list.map((e) {
          return {
            'desc': e['desc'],
            'reward': e['reward'],
          };
        }).toList(),
      };
    }

    for (final group in data.values.cast<Map>()) {
      final groupOrder = group['order'] as int? ?? 0;
      final groupName = group['name'] as String? ?? '';

      groups.add({
        'id': groupName.toDbId(),
        'name': groupName,
        'order': groupOrder,
      });

      achievements.addAll(
        (group['achievements'] as List? ?? []).map(
          (ach) => ach is List
              ? parseAchievement(groupName, ach.cast<Map<String, dynamic>>())
              : parseAchievement(groupName, [ach]),
        ),
      );
    }

    final inDbAch = Database.i.achievements.data.map(_CpAchievement.new);
    final inDbGrp = Database.i.achievementGroups.data.map(_CpGroup.new);

    final dataAchievements = achievements.map(GsAchievement.fromMap);
    Database.i.achievements.updateAll(dataAchievements);

    final tempGroups = groups
        .sortedBy((element) => element['order'])
        .map(GsAchievementGroup.fromMap)
        .toList();

    final temp = await compute(
      (tuple) => tuple.groups.map((e) {
        final exist = tuple.dbGroups.firstOrNullWhere((t) => t.id == e.id);
        final items = tuple.dbAchievements.where((t) => t.group == e.id);
        return e.copyWith(
          icon: exist?.icon,
          namecard: exist?.namecard,
          version: items.maxBy((t) => t.version)?.version,
          rewards: items.sumBy((t) => t.reward),
          achievements: items.sumBy((t) => t.phases.length),
        );
      }),
      (
        groups: tempGroups,
        dbGroups: Database.i.achievementGroups.data,
        dbAchievements: Database.i.achievements.data,
      ),
    );

    Database.i.achievementGroups.updateAll(temp);
    await DataValidator.i.checkAll();
    Database.i.modified.add(null);

    final changesAch = Changes.fromIterables<_CpAchievement>(
      inDbAch,
      dataAchievements.map(_CpAchievement.new),
    );
    final changesGrp = Changes.fromIterables<_CpGroup>(
      inDbGrp,
      temp.map(_CpGroup.new),
    );

    return (changesAch, changesGrp);
  }

  static Future<List<GsAchievement>> importAchievementsFromFandom(
    GsAchievementGroup category, {
    String? url,
    bool useFile = false,
  }) async {
    const format = Clipboard.kTextPlain;
    url ??= (await Clipboard.getData(format))?.text ?? '';

    late final String raw;
    if (useFile) {
      final file = File('temp.html');
      if (!await file.exists()) {
        raw = await _getUrl(url);
        await file.writeAsString(raw);
      } else {
        raw = await file.readAsString();
      }
    } else {
      raw = await _getUrl(url);
    }

    final document = html.parse(raw);

    final table = document.querySelector('table.article-table');
    final entries = table?.querySelectorAll('tr') ?? [];

    final type = entries.skip(1).firstOrNull?.querySelectorAll('td') ?? [];
    if (type.length != 7 && type.length != 6 && type.length != 4) return [];

    final achvs = <GsAchievement>[];
    for (var entry in entries.skip(1)) {
      final tds = entry.querySelectorAll('td');

      final sz = tds.length;
      late final int reward;
      late final String name;
      late final String desc;
      late final String type;
      late final bool hidden;
      late final String version;

      name = tds[0].text.trim();
      desc = tds[1].text.split('\n').map((e) => e.trim()).join(' ').trim();
      if (sz == 4) {
        hidden = false;
        type = '';
        version = category.version;
        reward = int.tryParse(tds[3].text.trim()) ?? 0;
      } else if (sz == 6) {
        hidden = tds[3].text.trim().toLowerCase() == 'yes';
        type = '';
        version = tds[4].text.trim();
        reward = int.tryParse(tds[5].text.trim()) ?? 0;
      } else if (sz == 7) {
        hidden = tds[3].text.trim().toLowerCase() == 'yes';
        type = tds[4].text.trim().toLowerCase().toDbId();
        version = tds[5].text.trim();
        reward = int.tryParse(tds[6].text.trim()) ?? 0;
      } else {
        continue;
      }

      final id = '${category.id} $name'.toDbId();
      final idx = achvs.indexWhere((e) => e.id == id);
      if (idx != -1) {
        achvs[idx].phases
          ..add(GsAchievementPhase.fromMap({'desc': desc, 'reward': reward}))
          ..sortedBy((element) => element.reward);
      } else {
        achvs.add(
          GsAchievement.fromMap({
            'id': id,
            'name': name,
            'type': type,
            'group': category.id,
            'hidden': hidden,
            'version': version,
            'phases': [
              {
                'desc': desc,
                'reward': reward,
              }
            ],
          }),
        );
      }
    }

    return achvs;
  }

  static Future<GsCharacter> importCharacterFromFandom(
    GsCharacter item, {
    String? url,
    bool useFile = false,
  }) async {
    const format = Clipboard.kTextPlain;
    url ??= (await Clipboard.getData(format))?.text ?? '';

    late final String raw;
    if (useFile) {
      final file = File('temp.html');
      if (!await file.exists()) {
        raw = await _getUrl(url);
        await file.writeAsString(raw);
      } else {
        raw = await file.readAsString();
      }
    } else {
      raw = await _getUrl(url);
    }

    final document = html.parse(raw);

    const nameSel = 'h2[data-source="name"]';
    final name = document.querySelector(nameSel)?.text;
    final id = name?.toDbId();

    const titleSel = 'h2[data-item-name="secondary_title"]';
    final title = document.querySelector(titleSel)?.text;

    const regionSel = 'div[data-source="region"] a';
    final region = document.querySelector(regionSel)?.text;

    const raritySel = 'td[data-source="quality"] img';
    final rarity = document.querySelector(raritySel)?.attributes['title'] ?? '';
    final rarityInt = int.tryParse(rarity.split(' ').first);

    const weaponSel = 'td[data-source="weapon"] a';
    final weapon = document.querySelector(weaponSel)?.attributes['title'];

    const elementSel = 'td[data-source="element"] a:nth-child(2)';
    final element = document.querySelector(elementSel)?.text ?? '';

    const affiliationSel = 'div[data-source="affiliation"] div';
    final affiliation = document.querySelector(affiliationSel)?.text;

    const constellationSel = 'div[data-source="constellation"] div a';
    final constellation =
        document.querySelector(constellationSel)?.attributes['title'];

    const foodSel = 'div[data-source="dish"] .item_text';
    final food = document.querySelector(foodSel)?.text;

    const bdaySel = 'div[data-source="birthday"] div';
    final bday = document.querySelector(bdaySel)?.text;

    const wishSel = 'a[title="Wish"] img';
    var wish = document.querySelector(wishSel)?.attributes['src'];
    wish = wish != null ? _processImage(wish) : null;

    const releaseSel = 'div[data-source="releaseDate"] div';
    final release = document.querySelector(releaseSel)?.text;

    String parseDate(String value) {
      const months = [
        ...['january', 'february', 'march', 'april', 'may', 'june'],
        ...['july', 'august', 'september', 'october', 'november', 'december'],
      ];

      final values = value.split(' ');
      var month = values.elementAtOrNull(0)?.toLowerCase();
      month = month != null ? '${months.indexOf(month) + 1}' : '01';
      month = month.padLeft(2, '0');
      var day = values.elementAtOrNull(1);
      day = day?.characters.takeWhile((e) => e.isInt).join() ?? '01';
      day = day.padLeft(2, '0');
      var year = values.elementAtOrNull(2);
      year = year?.characters.takeWhile((e) => e.isInt).take(4).join();
      year = year?.padLeft(4, '0') ?? '0000';

      return '$year-$month-$day';
    }

    return item.copyWith(
      id: id,
      name: name,
      rarity: rarityInt,
      title: title,
      region: region?.toDbId(),
      weapon: GeWeaponType.values.fromId(weapon?.toDbId() ?? ''),
      element: GeElements.values.fromId(element.toDbId()),
      releaseDate: release != null ? parseDate(release) : null,
      constellation: constellation,
      affiliation: affiliation,
      specialDish: food?.toDbId(),
      birthday: bday != null ? parseDate(bday) : null,
      fullImage: wish,
    );
  }

  static Future<void> _importAscensionStatsFromAmbr({
    String? data,
    required List<List<String>> info,
  }) async {
    const format = Clipboard.kTextPlain;
    data ??= (await Clipboard.getData(format))?.text ?? '';

    const levels = [
      ...['1', '20', '20+', '40', '40+', '50', '50+'],
      ...['60', '60+', '70', '70+', '80', '80+', '90']
    ];

    for (final line in data.split('\n')) {
      final values = line
          .replaceAll('\t', ' ')
          .split(' ')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty);
      final ilvl = values.elementAtOrNull(0);
      if (ilvl == null) continue;
      if (!levels.contains(ilvl)) continue;

      void parseValue(List<String> lst, int idx) {
        final rValue = values.elementAtOrNull(idx)?.trim();
        if (rValue == null) return;

        if (ilvl.contains('+')) {
          final last = lst.lastOrNull ?? '';
          if (last != rValue && lst.isNotEmpty) {
            lst[lst.length - 1] = '$last → $rValue';
          }
          return;
        }

        lst.add(rValue);
      }

      info.forEachIndexed((lst, idx) => parseValue(lst, idx + 1));
    }
  }

  static Future<GsCharacterInfo> importCharacterAscensionStatsFromAmbr(
    GsCharacterInfo info, {
    String? data,
  }) async {
    final infos = <List<String>>[[], [], [], []];
    await _importAscensionStatsFromAmbr(info: infos);
    return info.copyWith(
      ascHpValues: infos[0].join(', '),
      ascAtkValues: infos[1].join(', '),
      ascDefValues: infos[2].join(', '),
      ascStatValues: infos[3].join(', '),
    );
  }

  static Future<GsWeaponInfo> importWeaponAscensionStatsFromAmbr(
    GsWeaponInfo info, {
    String? data,
  }) async {
    final infos = <List<String>>[[], []];
    await _importAscensionStatsFromAmbr(info: infos);
    return info.copyWith(
      ascAtkValues: infos[0].join(', '),
      ascStatValues: infos[1].join(', '),
    );
  }
}

Future<String> _getUrl(String url) async {
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  client.close();
  return await response.transform(utf8.decoder).join();
}

String _processImage(String value) {
  final idx = value.indexOf('/revision');
  if (idx != -1) return value.substring(0, idx);
  return value;
}
