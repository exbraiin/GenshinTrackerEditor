import 'package:data_editor/db/database.dart';

class GsViewpoint extends GsModel<GsViewpoint> {
  @override
  final String id;
  final String name;
  final String desc;
  final String image;
  final String region;
  final String version;

  GsViewpoint({
    this.id = '',
    this.name = '',
    this.desc = '',
    this.image = '',
    this.region = '',
    this.version = '',
  });

  GsViewpoint.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        desc = m.getString('desc'),
        image = m.getString('image'),
        region = m.getString('region'),
        version = m.getString('version');

  @override
  GsViewpoint copyWith({
    String? id,
    String? name,
    String? desc,
    String? image,
    String? region,
    String? version,
  }) {
    return GsViewpoint(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      image: image ?? this.image,
      region: region ?? this.region,
      version: version ?? this.version,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'desc': desc,
        'image': image,
        'region': region,
        'version': version,
      };
}
