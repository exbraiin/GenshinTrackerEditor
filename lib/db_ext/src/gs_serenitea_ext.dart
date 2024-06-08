import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsSereniteaSetExt extends GsModelExt<GsSereniteaSet> {
  const GsSereniteaSetExt();

  @override
  List<DataField<GsSereniteaSet>> getFields(String? editId) {
    final ids = Database.i.of<GsSereniteaSet>().ids;
    final chars = GsItemFilter.wishes(null, GeBannerType.character).ids;
    final versions = GsItemFilter.versions().ids;
    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, editId, ids),
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
      DataField.singleEnum<GsSereniteaSet, GeSereniteaSetType>(
        'Category',
        GeSereniteaSetType.values.toChips(),
        (item) => item.category,
        (item, value) => item.copyWith(category: value),
        validator: (item) =>
            vdContains(item.category, GeSereniteaSetType.values),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.textField(
        'Energy',
        (item) => item.energy.toString(),
        (item, value) => item.copyWith(energy: int.tryParse(value) ?? -1),
        validator: (item) => vdNum(item.energy, 1),
      ),
      DataField.multiSelect<GsSereniteaSet, String>(
        'Chars',
        (item) => item.chars,
        (item) => GsItemFilter.wishes(null, GeBannerType.character).filters,
        (item, value) => item.copyWith(chars: value),
        validator: (item) => item.chars.isEmpty
            ? GsValidLevel.warn2
            : (chars.containsAll(item.chars)
                ? GsValidLevel.good
                : GsValidLevel.warn3),
      ),
      DataField.build<GsSereniteaSet, GsFurnishingAmount>(
        'Furnishing',
        (item) => item.furnishing,
        (item) => GsItemFilter.furnishing().filters,
        (item, child) => DataField.textField(
          Database.i.of<GsMaterial>().getItem(child.id)?.name ?? child.id,
          (item) => item.amount.toString(),
          (item, value) => item.copyWith(amount: int.tryParse(value) ?? 0),
          validator: (item) => vdNum(item.amount, 1),
        ),
        (item, value) {
          final list = value.map((e) {
            final old = item.furnishing.firstOrNullWhere((i) => i.id == e);
            return old ?? GsFurnishingAmount(id: e, amount: 1);
          }).sortedBy((element) => element.id);
          return item.copyWith(furnishing: list);
        },
        (item, field) {
          final list = item.furnishing.toList();
          final idx = list.indexWhere((e) => e.id == field.id);
          if (idx != -1) list[idx] = field;
          return item.copyWith(furnishing: list);
        },
      ),
    ];
  }
}
