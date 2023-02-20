import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsRecipe>> getRecipeDfs(GsRecipe? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.recipes),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsSelectItems.getFromList(GsConfigurations.recipeTypes),
      (item, value) => item.copyWith(type: value),
      isValid: (item) =>
          GsValidators.validateText(item.type, GsValidLevel.warn2),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      isValid: (item) => GsValidators.validateImage(item.image),
      process: GsValidators.processImage,
    ),
    DataField.singleSelect(
      'Effect',
      (item) => item.effect,
      (item) => GsSelectItems.recipeEffects,
      (item, value) => item.copyWith(effect: value),
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
    ),
    DataField.textField(
      'Effect Desc',
      (item) => item.effectDesc.replaceAll('\n', '\\n'),
      (item, value) => item.copyWith(effectDesc: value.replaceAll('\\n', '\n')),
    ),
    DataField.singleSelect(
      'Base Recipe',
      (item) => item.baseRecipe,
      (item) => GsSelectItems.nonBaseRecipes,
      (item, value) => item.copyWith(baseRecipe: value),
    ),
    DataField.build<GsRecipe, GsAmount>(
      'Ingredients',
      (item) => item.ingredients,
      (item) => GsSelectItems.ingredients,
      (item, child) => DataField.textField(
        Database.i.ingredients.getItem(child.id)?.name ?? child.id,
        (item) => item.amount.toString(),
        (item, value) => item.copyWith(amount: int.tryParse(value) ?? 0),
        isValid: (item) =>
            item.amount > 0 ? GsValidLevel.good : GsValidLevel.error,
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
