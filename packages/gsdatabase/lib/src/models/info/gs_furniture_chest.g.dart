// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_furniture_chest.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsFurnitureChest extends GsModel<GsFurnitureChest> {
  @override
  final String id;
  final String name;
  final GeSereniteaSetType type;
  final String image;
  final int rarity;
  final int energy;
  final GeRegionType region;
  final String version;

  /// Creates a new [GsFurnitureChest] instance.
  GsFurnitureChest({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.rarity,
    required this.energy,
    required this.region,
    required this.version,
  });

  /// Creates a new [GsFurnitureChest] instance from the given map.
  GsFurnitureChest.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        type = GeSereniteaSetType.values.fromId(m['type']),
        image = m['image'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        energy = m['energy'] as int? ?? 0,
        region = GeRegionType.values.fromId(m['region']),
        version = m['version'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsFurnitureChest copyWith({
    String? id,
    String? name,
    GeSereniteaSetType? type,
    String? image,
    int? rarity,
    int? energy,
    GeRegionType? region,
    String? version,
  }) {
    return GsFurnitureChest(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      energy: energy ?? this.energy,
      region: region ?? this.region,
      version: version ?? this.version,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.id,
      'image': image,
      'rarity': rarity,
      'energy': energy,
      'region': region.id,
      'version': version,
    };
  }
}
