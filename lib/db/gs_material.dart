import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsMaterial extends GsModel<GsMaterial> {
  @override
  final String id;
  final String name;
  final String desc;
  final int rarity;
  final GeMaterialCategory group;
  final String image;
  final String region;
  final int subgroup;
  final String version;
  final bool ingredient;
  final List<GeWeekdays> weekdays;

  GsMaterial({
    this.id = '',
    this.name = '',
    this.desc = '',
    this.rarity = 1,
    this.group = GeMaterialCategory.none,
    this.image = '',
    this.region = '',
    this.subgroup = 0,
    this.version = '',
    this.ingredient = false,
    this.weekdays = const [],
  });

  GsMaterial.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        desc = m.getString('desc'),
        rarity = m.getInt('rarity', 1),
        group = GeMaterialCategory.values.fromId(m.getString('group')),
        image = m.getString('image'),
        region = m.getString('region'),
        subgroup = m.getInt('subgroup', 0),
        version = m.getString('version'),
        ingredient = m.getBool('ingredient'),
        weekdays = m
            .getStringList('weekdays')
            .map((e) => GeWeekdays.values.fromId(e))
            .toList();

  @override
  GsMaterial copyWith({
    String? id,
    String? name,
    String? desc,
    int? rarity,
    GeMaterialCategory? group,
    String? image,
    String? region,
    int? subgroup,
    String? version,
    bool? ingredient,
    List<GeWeekdays>? weekdays,
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
      ingredient: ingredient ?? this.ingredient,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'desc': desc,
        'group': group.id,
        'image': image,
        'region': region,
        'rarity': rarity,
        'subgroup': subgroup,
        'version': version,
        'ingredient': ingredient,
        if (weekdays.isNotEmpty) 'weekdays': weekdays.map((e) => e.id).toList(),
      };
}
