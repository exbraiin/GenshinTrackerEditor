// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_achievement.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiAchievement extends GsModel<GiAchievement> with _GiAchievement {
  @override
  final String id;
  @override
  final int obtained;

  /// Creates a new [GiAchievement] instance.
  GiAchievement({
    required this.id,
    required this.obtained,
  });

  /// Creates a new [GiAchievement] instance from the given map.
  GiAchievement.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        obtained = m['obtained'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GiAchievement copyWith({
    String? id,
    int? obtained,
  }) {
    return GiAchievement(
      id: id ?? this.id,
      obtained: obtained ?? this.obtained,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'obtained': obtained,
    };
  }
}
