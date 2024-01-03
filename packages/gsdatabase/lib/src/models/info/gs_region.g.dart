// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_region.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsRegion extends _GsRegion {
  @override
  final String id;
  @override
  final String name;
  @override
  final String image;
  @override
  final String imageInGame;
  @override
  final String archon;
  @override
  final String ideal;
  @override
  final GeElementType element;
  @override
  final List<int> reputation;

  /// Creates a new [GsRegion] instance.
  GsRegion({
    required this.id,
    required this.name,
    required this.image,
    required this.imageInGame,
    required this.archon,
    required this.ideal,
    required this.element,
    required this.reputation,
  });

  /// Creates a new [GsRegion] instance from the given map.
  GsRegion.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        image = m['image'] as String? ?? '',
        imageInGame = m['image_ingame'] as String? ?? '',
        archon = m['archon'] as String? ?? '',
        ideal = m['ideal'] as String? ?? '',
        element = GeElementType.values.fromId(m['element']),
        reputation = (m['reputation'] as List? ?? const []).cast<int>();

  /// Copies this model with the given parameters.
  @override
  GsRegion copyWith({
    String? id,
    String? name,
    String? image,
    String? imageInGame,
    String? archon,
    String? ideal,
    GeElementType? element,
    List<int>? reputation,
  }) {
    return GsRegion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      imageInGame: imageInGame ?? this.imageInGame,
      archon: archon ?? this.archon,
      ideal: ideal ?? this.ideal,
      element: element ?? this.element,
      reputation: reputation ?? this.reputation,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'image_ingame': imageInGame,
      'archon': archon,
      'ideal': ideal,
      'element': element.id,
      'reputation': reputation,
    };
  }
}
