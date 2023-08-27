import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';

class GsMaterialExt extends GsModelExt<GsMaterial> {
  const GsMaterialExt();

  @override
  List<DataField<GsMaterial>> getFields(GsMaterial? model) {
    final ids = Database.i.materials.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
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
      DataField.text(
        'Ingredient',
        (item) => item.ingredient ? 'Yes' : 'No',
        swap: (item) => item.copyWith(ingredient: !item.ingredient),
      ),
      DataField.textEditor(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
        validator: (item) => vdText(item.desc),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity),
      ),
      DataField.singleSelect(
        'Region',
        (item) => item.region,
        (item) => GsItemFilter.regions().filters,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region, regions),
      ),
      DataField.singleEnum(
        'Group',
        GeMaterialCategory.values.toChips(),
        (item) => item.group,
        (item, value) => item.copyWith(group: value),
        validator: (item) =>
            vdContains(item.group, GeMaterialCategory.values),
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
      DataField.singleSelectOf<GsMaterial, List<GeWeekdays>>(
        'Weekdays',
        [
          const GsSelectItem([], 'None'),
          GsSelectItem(
            [GeWeekdays.sunday, GeWeekdays.monday, GeWeekdays.thursday],
            GeWeekdays.monday.id,
          ),
          GsSelectItem(
            [GeWeekdays.sunday, GeWeekdays.tuesday, GeWeekdays.friday],
            GeWeekdays.tuesday.id,
          ),
          GsSelectItem(
            [GeWeekdays.sunday, GeWeekdays.wednesday, GeWeekdays.saturday],
            GeWeekdays.wednesday.id,
          ),
        ],
        (item) => item.weekdays,
        (item, value) => item.copyWith(weekdays: value),
        validator: (item) => _validateWeekdayGroup(item.weekdays),
      ),
      DataField.multiEnum<GsMaterial, GeWeekdays>(
        'Weekdays',
        (item) => item.weekdays,
        (item) => GeWeekdays.values.toChips(),
        (item, value) => item.copyWith(weekdays: value),
        validator: (item) => _validateWeekdayGroup(item.weekdays),
      ),
    ];
  }

  GsValidLevel _validateWeekdayGroup(List<GeWeekdays> weekdays) {
    if (weekdays.isEmpty) return GsValidLevel.good;
    const g1 = [GeWeekdays.sunday, GeWeekdays.monday, GeWeekdays.thursday];
    const g2 = [GeWeekdays.sunday, GeWeekdays.tuesday, GeWeekdays.friday];
    const g3 = [GeWeekdays.sunday, GeWeekdays.wednesday, GeWeekdays.saturday];
    if (weekdays.length != 3) return GsValidLevel.error;
    if (weekdays.except(g1).isEmpty) return GsValidLevel.good;
    if (weekdays.except(g2).isEmpty) return GsValidLevel.good;
    if (weekdays.except(g3).isEmpty) return GsValidLevel.good;
    return GsValidLevel.error;
  }
}
