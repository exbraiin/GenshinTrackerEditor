import 'package:data_editor/db/database.dart';

class GsIngredient extends GsModel<GsIngredient> {
  @override
  final String id;
  final String name;
  final int rarity;
  final String desc;
  final String image;
  final String version;

  GsIngredient({
    this.id = '',
    this.name = '',
    this.rarity = 1,
    this.desc = '',
    this.image = '',
    this.version = '',
  });

  GsIngredient.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        rarity = m.getInt('rarity', 1),
        desc = m.getString('desc'),
        image = m.getString('image'),
        version = m.getString('version');

  @override
  GsIngredient copyWith({
    String? id,
    String? name,
    int? rarity,
    String? desc,
    String? image,
    String? version,
  }) {
    return GsIngredient(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      desc: desc ?? this.desc,
      image: image ?? this.image,
      version: version ?? this.version,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'desc': desc,
        'image': image,
        'rarity': rarity,
        'version': version,
      };
}
