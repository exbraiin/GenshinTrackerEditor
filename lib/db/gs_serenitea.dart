import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsSerenitea extends GsModel<GsSerenitea> {
  @override
  final String id;
  final String name;
  final GeSereniteaSets category;
  final String image;
  final int rarity;
  final int energy;
  final List<String> chars;
  final String version;

  GsSerenitea({
    this.id = '',
    this.name = '',
    this.category = GeSereniteaSets.indoor,
    this.image = '',
    this.rarity = 0,
    this.energy = 0,
    this.chars = const [],
    this.version = '',
  });

  GsSerenitea.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        category = GeSereniteaSets.fromId(m.getString('category')),
        image = m.getString('image'),
        rarity = m.getInt('rarity'),
        energy = m.getInt('energy'),
        chars = m.getStringList('chars'),
        version = m.getString('version');

  @override
  GsSerenitea copyWith({
    String? id,
    String? name,
    String? image,
    int? rarity,
    int? energy,
    List<String>? chars,
    String? version,
    GeSereniteaSets? category,
  }) {
    return GsSerenitea(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      energy: energy ?? this.energy,
      chars: chars ?? this.chars,
      version: version ?? this.version,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'image': image,
        'rarity': rarity,
        'energy': energy,
        'category': category.id,
        'chars': chars,
        'version': version,
      };
}
