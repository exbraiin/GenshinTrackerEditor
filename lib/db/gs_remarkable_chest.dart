import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsRemarkableChest extends GsModel<GsRemarkableChest> {
  @override
  final String id;
  final String name;
  final String type;
  final String image;
  final int rarity;
  final int energy;
  final String region;
  final String source;
  final String version;
  final String category;

  GsRemarkableChest({
    this.id = '',
    this.name = '',
    this.type = '',
    this.image = '',
    this.version = '',
    this.region = '',
    this.source = '',
    this.category = '',
    this.rarity = 1,
    this.energy = 0,
  });

  GsRemarkableChest.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        type = m.getString('type'),
        image = m.getString('image'),
        rarity = m.getInt('rarity', 1),
        energy = m.getInt('energy'),
        region = m.getString('region'),
        source = m.getString('source'),
        version = m.getString('version'),
        category = m.getString('category');

  @override
  GsRemarkableChest copyWith({
    String? id,
    String? name,
    String? type,
    String? image,
    int? rarity,
    int? energy,
    String? region,
    String? source,
    String? version,
    String? category,
  }) {
    return GsRemarkableChest(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      energy: energy ?? this.energy,
      region: region ?? this.region,
      source: source ?? this.source,
      version: version ?? this.version,
      category: category ?? this.category,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'type': type,
        'image': image,
        'rarity': rarity,
        'energy': energy,
        'region': region,
        'source': source,
        'version': version,
        'category': category,
      };
}
