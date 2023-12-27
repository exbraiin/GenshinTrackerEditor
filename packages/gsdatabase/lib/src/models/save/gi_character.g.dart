// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_character.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiCharacter extends _GiCharacter {
  @override
  final String id;
  @override
  final String outfit;
  @override
  final int owned;
  @override
  final int ascension;
  @override
  final int friendship;

  /// Creates a new [GiCharacter] instance.
  GiCharacter({
    required this.id,
    required this.outfit,
    required this.owned,
    required this.ascension,
    required this.friendship,
  });

  /// Creates a new [GiCharacter] instance from the given map.
  GiCharacter.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        outfit = m['outfit'] as String? ?? '',
        owned = m['owned'] as int? ?? 0,
        ascension = m['ascension'] as int? ?? 0,
        friendship = m['friendship'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GiCharacter copyWith({
    String? id,
    String? outfit,
    int? owned,
    int? ascension,
    int? friendship,
  }) {
    return GiCharacter(
      id: id ?? this.id,
      outfit: outfit ?? this.outfit,
      owned: owned ?? this.owned,
      ascension: ascension ?? this.ascension,
      friendship: friendship ?? this.friendship,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'outfit': outfit,
      'owned': owned,
      'ascension': ascension,
      'friendship': friendship,
    };
  }
}
