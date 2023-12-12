import 'package:data_editor/db/database.dart';

class GsEvent extends GsModel<GsEvent> {
  @override
  final String id;
  final String name;
  final String type;
  final String image;
  final String version;
  final String dateStart;
  final String dateEnd;

  GsEvent({
    this.id = '',
    this.name = '',
    this.type = '',
    this.image = '',
    this.version = '',
    this.dateStart = '',
    this.dateEnd = '',
  });

  GsEvent.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        type = m.getString('type'),
        image = m.getString('image'),
        version = m.getString('version'),
        dateStart = m.getString('date_start'),
        dateEnd = m.getString('date_end');

  @override
  GsEvent copyWith({
    String? id,
    String? name,
    String? type,
    String? image,
    String? version,
    String? dateStart,
    String? dateEnd,
  }) {
    return GsEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      image: image ?? this.image,
      version: version ?? this.version,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'id': id,
        'name': name,
        'type': type,
        'image': image,
        'version': version,
        'date_start': dateStart,
        'date_end': dateEnd,
      };
}
