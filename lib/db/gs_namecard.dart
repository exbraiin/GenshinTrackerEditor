import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsNamecard extends GsModel<GsNamecard> {
  @override
  final String id;
  final String name;
  final int rarity;
  final String type;
  final String version;
  final String image;
  final String fullImage;
  final String desc;
  final String obtain;

  GsNamecard({
    this.id = '',
    this.name = '',
    this.rarity = 0,
    this.type = '',
    this.version = '',
    this.image = '',
    this.fullImage = '',
    this.desc = '',
    this.obtain = '',
  });

  GsNamecard.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        rarity = m.getInt('rarity'),
        type = m.getString('type'),
        version = m.getString('version'),
        image = m.getString('image'),
        fullImage = m.getString('full_image'),
        desc = m.getString('desc'),
        obtain = m.getString('obtain');

  @override
  GsNamecard copyWith({
    String? id,
    String? name,
    int? rarity,
    String? type,
    String? version,
    String? image,
    String? fullImage,
    String? desc,
    String? obtain,
  }) {
    return GsNamecard(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      type: type ?? this.type,
      version: version ?? this.version,
      image: image ?? this.image,
      fullImage: fullImage ?? this.fullImage,
      desc: desc ?? this.desc,
      obtain: obtain ?? this.obtain,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'rarity': rarity,
        'version': version,
        'image': image,
        'full_image': fullImage,
        'desc': desc,
        'obtain': obtain,
        'type': type,
      };
}
