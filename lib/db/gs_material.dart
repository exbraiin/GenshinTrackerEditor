import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsMaterial extends GsModel {
  @override
  final String id;
  final String name;
  final int rarity;
  final String group;
  final String image;
  final int subgroup;
  final String version;
  final List<String> weekdays;

  GsMaterial({
    this.id = '',
    this.name = '',
    this.rarity = 1,
    this.group = '',
    this.image = '',
    this.subgroup = 0,
    this.version = '',
    this.weekdays = const [],
  });

  GsMaterial.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        rarity = m.getInt('rarity', 1),
        group = m.getString('group'),
        image = m.getString('image'),
        subgroup = m.getInt('subgroup', 0),
        version = m.getString('version'),
        weekdays = m.getStringList('weekdays');

  GsMaterial copyWith({
    String? id,
    String? name,
    int? rarity,
    String? group,
    String? image,
    int? subgroup,
    String? version,
    List<String>? weekdays,
  }) {
    return GsMaterial(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      group: group ?? this.group,
      image: image ?? this.image,
      subgroup: subgroup ?? this.subgroup,
      version: version ?? this.version,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'group': group,
        'image': image,
        'rarity': rarity,
        'subgroup': subgroup,
        'version': version,
        if (weekdays.isNotEmpty) 'weekdays': weekdays,
      };
}
