import 'package:dartx/dartx.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsMaterialExt extends GsModelExt<GsMaterial> {
  const GsMaterialExt();

  @override
  List<DataField<GsMaterial>> getFields(String? editId) {
    final vd = ValidateModels<GsMaterial>();
    final vdVersion = ValidateModels.versions();

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
      DataField.text(
        'Ingredient',
        (item) => item.ingredient ? 'Yes' : 'No',
        swap: (item) => item.copyWith(ingredient: !item.ingredient),
      ),
      DataField.textEditor(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
        emptyLevel: GsValidLevel.warn2,
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
      ),
      DataField.singleEnum(
        'Group',
        GeMaterialType.values.toChips(),
        (item) => item.group,
        (item, value) => item.copyWith(group: value),
      ),
      DataField.intField(
        'Subgroup',
        (item) => item.subgroup,
        (item, value) => item.copyWith(subgroup: value),
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
      DataField.multiEnum<GsMaterial, GeWeekdayType>(
        'Weekdays',
        (item) => item.weekdays,
        (item) => GeWeekdayType.values.toChips(),
        (item, value) => item.copyWith(weekdays: value),
        validator: (item) => _validateWeekdayGroup(item.weekdays),
      ),
    ];
  }

  GsValidLevel _validateWeekdayGroup(List<GeWeekdayType> weekdays) {
    if (weekdays.isEmpty) return GsValidLevel.good;
    const g1 = [
      GeWeekdayType.sunday,
      GeWeekdayType.monday,
      GeWeekdayType.thursday,
    ];
    const g2 = [
      GeWeekdayType.sunday,
      GeWeekdayType.tuesday,
      GeWeekdayType.friday,
    ];
    const g3 = [
      GeWeekdayType.sunday,
      GeWeekdayType.wednesday,
      GeWeekdayType.saturday,
    ];
    if (weekdays.length != 3) return GsValidLevel.warn3;
    if (weekdays.except(g1).isEmpty) return GsValidLevel.good;
    if (weekdays.except(g2).isEmpty) return GsValidLevel.good;
    if (weekdays.except(g3).isEmpty) return GsValidLevel.good;
    return GsValidLevel.warn3;
  }
}
