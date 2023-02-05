import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsNamecard extends GsModel<GsNamecard> {
  @override
  final String id;
  final String name;
  final String type;
  final String version;
  final String image;
  final String desc;
  final String obtain;

  GsNamecard({
    this.id = '',
    this.name = '',
    this.type = '',
    this.version = '',
    this.image = '',
    this.desc = '',
    this.obtain = '',
  });

  GsNamecard.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        type = m.getString('type'),
        version = m.getString('version'),
        image = m.getString('image'),
        desc = m.getString('desc'),
        obtain = m.getString('obtain');

  @override
  GsNamecard copyWith({
    String? id,
    String? name,
    String? type,
    String? version,
    String? image,
    String? desc,
    String? obtain,
  }) {
    return GsNamecard(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      version: version ?? this.version,
      image: image ?? this.image,
      desc: desc ?? this.desc,
      obtain: obtain ?? this.obtain,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'version': version,
        'image': image,
        'desc': desc,
        'obtain': obtain,
        'type': type,
      };
}
