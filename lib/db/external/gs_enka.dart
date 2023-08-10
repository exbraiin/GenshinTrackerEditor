import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:http/http.dart' as http;

class GsEnka {
  static final i = GsEnka._();

  final characters = <GsEnkaChar>[];
  GsEnka._();

  Future<void> load() async {
    if (characters.isNotEmpty) return;
    const url = 'https://raw.githubusercontent.com/EnkaNetwork'
        '/API-docs/master/store/characters.json';

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final chars = json.entries
        .map((e) => GsEnkaChar.fromJson({'id': e.key, ...e.value}))
        .distinctBy((e) => e.id)
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => element.icon.isNotEmpty ? 0 : 1)
        .toList();
    characters.addAll(chars);
  }
}

class GsEnkaChar {
  final String id;
  final String icon;
  final int rarity;
  final GeElements element;

  GsEnkaChar.fromJson(JsonMap map)
      : id = map.getString('id'),
        icon = map.getString('SideIconName').isNotEmpty
            ? 'https://enka.network/ui/${map.getString('SideIconName')}.png'
            : '',
        rarity = _rarity[map.getString('QualityType')] ?? 1,
        element = _elements[map.getString('Element')] ?? GeElements.anemo;
}

const _rarity = {
  'QUALITY_ORANGE_SP': 5,
  'QUALITY_ORANGE': 5,
  'QUALITY_PURPLE': 4,
};

const _elements = {
  'Wind': GeElements.anemo,
  'Rock': GeElements.geo,
  'Electric': GeElements.electro,
  'Grass': GeElements.dendro,
  'Water': GeElements.hydro,
  'Fire': GeElements.pyro,
  'Ice': GeElements.cryo,
};
