import 'package:gsdatabase/src/enums/ge_recipe_effect_type.dart';
import 'package:gsdatabase/src/enums/ge_recipe_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_recipe.g.dart';

@BuilderGenerator()
abstract class _GsRecipe extends GsModel<GsRecipe> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('type')
  GeRecipeType get type;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('version')
  String get version;
  @BuilderWire('image')
  String get image;
  @BuilderWire('effect')
  GeRecipeEffectType get effect;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('effect_desc')
  String get effectDesc;
  @BuilderWire('base_recipe')
  String get baseRecipe;
  @BuilderWire('list_ingredients')
  List<_GsIngredient> get ingredients;

  @override
  Iterable<Comparable Function(GsRecipe e)> get sorters => [
        (e) => e.rarity,
        (e) => e.version,
      ];
}

@BuilderGenerator()
abstract class _GsIngredient extends GsModel<GsIngredient> {
  @BuilderWire('amount')
  int get amount;
}

extension GsRecipeExt on GsRecipe {
  int get maxProficiency => (rarity * 5).clamp(0, 25);
}
