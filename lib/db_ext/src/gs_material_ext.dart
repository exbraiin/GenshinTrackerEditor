import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsMaterial>> getMaterialDfs(GsMaterial? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.materials),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsSelectItems.regions,
      (item, value) => item.copyWith(region: value),
    ),
    DataField.singleSelect(
      'Group',
      (item) => item.group,
      (item) => GsSelectItems.getFromList(GsConfigurations.materialCategories),
      (item, value) => item.copyWith(group: value),
    ),
    DataField.textField(
      'Subgroup',
      (item) => item.subgroup.toString(),
      (item, value) => item.copyWith(subgroup: int.tryParse(value) ?? -1),
      isValid: (item) =>
          item.subgroup >= 0 ? GsValidLevel.good : GsValidLevel.error,
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
    DataField.multiSelect<GsMaterial, String>(
      'Weekdays',
      (item) => item.weekdays,
      (item) => GsSelectItems.getFromList(GsConfigurations.weekdays),
      (item, value) => item.copyWith(weekdays: value),
    ),
  ];
}
