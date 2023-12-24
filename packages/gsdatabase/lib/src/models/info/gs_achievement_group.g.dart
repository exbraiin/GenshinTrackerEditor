// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_achievement_group.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsAchievementGroup extends GsModel<GsAchievementGroup>
    with _GsAchievementGroup {
  @override
  final String id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final String version;
  @override
  final String namecard;
  @override
  final int order;
  @override
  final int rewards;
  @override
  final int achievements;

  /// Creates a new [GsAchievementGroup] instance.
  GsAchievementGroup({
    required this.id,
    required this.name,
    required this.icon,
    required this.version,
    required this.namecard,
    required this.order,
    required this.rewards,
    required this.achievements,
  });

  /// Creates a new [GsAchievementGroup] instance from the given map.
  GsAchievementGroup.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        icon = m['icon'] as String? ?? '',
        version = m['version'] as String? ?? '',
        namecard = m['namecard'] as String? ?? '',
        order = m['order'] as int? ?? 0,
        rewards = m['rewards'] as int? ?? 0,
        achievements = m['achievements'] as int? ?? 0;

  /// Copies this model with the given parameters.
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
    return GsAchievementGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      namecard: namecard ?? this.namecard,
      order: order ?? this.order,
      rewards: rewards ?? this.rewards,
      achievements: achievements ?? this.achievements,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'version': version,
      'namecard': namecard,
      'order': order,
      'rewards': rewards,
      'achievements': achievements,
    };
  }
}
