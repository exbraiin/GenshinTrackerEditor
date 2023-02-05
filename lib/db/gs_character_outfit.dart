import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsCharacterOutfit extends GsModel<GsCharacterOutfit> {
  @override
  final String id;
  final int rarity;
  final String name;
  final String image;
  final String version;
  final String character;
  final String fullImage;

  GsCharacterOutfit._({
    required this.id,
    required this.rarity,
    required this.name,
    required this.image,
    required this.version,
    required this.character,
    required this.fullImage,
  });

  GsCharacterOutfit.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        image = m.getString('image'),
        rarity = m.getInt('rarity'),
        version = m.getString('version'),
        character = m.getString('character'),
        fullImage = m.getString('full_image');

  @override
  GsCharacterOutfit copyWith({
    String? id,
    int? rarity,
    String? name,
    String? image,
    String? version,
    String? character,
    String? fullImage,
  }) {
    return GsCharacterOutfit._(
      id: id ?? this.id,
      rarity: rarity ?? this.rarity,
      name: name ?? this.name,
      image: image ?? this.image,
      version: version ?? this.version,
      character: character ?? this.character,
      fullImage: fullImage ?? this.fullImage,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'image': image,
        'rarity': rarity,
        'version': version,
        'character': character,
        'full_image': fullImage,
      };
}
