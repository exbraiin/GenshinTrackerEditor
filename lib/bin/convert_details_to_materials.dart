import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

void convertCharacterDetailsToInfo() {
  final file = File('src/characters_details.json');
  final data = jsonDecode(file.readAsStringSync()) as JsonMap;

  final output = <String, dynamic>{};

  for (var entry in data.entries) {
    final asc = (entry.value['ascension'] as List? ?? []).cast<JsonMap>();
    final ascStatType = (asc.first['values_after'] as JsonMap).keys.last;

    const tKey = 'talents_materials';
    final tal = (entry.value[tKey] as List? ?? []).cast<JsonMap>();

    String getAscMaterial(List<String> types, [int idx = 1]) {
      final map = asc.elementAtOrNull(idx);
      if (map == null) return '';
      final materials = (map['materials'] as JsonMap? ?? {}).keys;
      final data = Database.i.getMaterialGroups(types);
      return materials
              .firstOrNullWhere((mat) => data.any((d) => d.id == mat)) ??
          '';
    }

    String getTalMaterial(List<String> types, [int idx = 0]) {
      final map = tal.elementAtOrNull(idx);
      if (map == null) return '';
      final data = Database.i.getMaterialGroups(types);
      return map.keys.firstOrNullWhere((mat) => data.any((d) => d.id == mat)) ??
          '';
    }

    final sufix = ascStatType == 'elementalMastery' ? '' : '%';

    final map = {
      'mat_gem': getAscMaterial(['ascension_gems']),
      'mat_boss': getAscMaterial(['normal_boss_drops'], 2),
      'mat_common': getAscMaterial(['normal_drops', 'elite_drops']),
      'mat_region': getAscMaterial(GsConfigurations.matCatRegionCommon),
      'mat_talent': getTalMaterial(GsConfigurations.matCatRegionTalent),
      'mat_weekly': getTalMaterial(['weekly_boss_drops'], 5),
      'asc_stat_type': ascStatType,
      'asc_hp_values': _extract(asc, 'hp').join(', '),
      'asc_atk_values': _extract(asc, 'atk').join(', '),
      'asc_def_values': _extract(asc, 'def').join(', '),
      'asc_stat_values': _extract(asc, ascStatType, sufix).join(', '),
      'talents': entry.value['talents'],
      'constellations': entry.value['constellations'],
    };

    output[entry.key] = map;
  }

  File('src/characters_info.json').writeAsStringSync(jsonEncode(output));
  // ignore: avoid_print
  print('DONE');
}

Future<void> convertWeaponDetailsToInfo() async {
  final file = File('src/weapons_details.json');
  final data = jsonDecode(await file.readAsString()) as JsonMap;

  final output = data.entries.map((e) {
    final name = e.value['effect_name'] as String? ?? '';
    var desc = e.value['effect_desc'] as String? ?? '';
    final values = e.value['effect_values'] as List? ?? [];
    final effects = values.firstOrNull as List? ?? [];
    for (var v = 0; v < effects.length; ++v) {
      final temp = List.generate(values.length, (i) => values[i][v]);
      desc = desc.replaceFirst('{$v}', '{${temp.join(',')}}');
    }

    final asc = (e.value['ascension'] as List? ?? []).cast<JsonMap>();
    final mats = (asc.elementAtOrNull(1))?['materials'] as JsonMap?;
    final materials = mats?.keys ?? [];

    final matWeapon = Database.i
        .getMaterialGroups(GsConfigurations.matCatRegionWeapon)
        .firstOrNullWhere((element) => materials.contains(element.id));
    final matCommon = Database.i
        .getMaterialGroup('normal_drops')
        .firstOrNullWhere((element) => materials.contains(element.id));
    final matElite = Database.i
        .getMaterialGroup('elite_drops')
        .firstOrNullWhere((element) => materials.contains(element.id));

    final after = asc.elementAtOrNull(0)?['values_after'] as JsonMap?;
    final stat = after?.keys.firstOrNullWhere((e) => e != 'atk');
    final sufix = stat == 'elementalMastery' ? '' : '%';

    final value = <String, dynamic>{
      'effect_name': name,
      'effect_desc': desc,
      'mat_weapon': matWeapon?.id ?? '',
      'mat_common': matCommon?.id ?? '',
      'mat_elite': matElite?.id ?? '',
      'asc_stat_type': stat ?? '',
      'asc_atk_values': _extract(asc, 'atk').join(', '),
      'asc_stat_values':
          stat != null ? _extract(asc, stat, sufix).join(', ') : '',
    };
    return MapEntry(e.key, value);
  }).toMap();

  final encoded = jsonEncode(output);
  await File('src/weapons_info.json').writeAsString(encoded);
}

List<String> _extract(
  List<Map<String, dynamic>> list,
  String stat, [
  String sufix = '',
]) {
  String format(num value) {
    final numInt = value.toInt();
    final numDouble = value.toDouble();
    if (numInt == numDouble) return '$numInt';
    return '$numDouble';
  }

  return list
      .map((e) {
        final b = e['values_before'] as JsonMap? ?? {};
        final a = e['values_after'] as JsonMap? ?? {};
        final vb = b[stat];
        final va = a[stat];
        if (vb == null && va != null) return '${format(va)}$sufix';
        if (vb != null && va == null) return '${format(vb)}$sufix';
        if (vb == va) return '${format(vb)}$sufix';
        return '${format(vb)}$sufix → ${format(va)}$sufix';
      })
      .where((element) => element.isNotEmpty)
      .toList();
}
