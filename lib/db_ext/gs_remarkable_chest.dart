import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsRemarkableChest>> getRemarkableChestDfs(
  GsRemarkableChest? model,
) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) => validateId(item, model, Database.i.remarkableChests),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => validateText(item.name),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsSelectItems.sereniteas,
      (item, value) => item.copyWith(type: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      isValid: (item) => validateImage(item.image),
      process: (value) => processImage(value),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
    ),
    DataField.textField(
      'Energy',
      (item) => item.energy.toString(),
      (item, value) => item.copyWith(energy: int.tryParse(value) ?? 0),
      isValid: (i) => i.energy > 0 ? GsValidLevel.good : GsValidLevel.warn2,
    ),
    DataField.singleSelect(
      'Source',
      (item) => item.source,
      (item) => GsSelectItems.getFromList(GsConfigurations.rChestSource),
      (item, value) => item.copyWith(source: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
    DataField.singleSelect(
      'Category',
      (item) => item.category,
      (item) => GsSelectItems.getFromList(GsConfigurations.rChestCategory),
      (item, value) => item.copyWith(category: value),
    ),
  ];
}
