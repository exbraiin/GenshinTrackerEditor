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
      return b != null && !a.equalsTo(b);
    });

    final grpRmv = oldGrps.count((a) => !newGrps.any((b) => b.id == a.id));
    final grpAdd = newGrps.count((a) => !oldGrps.any((b) => b.id == a.id));
    final grpMdf = newGrps.count((a) {
      final b = oldGrps.firstOrNullWhere((b) => b.id == a.id);
      return b != null && !a.equalsTo(b);
    });

    return Changes(achRmv, achMdf, achAdd, grpRmv, grpMdf, grpAdd);
  }
}

abstract final class Importer {
  static const _asc = [20, 40, 50, 60, 70, 80];
  static Future<Changes?> importAchievementsFromPaimonMoe() async {
    const url = 'https://raw.githubusercontent.com/MadeBaruna/'
        'paimon-moe/main/src/data/achievement/en.json';
    final responseJson = await _getUrl(url);
    final data = jsonDecode(responseJson) as Map;

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

  static String? _processPaimonMoeStats(
    List<num?> values, {
    bool isPercent = false,
  }) {
    String? format(num? v) {
      if (v == null) return null;
      if (!isPercent) return v.round().toString();
      var percent = (v * 100).toStringAsFixed(1);
      if (percent.endsWith('.0')) percent = (v * 100).toStringAsFixed(0);
      return '$percent%';
    }

    return [1, ..._asc, 90]
        .map((level) {
          if (level == 1) return format(values.elementAtOrNull(level));
          late final i = _asc.count((v) => v < level);
          late final b = values.elementAtOrNull(level + i);
          late final a = values.elementAtOrNull(level + i + 1);
          if (b == null) return null;
          if (a == null) return format(b);
          if (b == a) return format(b);
          return '${format(b)} → ${format(a)}';
        })
        .whereType<String>()
        .join(', ');
  }

  static Future<GsWeaponInfo> importWeaponInfoFromPaimonMoe(
    GsWeaponInfo info,
  ) async {
    const url = 'https://raw.githubusercontent.com/MadeBaruna/'
        '/paimon-moe/main/src/data/weapons/en.json';
    final responseJson = await _getUrl(url);
    final data = jsonDecode(responseJson) as Map;

    final json = data[info.id] as JsonMap?;
    if (json == null) return info;

    final listAtk = (json['atk'] as List? ?? []).cast<num?>();
    final listStat = (json['secondary']?['stats'] as List? ?? []).cast<num?>();
    final stat = json['secondary']?['name'] as String? ?? '';
    final isPercent = stat != 'em';

    final weaponStat = GeWeaponAscensionStatType.values.fromId(stat);
    final skillName = json['skill']?['name'];
    final skillDesc =
        _getHtmlText(json['skill']?['description'] as String? ?? '');

    return info.copyWith(
      effectName: skillName,
      effectDesc: skillDesc,
      ascStatType: weaponStat,
      ascAtkValues: _processPaimonMoeStats(listAtk),
      ascStatValues: _processPaimonMoeStats(listStat, isPercent: isPercent),
    );
  }

  static Future<GsCharacterInfo> importCharacterInfoFromPaimonMoe(
    GsCharacterInfo info,
  ) async {
    final url = 'https://raw.githubusercontent.com/MadeBaruna/'
        '/paimon-moe/main/src/data/characterData/${info.id}.json';
    final responseJson = await _getUrl(url);
    final json = jsonDecode(responseJson) as Map;

    final stat = json['statGrow'] as String? ?? '';
    final listHp = (json['hp'] as List? ?? []).cast<num?>();
    final listAtk = (json['atk'] as List? ?? []).cast<num?>();
    final listDef = (json['def'] as List? ?? []).cast<num?>();
    final listStat = (json[stat] as List? ?? []).cast<num?>();

    final iPassives = (json['passives'] as List).cast<JsonMap>();
    final iTalents = {
      GeCharacterTalentType.normalAttack: json['attack'] as JsonMap?,
      GeCharacterTalentType.elementalSkill: json['elementalSkill'] as JsonMap?,
      GeCharacterTalentType.alternateSprint: json['dashSkill'] as JsonMap?,
      GeCharacterTalentType.elementalBurst: json['burst'] as JsonMap?,
      GeCharacterTalentType.ascension1stPassive: iPassives.elementAtOrNull(0),
      GeCharacterTalentType.ascension4thPassive: iPassives.elementAtOrNull(1),
      GeCharacterTalentType.utilityPassive: iPassives.elementAtOrNull(2),
    };

    final talents = iTalents.entries.map((e) {
      return GsCharTalent(
        name: e.value?['name'] as String? ?? '',
        desc: _getHtmlText(e.value?['description'] as String? ?? ''),
        type: e.key,
      );
    }).toList();

    final iConstellations = (json['constellations'] as List).cast<JsonMap>();
    final constellations = List.generate(6, (idx) {
      final cons = iConstellations[idx];
      return GsCharConstellation(
        name: cons['name'] as String? ?? '',
        type: GeCharacterConstellationType.values[idx],
        desc: _getHtmlText(cons['description'] as String? ?? ''),
      );
    }).toList();

    final charStat = GeCharacterAscensionStatType.values.fromId(stat);
    final isPercent = stat != 'em';
    return info.copyWith(
      ascStatType: charStat,
      talents: talents,
      constellations: constellations,
      ascHpValues: _processPaimonMoeStats(listHp),
      ascAtkValues: _processPaimonMoeStats(listAtk),
      ascDefValues: _processPaimonMoeStats(listDef),
      ascStatValues: _processPaimonMoeStats(listStat, isPercent: isPercent),
    );
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
      ...['60', '60+', '70', '70+', '80', '80+', '90'],
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

  static Future<GsCharacterInfo> importCharacterStatsFromAmbr(
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

final _cache = <String, String>{};
Future<String> _getUrl(String url) async {
  if (_cache.containsKey(url)) return _cache[url]!;
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  client.close();
  return _cache[url] = await response.transform(utf8.decoder).join();
}

String _processImage(String value) {
  final idx = value.indexOf('/revision');
  if (idx != -1) return value.substring(0, idx);
  return value;
}

String _getHtmlText(String value) =>
    (html.parse(value).body?.text ?? '').replaceAll('\\n', '\n');
