import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsVersion extends GsModel {
  @override
  final String id;
  final String name;
  final String image;
  final String releaseDate;

  DateTime get dateTime => DateTime.tryParse(releaseDate) ?? DateTime(0);

  GsVersion({
    this.id = '',
    this.name = '',
    this.image = '',
    this.releaseDate = '',
  });

  GsVersion.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        image = m.getString('image'),
        releaseDate = m.getString('release_date');

  GsVersion copyWith({
    String? id,
    String? name,
    String? image,
    String? releaseDate,
  }) {
    return GsVersion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'release_date': releaseDate,
        'name': name,
        'image': image,
      };
}
