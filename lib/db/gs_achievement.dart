import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsAchievement extends GsModel<GsAchievement> {
  @override
  final String id;
  final String name;
  final String group;
  final bool hidden;
  final String version;
  final GeAchievementType type;
  final List<GsAchievementPhase> phases;

  int get reward => phases.sumBy((element) => element.reward);

  GsAchievement._({
    this.id = '',
    this.name = '',
    this.type = GeAchievementType.none,
    this.group = '',
    this.hidden = false,
    this.version = '',
    this.phases = const [],
  });

  GsAchievement.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        type = GeAchievementType.values.fromId(m.getString('type')),
        group = m.getString('group'),
        hidden = m.getBool('hidden'),
        version = m.getString('version'),
        phases = m.getListOf('phases', GsAchievementPhase.fromMap);

  @override
  GsAchievement copyWith({
    String? id,
    String? name,
    GeAchievementType? type,
    String? group,
    bool? hidden,
    String? version,
    List<GsAchievementPhase>? phases,
  }) {
    return GsAchievement._(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      group: group ?? this.group,
      hidden: hidden ?? this.hidden,
      version: version ?? this.version,
      phases: phases ?? this.phases,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'type': type.id,
        'group': group,
        'hidden': hidden,
        'version': version,
        'phases': phases.map((e) => e.toJsonMap()).toList(),
      };
}

class GsAchievementPhase extends GsModel<GsAchievementPhase> {
  @override
  final String id = '';
  final String desc;
  final int reward;

  GsAchievementPhase._({
    this.desc = '',
    this.reward = 0,
  });

  GsAchievementPhase.fromMap(JsonMap m)
      : desc = m.getString('desc'),
        reward = m.getInt('reward');

  @override
  GsAchievementPhase copyWith({
    String? desc,
    int? reward,
  }) {
    return GsAchievementPhase._(
      desc: desc ?? this.desc,
      reward: reward ?? this.reward,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'desc': desc,
        'reward': reward,
      };
}
