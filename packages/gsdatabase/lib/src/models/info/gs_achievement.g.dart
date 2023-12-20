// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_achievement.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsAchievement extends GsModel<GsAchievement> {
  @override
  final String id;
  final String name;
  final String group;
  final bool hidden;
  final String version;
  final GeAchievementType type;
  final List<GsAchievementPhase> phases;

  /// Creates a new [GsAchievement] instance.
  GsAchievement({
    required this.id,
    required this.name,
    required this.group,
    required this.hidden,
    required this.version,
    required this.type,
    required this.phases,
  });

  /// Creates a new [GsAchievement] instance from the given map.
  GsAchievement.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        group = m['group'] as String? ?? '',
        hidden = m['hidden'] as bool? ?? false,
        version = m['version'] as String? ?? '',
        type = GeAchievementType.values.fromId(m['type']),
        phases = (m['phases'] as List? ?? const [])
            .map((e) => GsAchievementPhase.fromJson(e))
            .toList();

  /// Copies this model with the given parameters.
  @override
  GsAchievement copyWith({
    String? id,
    String? name,
    String? group,
    bool? hidden,
    String? version,
    GeAchievementType? type,
    List<GsAchievementPhase>? phases,
  }) {
    return GsAchievement(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      hidden: hidden ?? this.hidden,
      version: version ?? this.version,
      type: type ?? this.type,
      phases: phases ?? this.phases,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'hidden': hidden,
      'version': version,
      'type': type.id,
      'phases': phases.map((e) => e.toMap()).toList(),
    };
  }
}

class GsAchievementPhase extends GsModel<GsAchievementPhase> {
  @override
  final String id;
  final String desc;
  final int reward;

  /// Creates a new [GsAchievementPhase] instance.
  GsAchievementPhase({
    required this.id,
    required this.desc,
    required this.reward,
  });

  /// Creates a new [GsAchievementPhase] instance from the given map.
  GsAchievementPhase.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        desc = m['desc'] as String? ?? '',
        reward = m['reward'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GsAchievementPhase copyWith({
    String? id,
    String? desc,
    int? reward,
  }) {
    return GsAchievementPhase(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      reward: reward ?? this.reward,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'desc': desc,
      'reward': reward,
    };
  }
}
