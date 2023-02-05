import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsSpincrystal extends GsModel<GsSpincrystal> {
  @override
  final String id;
  final String name;
  final int number;
  final String source;
  final String region;
  final String version;

  GsSpincrystal({
    this.id = '',
    this.name = '',
    this.number = 0,
    this.source = '',
    this.region = '',
    this.version = '',
  });

  GsSpincrystal.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        number = m.getInt('number'),
        source = m.getString('source'),
        region = m.getString('region'),
        version = m.getString('version');

  @override
  GsSpincrystal copyWith({
    String? id,
    String? name,
    int? number,
    String? source,
    String? region,
    String? version,
  }) {
    return GsSpincrystal(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      source: source ?? this.source,
      region: region ?? this.region,
      version: version ?? this.version,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'number': number,
        'source': source,
        'region': region,
        'version': version,
      };
}
