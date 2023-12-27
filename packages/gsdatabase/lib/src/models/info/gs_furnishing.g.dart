// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_furnishing.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsFurnishing extends _GsFurnishing {
  @override
  final String id;
  @override
  final String name;
  @override
  final String image;
  @override
  final int rarity;

  /// Creates a new [GsFurnishing] instance.
  GsFurnishing({
    required this.id,
    required this.name,
    required this.image,
    required this.rarity,
  });

  /// Creates a new [GsFurnishing] instance from the given map.
  GsFurnishing.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        image = m['image'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GsFurnishing copyWith({
    String? id,
    String? name,
    String? image,
    int? rarity,
  }) {
    return GsFurnishing(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rarity': rarity,
    };
  }
}
