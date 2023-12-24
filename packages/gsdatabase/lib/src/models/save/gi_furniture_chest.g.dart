// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_furniture_chest.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiFurnitureChest extends GsModel<GiFurnitureChest>
    with _GiFurnitureChest {
  @override
  final String id;
  @override
  final bool obtained;

  /// Creates a new [GiFurnitureChest] instance.
  GiFurnitureChest({
    required this.id,
    required this.obtained,
  });

  /// Creates a new [GiFurnitureChest] instance from the given map.
  GiFurnitureChest.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        obtained = m['obtained'] as bool? ?? false;

  /// Copies this model with the given parameters.
  @override
  GiFurnitureChest copyWith({
    String? id,
    bool? obtained,
  }) {
    return GiFurnitureChest(
      id: id ?? this.id,
      obtained: obtained ?? this.obtained,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'obtained': obtained,
    };
  }
}
