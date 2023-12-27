// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_character_skin.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsCharacterSkin extends _GsCharacterSkin {
  @override
  final String id;
  @override
  final int rarity;
  @override
  final String name;
  @override
  final String image;
  @override
  final String version;
  @override
  final String character;
  @override
  final String sideImage;
  @override
  final String fullImage;

  /// Creates a new [GsCharacterSkin] instance.
  GsCharacterSkin({
    required this.id,
    required this.rarity,
    required this.name,
    required this.image,
    required this.version,
    required this.character,
    required this.sideImage,
    required this.fullImage,
  });

  /// Creates a new [GsCharacterSkin] instance from the given map.
  GsCharacterSkin.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        name = m['name'] as String? ?? '',
        image = m['image'] as String? ?? '',
        version = m['version'] as String? ?? '',
        character = m['character'] as String? ?? '',
        sideImage = m['side_image'] as String? ?? '',
        fullImage = m['full_image'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsCharacterSkin copyWith({
    String? id,
    int? rarity,
    String? name,
    String? image,
    String? version,
    String? character,
    String? sideImage,
    String? fullImage,
  }) {
    return GsCharacterSkin(
      id: id ?? this.id,
      rarity: rarity ?? this.rarity,
      name: name ?? this.name,
      image: image ?? this.image,
      version: version ?? this.version,
      character: character ?? this.character,
      sideImage: sideImage ?? this.sideImage,
      fullImage: fullImage ?? this.fullImage,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'rarity': rarity,
      'name': name,
      'image': image,
      'version': version,
      'character': character,
      'side_image': sideImage,
      'full_image': fullImage,
    };
  }
}
