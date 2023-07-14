import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

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
    int? rewards,
    int? achievements,
  }) {
    final items = Database.i.achievements.data.where((e) => e.group == id);
    final amount = items.sumBy((e) => e.reward);
    return GsAchievementGroup._(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      namecard: namecard ?? this.namecard,
      rewards: amount,
      achievements: items.length,
    );
  }

  @override
  JsonMap toJsonMap() {
    final items = Database.i.achievements.data.where((e) => e.group == id);
    final amount = items.sumBy((e) => e.reward);
    return {
      'name': name,
      'icon': icon,
      'version': version,
      'namecard': namecard,
      'rewards': amount,
      'achievements': items.length,
    };
  }
}
