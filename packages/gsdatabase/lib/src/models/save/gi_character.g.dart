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
  @override
  final int talent1;
  @override
  final int talent2;
  @override
  final int talent3;

  /// Creates a new [GiCharacter] instance.
  GiCharacter({
    required this.id,
    this.outfit = '',
    this.owned = 0,
    this.ascension = 0,
    this.friendship = 1,
    this.talent1 = 1,
    this.talent2 = 1,
    this.talent3 = 1,
  });

  /// Creates a new [GiCharacter] instance from the given map.
  GiCharacter.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        outfit = m['outfit'] as String? ?? '',
        owned = m['owned'] as int? ?? 0,
        ascension = m['ascension'] as int? ?? 0,
        friendship = m['friendship'] as int? ?? 0,
        talent1 = m['talent1'] as int? ?? 0,
        talent2 = m['talent2'] as int? ?? 0,
        talent3 = m['talent3'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GiCharacter copyWith({
    String? id,
    String? outfit,
    int? owned,
    int? ascension,
    int? friendship,
    int? talent1,
    int? talent2,
    int? talent3,
  }) {
    return GiCharacter(
      id: id ?? this.id,
      outfit: outfit ?? this.outfit,
      owned: owned ?? this.owned,
      ascension: ascension ?? this.ascension,
      friendship: friendship ?? this.friendship,
      talent1: talent1 ?? this.talent1,
      talent2: talent2 ?? this.talent2,
      talent3: talent3 ?? this.talent3,
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
      'talent1': talent1,
      'talent2': talent2,
      'talent3': talent3,
    };
  }
}
