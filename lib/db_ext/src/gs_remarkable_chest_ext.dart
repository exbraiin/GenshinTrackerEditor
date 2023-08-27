import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsRemarkableChestExt extends GsModelExt<GsRemarkableChest> {
  const GsRemarkableChestExt();

  @override
  List<DataField<GsRemarkableChest>> getFields(GsRemarkableChest? model) {
    final ids = Database.i.remarkableChests.data.map((e) => e.id);
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
      DataField.singleEnum<GsRemarkableChest, GeSereniteaSets>(
        'Type',
        GeSereniteaSets.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        validator: (item) =>
            vdContains(item.type, GeSereniteaSets.values),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity),
      ),
      DataField.textField(
        'Energy',
        (item) => item.energy.toString(),
        (item, value) => item.copyWith(energy: int.tryParse(value) ?? 0),
        validator: (item) => vdNum(item.energy, 1),
      ),
      DataField.singleSelect(
        'Region',
        (item) => item.region,
        (item) => GsItemFilter.regions().filters,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region, regions),
      ),
      DataField.textField(
        'Source',
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        validator: (item) => vdText(item.source),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.singleEnum<GsRemarkableChest, GeRmChestCategory>(
        'Category',
        GeRmChestCategory.values.toChips(),
        (item) => item.category,
        (item, value) => item.copyWith(category: value),
        validator: (item) =>
            vdContains(item.category, GeRmChestCategory.values),
      ),
    ];
  }
}
