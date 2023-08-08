import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsBanner extends GsModel<GsBanner> {
  @override
  final String id;
  final String name;
  final String image;
  final String dateStart;
  final String dateEnd;
  final String version;
  final GeBannerType type;
  final List<String> feature4;
  final List<String> feature5;

  GsBanner._({
    this.id = '',
    this.name = '',
    this.image = '',
    this.dateStart = '',
    this.dateEnd = '',
    this.type = GeBannerType.beginner,
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
        type = GeBannerType.fromId(m.getString('type')),
        version = m.getString('version'),
        feature4 = m.getStringList('feature_4'),
        feature5 = m.getStringList('feature_5');

  @override
  GsBanner copyWith({
    String? id,
    String? name,
    String? image,
    String? dateStart,
    String? dateEnd,
    String? version,
    GeBannerType? type,
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
        'type': type.id,
        'version': version,
        'feature_4': feature4,
        'feature_5': feature5,
      };
}
