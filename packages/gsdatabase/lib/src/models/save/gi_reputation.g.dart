// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_reputation.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiReputation extends _GiReputation {
  @override
  final String id;
  @override
  final int reputation;

  /// Creates a new [GiReputation] instance.
  GiReputation({
    required this.id,
    required this.reputation,
  });

  /// Creates a new [GiReputation] instance from the given map.
  GiReputation.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        reputation = m['reputation'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GiReputation copyWith({
    String? id,
    int? reputation,
  }) {
    return GiReputation(
      id: id ?? this.id,
      reputation: reputation ?? this.reputation,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'reputation': reputation,
    };
  }
}
