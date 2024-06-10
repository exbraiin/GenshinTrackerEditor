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
    final vd = ValidateModels<GsSereniteaSet>();
    final vdVersion = ValidateModels.versions();
    final vldFurnishing = ValidateModels<GsFurnishing>();
    final vdCharacters = ValidateModels<GsCharacter>();

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
      DataField.singleEnum<GsSereniteaSet, GeSereniteaSetType>(
        'Category',
        GeSereniteaSetType.values.toChips(),
        (item) => item.category,
        (item, value) => item.copyWith(category: value),
        invalid: [GeSereniteaSetType.none],
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.intField(
        'Energy',
        (item) => item.energy,
        (item, value) => item.copyWith(energy: value),
        range: (1, null),
      ),
      DataField.multiSelect<GsSereniteaSet, String>(
        'Chars',
        (item) => item.chars,
        (item) => vdCharacters.filters,
        (item, value) => item.copyWith(chars: value),
        validator: (item) => item.chars.isEmpty
            ? GsValidLevel.warn1
            : vdCharacters.validateAll(item.chars),
      ),
      DataField.build<GsSereniteaSet, GsFurnishingAmount>(
        'Furnishing',
        (item) => item.furnishing,
        (item) => vldFurnishing.filters,
        (item, child) => DataField.intField(
          Database.i.of<GsMaterial>().getItem(child.id)?.name ?? child.id,
          (item) => item.amount,
          (item, value) => item.copyWith(amount: value),
          range: (1, null),
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
