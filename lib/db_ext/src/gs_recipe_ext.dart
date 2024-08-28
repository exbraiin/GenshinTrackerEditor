import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsRecipeExt extends GsModelExt<GsRecipe> {
  const GsRecipeExt();

  @override
  List<DataField<GsRecipe>> getFields(String? editId) {
    final vd = ValidateModels<GsRecipe>();
    final vdVersion = ValidateModels.versions();
    final vdIngredients = ValidateModels.ingredients();
    final vdBaseRecipes = ValidateModels.baseRecipes();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vd.validateItemId(item, editId),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: expectedId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.singleEnum(
        'Type',
        GeRecipeType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        invalid: [GeRecipeType.none],
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.singleEnum(
        'Effect',
        GeRecipeEffectType.values.toChips(),
        (item) => item.effect,
        (item, value) => item.copyWith(effect: value),
        invalid: [GeRecipeEffectType.none],
      ),
      DataField.textField(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
      ),
      DataField.textField(
        'Effect Desc',
        (item) => item.effectDesc.replaceAll('\n', '\\n'),
        (item, value) =>
            item.copyWith(effectDesc: value.replaceAll('\\n', '\n')),
      ),
      DataField.singleSelect(
        'Base Recipe',
        (item) => item.baseRecipe,
        (item) => vdBaseRecipes.filters,
        (item, value) {
          final base = Database.i.of<GsRecipe>().getItem(value);
          final type = base != null ? GeRecipeType.permanent : null;
          final ingredients = base?.ingredients.toList();
          return item.copyWith(
            baseRecipe: value,
            type: type,
            ingredients: ingredients,
          );
        },
        validator: (item) => vdBaseRecipes.validate(item.baseRecipe),
      ),
      DataField.buildList(
        'Ingredients',
        (item) => item.ingredients,
        (index, item, child) => [
          DataField.singleSelect(
            'Id',
            (item) => item.id,
            (item) => vdIngredients.filters,
            (item, value) => item.copyWith(id: value),
            validator: (subItem) =>
                validateBuildId(item.ingredients, subItem, (i) => i.id),
          ),
          DataField.intField(
            'Amount',
            (item) => item.amount,
            (item, value) => item.copyWith(amount: value),
            range: (1, null),
          ),
        ],
        () => GsIngredient.fromJson({}),
        (item, list) => item.copyWith(ingredients: list),
        emptyLevel: GsValidLevel.warn2,
      ),
    ];
  }
}
