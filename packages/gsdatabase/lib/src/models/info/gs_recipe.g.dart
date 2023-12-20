// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_recipe.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsRecipe extends GsModel<GsRecipe> {
  @override
  final String id;
  final String name;
  final GeRecipeType type;
  final int rarity;
  final String version;
  final String image;
  final GeRecipeEffectType effect;
  final String desc;
  final String effectDesc;
  final String baseRecipe;
  final List<GsIngredient> ingredients;

  /// Creates a new [GsRecipe] instance.
  GsRecipe({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    required this.version,
    required this.image,
    required this.effect,
    required this.desc,
    required this.effectDesc,
    required this.baseRecipe,
    required this.ingredients,
  });

  /// Creates a new [GsRecipe] instance from the given map.
  GsRecipe.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        type = GeRecipeType.values.fromId(m['type']),
        rarity = m['rarity'] as int? ?? 0,
        version = m['version'] as String? ?? '',
        image = m['image'] as String? ?? '',
        effect = GeRecipeEffectType.values.fromId(m['effect']),
        desc = m['desc'] as String? ?? '',
        effectDesc = m['effect_desc'] as String? ?? '',
        baseRecipe = m['base_recipe'] as String? ?? '',
        ingredients = (m['list_ingredients'] as List? ?? const [])
            .map((e) => GsIngredient.fromJson(e))
            .toList();

  /// Copies this model with the given parameters.
  @override
  GsRecipe copyWith({
    String? id,
    String? name,
    GeRecipeType? type,
    int? rarity,
    String? version,
    String? image,
    GeRecipeEffectType? effect,
    String? desc,
    String? effectDesc,
    String? baseRecipe,
    List<GsIngredient>? ingredients,
  }) {
    return GsRecipe(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      version: version ?? this.version,
      image: image ?? this.image,
      effect: effect ?? this.effect,
      desc: desc ?? this.desc,
      effectDesc: effectDesc ?? this.effectDesc,
      baseRecipe: baseRecipe ?? this.baseRecipe,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.id,
      'rarity': rarity,
      'version': version,
      'image': image,
      'effect': effect.id,
      'desc': desc,
      'effect_desc': effectDesc,
      'base_recipe': baseRecipe,
      'list_ingredients': ingredients.map((e) => e.toMap()).toList(),
    };
  }
}

class GsIngredient extends GsModel<GsIngredient> {
  @override
  final String id;
  final int amount;

  /// Creates a new [GsIngredient] instance.
  GsIngredient({
    required this.id,
    required this.amount,
  });

  /// Creates a new [GsIngredient] instance from the given map.
  GsIngredient.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        amount = m['amount'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GsIngredient copyWith({
    String? id,
    int? amount,
  }) {
    return GsIngredient(
      id: id ?? this.id,
      amount: amount ?? this.amount,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'amount': amount,
    };
  }
}
