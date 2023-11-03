import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';

class GsAchievementGroup extends GsModel<GsAchievementGroup> {
  @override
  final String id;
  final String name;
  final String icon;
  final String version;
  final String namecard;
  final int order;
  final int rewards;
  final int achievements;

  GsAchievementGroup._({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.version = '',
    this.namecard = '',
    this.order = 0,
    this.rewards = 0,
    this.achievements = 0,
  });

  GsAchievementGroup.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        icon = m.getString('icon'),
        version = m.getString('version'),
        namecard = m.getString('namecard'),
        order = m.getInt('order'),
        rewards = m.getInt('rewards'),
        achievements = m.getInt('achievements');

  @override
  GsAchievementGroup copyWith({
    String? id,
    String? name,
    String? icon,
    String? version,
    String? namecard,
    int? order,
    int? rewards,
    int? achievements,
  }) {
    final nId = id ?? this.id;
    late final data = Database.i.achievements.data;
    late final items = data.where((e) => e.group == nId);
    return GsAchievementGroup._(
      id: nId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      namecard: namecard ?? this.namecard,
      order: order ?? this.order,
      rewards: rewards ?? items.sumBy((e) => e.reward),
      achievements: achievements ?? items.sumBy((e) => e.phases.length),
    );
  }

  @override
  JsonMap toJsonMap() {
    return {
      'name': name,
      'icon': icon,
      'version': version,
      'namecard': namecard,
      'order': order,
      'rewards': rewards,
      'achievements': achievements,
    };
  }

  bool equalsTo(GsAchievementGroup other) {
    if (this == other) return true;
    return id == other.id &&
        name == other.name &&
        icon == other.icon &&
        version == other.version &&
        namecard == other.namecard &&
        order == other.order &&
        rewards == other.rewards &&
        achievements == other.achievements;
  }
}
