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
  final int achRmv, achMdf, achAdd;
  final int grpRmv, grpMdf, grpAdd;

  Changes(
    this.achRmv,
    this.achMdf,
    this.achAdd,
    this.grpRmv,
    this.grpMdf,
    this.grpAdd,
  );

  factory Changes.fromData(
    Iterable<GsAchievementGroup> oldGrps,
    Iterable<GsAchievementGroup> newGrps,
    Iterable<GsAchievement> oldAchs,
    Iterable<GsAchievement> newAchs,
  ) {
    final achRmv = oldAchs.count((a) => !newAchs.any((b) => b.id == a.id));
    final achAdd = newAchs.count((a) => !oldAchs.any((b) => b.id == a.id));
    final achMdf = newAchs.count((a) {
      final b = oldAchs.firstOrNullWhere((b) => b.id == a.id);
      return b != null && !_isSameAch(a, b);
    });

    final grpRmv = oldGrps.count((a) => !newGrps.any((b) => b.id == a.id));
    final grpAdd = newGrps.count((a) => !oldGrps.any((b) => b.id == a.id));
    final grpMdf = newGrps.count((a) {
      final b = oldGrps.firstOrNullWhere((b) => b.id == a.id);
      return b != null && !_isSameGrp(a, b);
    });

    return Changes(achRmv, achMdf, achAdd, grpRmv, grpMdf, grpAdd);
  }

  static bool _isSameAch(GsAchievement a, GsAchievement b) {
    if (a == b) return true;
    return a.id == b.id &&
        a.group == b.group &&
        a.hidden == b.hidden &&
        a.name == b.name &&
        a.type == b.type &&
        a.version == b.version &&
        a.phases.length == b.phases.length &&
        a.phases
            .zip(
              b.phases,
              (itemA, itemB) =>
                  itemA.id == itemB.id &&
                  itemA.desc == itemB.desc &&
                  itemA.reward == itemB.reward,
            )
            .all((e) => e);
  }

  static bool _isSameGrp(GsAchievementGroup a, GsAchievementGroup b) {
    if (a == b) return true;
    return a.id == b.id &&
        a.name == b.name &&
        a.icon == b.icon &&
        a.version == b.version &&
        a.namecard == b.namecard &&
        a.order == b.order &&
        a.rewards == b.rewards &&
        a.achievements == b.achievements;
  }
}

abstract final class Importer {
  static Future<Changes?> importAchievementsFromAmbrJson(
    String path,
  ) async {
    final file = File(path);
    if (!await file.exists()) return null;
    final data = jsonDecode(await file.readAsString()) as Map;

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
        'phases': list
            .map((e) => {'desc': e['desc'], 'reward': e['reward']})
            .toList(),
      };
    }

    final grps = <Map<String, dynamic>>[];
    final achs = <Map<String, dynamic>>[];
    for (final group in data.values.cast<Map>()) {
      final groupOrder = group['order'] as int? ?? 0;
      final groupName = group['name'] as String? ?? '';

      grps.add({
        'id': groupName.toDbId(),
        'name': groupName,
        'order': groupOrder,
      });

      achs.addAll(
        (group['achievements'] as List? ?? []).map(
          (ach) => ach is List
              ? parseAchievement(groupName, ach.cast<Map<String, dynamic>>())
              : parseAchievement(groupName, [ach]),
        ),
      );
    }

    final inDbAchs = Database.i.achievements.data.toList();
    final inDbGrps = Database.i.achievementGroups.data.toList();

    final impAchs = achs.map(GsAchievement.fromMap);
    Database.i.achievements.updateAll(impAchs);

    final tmpGrps = grps.map(GsAchievementGroup.fromMap).toList();
    final impGrps = await compute(
      (tuple) => tuple.grps.map((e) {
        final exist = tuple.dbGrps.firstOrNullWhere((t) => t.id == e.id);
        final items = tuple.dbAchs.where((t) => t.group == e.id);
        return e.copyWith(
          icon: exist?.icon,
          namecard: exist?.namecard,
          version: items.maxBy((t) => t.version)?.version,
          rewards: items.sumBy((t) => t.reward),
          achievements: items.sumBy((t) => t.phases.length),
        );
      }),
      (grps: tmpGrps, dbGrps: inDbGrps, dbAchs: inDbAchs),
    );
    Database.i.achievementGroups.updateAll(impGrps);

    await DataValidator.i.checkAll();
    Database.i.modified.add(null);

    return Changes.fromData(inDbGrps, impGrps, inDbAchs, impAchs);
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
