import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsWeapon extends GsModel {
  @override
  final String id;
  final String name;
  final int rarity;
  final String image;
  final String type;
  final int atk;
  final String statType;
  final double statValue;
  final String desc;
  final String version;
  final String source;

  GsWeapon._({
    this.id = '',
    this.name = '',
    this.rarity = 1,
    this.image = '',
    this.type = '',
    this.atk = 0,
    this.statType = '',
    this.statValue = 0,
    this.desc = '',
    this.version = '',
    this.source = '',
  });

  GsWeapon.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        rarity = m.getInt('rarity', 1),
        image = m.getString('image'),
        type = m.getString('type'),
        atk = m.getInt('atk'),
        statType = m.getString('stat_type'),
        statValue = m.getDouble('stat_value'),
        desc = m.getString('desc'),
        version = m.getString('version'),
        source = m.getString('obtain', m.getString('source'));

  GsWeapon copyWith({
    String? id,
    String? name,
    int? rarity,
    String? image,
    String? type,
    int? atk,
    String? statType,
    double? statValue,
    String? desc,
    String? version,
    String? source,
  }) {
    return GsWeapon._(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      image: image ?? this.image,
      type: type ?? this.type,
      atk: atk ?? this.atk,
      statType: statType ?? this.statType,
      statValue: statValue ?? this.statValue,
      desc: desc ?? this.desc,
      version: version ?? this.version,
      source: source ?? this.source,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'image': image,
        'version': version,
        'rarity': rarity,
        'type': type,
        'atk': atk,
        'stat_type': statType,
        'stat_value': statValue,
        'desc': desc,
        'source': source,
      };
}
