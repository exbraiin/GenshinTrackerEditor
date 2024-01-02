import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
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
    final ids = Database.i.of<GsMaterial>().ids;
    final regions = GsItemFilter.regions().ids;
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
      DataField.text(
        'Ingredient',
        (item) => item.ingredient ? 'Yes' : 'No',
        swap: (item) => item.copyWith(ingredient: !item.ingredient),
      ),
      DataField.textEditor(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
        validator: (item) => vdText(item.desc, GsValidLevel.warn2),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity),
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region.id, regions),
      ),
      DataField.singleEnum(
        'Group',
        GeMaterialType.values.toChips(),
        (item) => item.group,
        (item, value) => item.copyWith(group: value),
        validator: (item) => vdContains(item.group, GeMaterialType.values),
      ),
      DataField.textField(
        'Subgroup',
        (item) => item.subgroup.toString(),
        (item, value) => item.copyWith(subgroup: int.tryParse(value) ?? -1),
        validator: (item) => vdNum(item.subgroup),
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
    if (weekdays.length != 3) return GsValidLevel.error;
    if (weekdays.except(g1).isEmpty) return GsValidLevel.good;
    if (weekdays.except(g2).isEmpty) return GsValidLevel.good;
    if (weekdays.except(g3).isEmpty) return GsValidLevel.good;
    return GsValidLevel.error;
  }
}
