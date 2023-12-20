// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_material.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsMaterial extends GsModel<GsMaterial> {
  @override
  final String id;
  final String name;
  final String desc;
  final int rarity;
  final GeMaterialType group;
  final String image;
  final GeRegionType region;
  final int subgroup;
  final String version;
  final bool ingredient;
  final List<GeWeekdayType> weekdays;

  /// Creates a new [GsMaterial] instance.
  GsMaterial({
    required this.id,
    required this.name,
    required this.desc,
    required this.rarity,
    required this.group,
    required this.image,
    required this.region,
    required this.subgroup,
    required this.version,
    required this.ingredient,
    required this.weekdays,
  });

  /// Creates a new [GsMaterial] instance from the given map.
  GsMaterial.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        desc = m['desc'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        group = GeMaterialType.values.fromId(m['group']),
        image = m['image'] as String? ?? '',
        region = GeRegionType.values.fromId(m['region']),
        subgroup = m['subgroup'] as int? ?? 0,
        version = m['version'] as String? ?? '',
        ingredient = m['ingredient'] as bool? ?? false,
        weekdays = GeWeekdayType.values
            .fromIds((m['weekdays'] as List? ?? const []).cast<String>());

  /// Copies this model with the given parameters.
  @override
  GsMaterial copyWith({
    String? id,
    String? name,
    String? desc,
    int? rarity,
    GeMaterialType? group,
    String? image,
    GeRegionType? region,
    int? subgroup,
    String? version,
    bool? ingredient,
    List<GeWeekdayType>? weekdays,
  }) {
    return GsMaterial(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      rarity: rarity ?? this.rarity,
      group: group ?? this.group,
      image: image ?? this.image,
      region: region ?? this.region,
      subgroup: subgroup ?? this.subgroup,
      version: version ?? this.version,
      ingredient: ingredient ?? this.ingredient,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'rarity': rarity,
      'group': group.id,
      'image': image,
      'region': region.id,
      'subgroup': subgroup,
      'version': version,
      'ingredient': ingredient,
      'weekdays': weekdays.map((e) => e.id).toList(),
    };
  }
}
