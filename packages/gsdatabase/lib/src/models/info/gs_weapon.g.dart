// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_weapon.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsWeapon extends GsModel<GsWeapon> {
  @override
  final String id;
  final String name;
  final int rarity;
  final String image;
  final String imageAsc;
  final GeWeaponType type;
  final int atk;
  final GeWeaponAscStatType statType;
  final double statValue;
  final String desc;
  final String version;
  final GeItemSourceType source;
  final String effectName;
  final String effectDesc;
  final String matWeapon;
  final String matCommon;
  final String matElite;
  final String ascAtkValues;
  final String ascStatValues;

  /// Creates a new [GsWeapon] instance.
  GsWeapon({
    required this.id,
    required this.name,
    required this.rarity,
    required this.image,
    required this.imageAsc,
    required this.type,
    required this.atk,
    required this.statType,
    required this.statValue,
    required this.desc,
    required this.version,
    required this.source,
    required this.effectName,
    required this.effectDesc,
    required this.matWeapon,
    required this.matCommon,
    required this.matElite,
    required this.ascAtkValues,
    required this.ascStatValues,
  });

  /// Creates a new [GsWeapon] instance from the given map.
  GsWeapon.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        image = m['image'] as String? ?? '',
        imageAsc = m['image_asc'] as String? ?? '',
        type = GeWeaponType.values.fromId(m['type']),
        atk = m['atk'] as int? ?? 0,
        statType = GeWeaponAscStatType.values.fromId(m['stat_type']),
        statValue = m['stat_value'] as double? ?? 0,
        desc = m['desc'] as String? ?? '',
        version = m['version'] as String? ?? '',
        source = GeItemSourceType.values.fromId(m['source']),
        effectName = m['effect_name'] as String? ?? '',
        effectDesc = m['effect_desc'] as String? ?? '',
        matWeapon = m['mat_weapon'] as String? ?? '',
        matCommon = m['mat_common'] as String? ?? '',
        matElite = m['mat_elite'] as String? ?? '',
        ascAtkValues = m['asc_atk_values'] as String? ?? '',
        ascStatValues = m['asc_stat_values'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsWeapon copyWith({
    String? id,
    String? name,
    int? rarity,
    String? image,
    String? imageAsc,
    GeWeaponType? type,
    int? atk,
    GeWeaponAscStatType? statType,
    double? statValue,
    String? desc,
    String? version,
    GeItemSourceType? source,
    String? effectName,
    String? effectDesc,
    String? matWeapon,
    String? matCommon,
    String? matElite,
    String? ascAtkValues,
    String? ascStatValues,
  }) {
    return GsWeapon(
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
      effectName: effectName ?? this.effectName,
      effectDesc: effectDesc ?? this.effectDesc,
      matWeapon: matWeapon ?? this.matWeapon,
      matCommon: matCommon ?? this.matCommon,
      matElite: matElite ?? this.matElite,
      ascAtkValues: ascAtkValues ?? this.ascAtkValues,
      ascStatValues: ascStatValues ?? this.ascStatValues,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'rarity': rarity,
      'image': image,
      'image_asc': imageAsc,
      'type': type.id,
      'atk': atk,
      'stat_type': statType.id,
      'stat_value': statValue,
      'desc': desc,
      'version': version,
      'source': source.id,
      'effect_name': effectName,
      'effect_desc': effectDesc,
      'mat_weapon': matWeapon,
      'mat_common': matCommon,
      'mat_elite': matElite,
      'asc_atk_values': ascAtkValues,
      'asc_stat_values': ascStatValues,
    };
  }
}
