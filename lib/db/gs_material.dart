import 'package:data_editor/db/database.dart';

class GsMaterial extends GsModel<GsMaterial> {
  @override
  final String id;
  final String name;
  final String desc;
  final int rarity;
  final String group;
  final String image;
  final String region;
  final int subgroup;
  final String version;
  final List<String> weekdays;

  GsMaterial({
    this.id = '',
    this.name = '',
    this.desc = '',
    this.rarity = 1,
    this.group = '',
    this.image = '',
    this.region = '',
    this.subgroup = 0,
    this.version = '',
    this.weekdays = const [],
  });

  GsMaterial.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        desc = m.getString('desc'),
        rarity = m.getInt('rarity', 1),
        group = m.getString('group'),
        image = m.getString('image'),
        region = m.getString('region'),
        subgroup = m.getInt('subgroup', 0),
        version = m.getString('version'),
        weekdays = m.getStringList('weekdays');

  @override
  GsMaterial copyWith({
    String? id,
    String? name,
    String? desc,
    int? rarity,
    String? group,
    String? image,
    String? region,
    int? subgroup,
    String? version,
    List<String>? weekdays,
  }) {
    return GsMaterial(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      rarity: rarity ?? this.rarity,
      group: group ?? this.group,
      image: image ?? this.image,
      region: region ?? this.region,
      subgroup: subgroup ?? this.subgroup,
      version: version ?? this.version,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'desc': desc,
        'group': group,
        'image': image,
        'region': region,
        'rarity': rarity,
        'subgroup': subgroup,
        'version': version,
        if (weekdays.isNotEmpty) 'weekdays': weekdays,
      };
}
