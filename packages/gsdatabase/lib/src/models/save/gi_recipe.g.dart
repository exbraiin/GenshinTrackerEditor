// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_recipe.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiRecipe extends _GiRecipe {
  @override
  final String id;
  @override
  final int proficiency;

  /// Creates a new [GiRecipe] instance.
  GiRecipe({
    required this.id,
    required this.proficiency,
  });

  /// Creates a new [GiRecipe] instance from the given map.
  GiRecipe.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        proficiency = m['proficiency'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GiRecipe copyWith({
    String? id,
    int? proficiency,
  }) {
    return GiRecipe(
      id: id ?? this.id,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'proficiency': proficiency,
    };
  }
}
