import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsRecipeExt extends GsModelExt<GsRecipe> {
  const GsRecipeExt();

  @override
  List<DataField<GsRecipe>> getFields(GsRecipe? model) {
    final ids = Database.i.of<GsRecipe>().ids;
    final baseRecipes = GsItemFilter.nonBaseRecipes().ids;
    final versions = GsItemFilter.versions().ids;

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, model, ids),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: generateId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
        validator: (item) => vdText(item.name),
      ),
      DataField.singleEnum(
        'Type',
        GeRecipeType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        validator: (item) => vdContains(item.type, GeRecipeType.values),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.singleEnum(
        'Effect',
        GeRecipeEffectType.values.toChips(),
        (item) => item.effect,
        (item, value) => item.copyWith(effect: value),
        validator: (item) => vdContains(item.effect, GeRecipeEffectType.values),
      ),
      DataField.textField(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
        validator: (item) => vdText(item.desc),
      ),
      DataField.textField(
        'Effect Desc',
        (item) => item.effectDesc.replaceAll('\n', '\\n'),
        (item, value) =>
            item.copyWith(effectDesc: value.replaceAll('\\n', '\n')),
        validator: (item) => vdText(item.effectDesc),
      ),
      DataField.singleSelect(
        'Base Recipe',
        (item) => item.baseRecipe,
        (item) => GsItemFilter.nonBaseRecipes().filters,
        (item, value) => item.copyWith(baseRecipe: value),
        validator: (item) => vdContains(item.baseRecipe, baseRecipes),
      ),
      DataField.build<GsRecipe, GsIngredient>(
        'Ingredients',
        (item) => item.ingredients,
        (item) => GsItemFilter.ingredients().filters,
        (item, child) => DataField.textField(
          Database.i.of<GsMaterial>().getItem(child.id)?.name ?? child.id,
          (item) => item.amount.toString(),
          (item, value) => item.copyWith(amount: int.tryParse(value) ?? 0),
          validator: (item) => vdNum(item.amount, 1),
        ),
        (item, value) {
          final list = value.map((e) {
            final old = item.ingredients.firstOrNullWhere((i) => i.id == e);
            return old ?? GsIngredient.fromJson({'id': e});
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
}
