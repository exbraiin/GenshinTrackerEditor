import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsWeapon extends GsModel<GsWeapon> {
  @override
  final String id;
  final String name;
  final int rarity;
  final String image;
  final String imageAsc;
  final GeWeaponType type;
  final int atk;
  final GeWeaponAscensionStatType statType;
  final double statValue;
  final String desc;
  final String version;
  final GeItemSource source;

  GsWeapon._({
    this.id = '',
    this.name = '',
    this.rarity = 1,
    this.image = '',
    this.imageAsc = '',
    this.type = GeWeaponType.bow,
    this.atk = 0,
    this.statType = GeWeaponAscensionStatType.none,
    this.statValue = 0,
    this.desc = '',
    this.version = '',
    this.source = GeItemSource.event,
  });

  GsWeapon.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        rarity = m.getInt('rarity', 1),
        image = m.getString('image'),
        imageAsc = m.getString('image_asc'),
        type = GeWeaponType.values.fromId(m.getString('type')),
        atk = m.getInt('atk'),
        statType =
            GeWeaponAscensionStatType.values.fromId(m.getString('stat_type')),
        statValue = m.getDouble('stat_value'),
        desc = m.getString('desc'),
        version = m.getString('version'),
        source = GeItemSource.values
            .fromId(m.getString('obtain', m.getString('source')));

  @override
  GsWeapon copyWith({
    String? id,
    String? name,
    int? rarity,
    String? image,
    String? imageAsc,
    GeWeaponType? type,
    int? atk,
    GeWeaponAscensionStatType? statType,
    double? statValue,
    String? desc,
    String? version,
    GeItemSource? source,
  }) {
    return GsWeapon._(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      image: image ?? this.image,
      imageAsc: imageAsc ?? this.imageAsc,
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
        'image_asc': imageAsc,
        'version': version,
        'rarity': rarity,
        'type': type.id,
        'atk': atk,
        'stat_type': statType.id,
        'stat_value': statValue,
        'desc': desc,
        'source': source.id,
      };
}
