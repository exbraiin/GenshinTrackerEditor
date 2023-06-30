import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsRecipe>> getRecipeDfs(GsRecipe? model) {
  final validator = DataValidator.i.getValidator<GsRecipe>();
  final amounts = DataValidator.i.getValidator<GsAmount>();

  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsItemFilter.recipeType().items,
      (item, value) => item.copyWith(type: value),
      validate: (item) => validator.validateEntry('type', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().items,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
      process: GsDataParser.processImage,
    ),
    DataField.singleSelect(
      'Effect',
      (item) => item.effect,
      (item) => GsItemFilter.recipeEffects().items,
      (item, value) => item.copyWith(effect: value),
      validate: (item) => validator.validateEntry('effect', item, model),
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
      validate: (item) => validator.validateEntry('desc', item, model),
    ),
    DataField.textField(
      'Effect Desc',
      (item) => item.effectDesc.replaceAll('\n', '\\n'),
      (item, value) => item.copyWith(effectDesc: value.replaceAll('\\n', '\n')),
      validate: (item) => validator.validateEntry('effect_desc', item, model),
    ),
    DataField.singleSelect(
      'Base Recipe',
      (item) => item.baseRecipe,
      (item) => GsItemFilter.nonBaseRecipes().items,
      (item, value) => item.copyWith(baseRecipe: value),
      validate: (item) => validator.validateEntry('base_recipe', item, model),
    ),
    DataField.build<GsRecipe, GsAmount>(
      'Ingredients',
      (item) => item.ingredients,
      (item) => GsItemFilter.ingredients().items,
      (item, child) => DataField.textField(
        Database.i.ingredients.getItem(child.id)?.name ?? child.id,
        (item) => item.amount.toString(),
        (item, value) => item.copyWith(amount: int.tryParse(value) ?? 0),
        validate: (item) => amounts.validateEntry('id', item, null),
      ),
      (item, value) {
        final list = value.map((e) {
          final old = item.ingredients.firstOrNullWhere((i) => i.id == e);
          return old ?? GsAmount(id: e);
        }).sortedBy((element) => element.id);
        return item.copyWith(ingredients: list);
      },
      (item, field) {
        final list = item.ingredients.toList();
        final idx = list.indexWhere((e) => e.id == field.id);
        if (idx != -1) list[idx] = field;
        return item.copyWith(ingredients: list);
      },
    ),
  ];
}
