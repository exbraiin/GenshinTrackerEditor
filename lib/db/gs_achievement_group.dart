import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';

class GsAchievementGroup extends GsModel<GsAchievementGroup> {
  @override
  final String id;
  final String name;
  final String icon;
  final String version;
  final String namecard;
  final int rewards;
  final int achievements;

  GsAchievementGroup._({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.version = '',
    this.namecard = '',
    this.rewards = 0,
    this.achievements = 0,
  });

  GsAchievementGroup.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        icon = m.getString('icon'),
        version = m.getString('version'),
        namecard = m.getString('namecard'),
        rewards = m.getInt('rewards'),
        achievements = m.getInt('achievements');

  @override
  GsAchievementGroup copyWith({
    String? id,
    String? name,
    String? icon,
    String? version,
    String? namecard,
  }) {
    final nId = id ?? this.id;
    final items = Database.i.achievements.data.where((e) => e.group == nId);
    final rewards = items.sumBy((e) => e.reward);
    final achievements = items.sumBy((e) => e.phases.length);
    return GsAchievementGroup._(
      id: nId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      namecard: namecard ?? this.namecard,
      rewards: rewards,
      achievements: achievements,
    );
  }

  @override
  JsonMap toJsonMap() {
    final items = Database.i.achievements.data.where((e) => e.group == id);
    final rewards = items.sumBy((e) => e.reward);
    final achievements = items.sumBy((e) => e.phases.length);
    return {
      'name': name,
      'icon': icon,
      'version': version,
      'namecard': namecard,
      'rewards': rewards,
      'achievements': achievements,
    };
  }
}
