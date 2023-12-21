import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:gsdatabase/gsdatabase.dart';
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
  final GeElementType element;

  GsEnkaChar.fromJson(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        icon = (map['SideIconName'] ?? '').isNotEmpty
            ? 'https://enka.network/ui/${map['SideIconName']}.png'
            : '',
        rarity = _rarity[map['QualityType']] ?? 1,
        element = _elements[map['Element']] ?? GeElementType.anemo;
}

const _rarity = {
  'QUALITY_ORANGE_SP': 5,
  'QUALITY_ORANGE': 5,
  'QUALITY_PURPLE': 4,
};

const _elements = {
  'Wind': GeElementType.anemo,
  'Rock': GeElementType.geo,
  'Electric': GeElementType.electro,
  'Grass': GeElementType.dendro,
  'Water': GeElementType.hydro,
  'Fire': GeElementType.pyro,
  'Ice': GeElementType.cryo,
};
