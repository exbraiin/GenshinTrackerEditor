import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsAchievementCategory extends GsModel<GsAchievementCategory> {
  @override
  final String id;
  final String name;
  final String icon;
  final String version;
  final String namecard;

  GsAchievementCategory._({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.version = '',
    this.namecard = '',
  });

  GsAchievementCategory.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        icon = m.getString('icon'),
        version = m.getString('version'),
        namecard = m.getString('namecard');

  @override
  GsAchievementCategory copyWith({
    String? id,
    String? name,
    String? icon,
    String? version,
    String? namecard,
  }) {
    return GsAchievementCategory._(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      namecard: namecard ?? this.namecard,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'version': version,
        'namecard': namecard,
      };
}

class GsAchievement extends GsModel<GsAchievement> {
  @override
  final String id;
  final String name;
  final String desc;
  final String type;
  final String group;
  final bool hidden;
  final int reward;
  final String version;

  GsAchievement._({
    this.id = '',
    this.name = '',
    this.desc = '',
    this.type = '',
    this.group = '',
    this.hidden = false,
    this.reward = 0,
    this.version = '',
  });

  GsAchievement.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        desc = m.getString('desc'),
        type = m.getString('type'),
        group = m.getString('group'),
        hidden = m.getBool('hidden'),
        reward = m.getInt('reward'),
        version = m.getString('version');

  @override
  GsAchievement copyWith({
    String? id,
    String? name,
    String? desc,
    String? type,
    String? group,
    bool? hidden,
    int? reward,
    String? version,
  }) {
    return GsAchievement._(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      type: type ?? this.type,
      group: group ?? this.group,
      hidden: hidden ?? this.hidden,
      reward: reward ?? this.reward,
      version: version ?? this.version,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'id': id,
        'name': name,
        'desc': desc,
        'type': type,
        'group': group,
        'hidden': hidden,
        'reward': reward,
        'version': version,
      };
}
