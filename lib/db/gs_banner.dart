import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsBanner extends GsModel {
  @override
  final String id;
  final String name;
  final String image;
  final String dateStart;
  final String dateEnd;
  final String type;
  final String version;
  final List<String> feature4;
  final List<String> feature5;

  GsBanner._({
    this.id = '',
    this.name = '',
    this.image = '',
    this.dateStart = '',
    this.dateEnd = '',
    this.type = '',
    this.version = '',
    this.feature4 = const [],
    this.feature5 = const [],
  });

  GsBanner.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        image = m.getString('image'),
        dateStart = m.getString('date_start'),
        dateEnd = m.getString('date_end'),
        type = m.getString('type'),
        version = m.getString('version'),
        feature4 = m.getStringList('feature_4'),
        feature5 = m.getStringList('feature_5');

  GsBanner copyWith({
    String? id,
    String? name,
    String? image,
    String? dateStart,
    String? dateEnd,
    String? type,
    String? version,
    List<String>? feature4,
    List<String>? feature5,
  }) {
    return GsBanner._(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      type: type ?? this.type,
      version: version ?? this.version,
      feature4: feature4 ?? this.feature4,
      feature5: feature5 ?? this.feature5,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'image': image,
        'date_start': dateStart,
        'date_end': dateEnd,
        'type': type,
        'version': version,
        'feature_4': feature4,
        'feature_5': feature5,
      };
}
