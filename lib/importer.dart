import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;

class Importer {
  Importer._();

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

      final item = GsAchievement.fromMap({
        'id': '${category.id} $name $reward'.toDbId(),
        'name': name,
        'desc': desc,
        'type': type,
        'group': category.id,
        'hidden': hidden,
        'reward': reward,
        'version': version,
      });
      achvs.add(item);
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
    wish = wish != null ? GsDataParser.processImage(wish) : null;

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
      weapon: weapon?.toDbId(),
      element: element.toDbId(),
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
