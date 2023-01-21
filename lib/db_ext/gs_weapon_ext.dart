import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsWeapon>> getWeaponDfs(GsWeapon? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) => validateId(item, model, Database.i.weapons),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => validateText(item.name),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      process: processImage,
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsSelectItems.getFromList(GsConfigurations.weaponTypes),
      (item, value) => item.copyWith(type: value),
    ),
    DataField.singleSelect(
      'Source',
      (item) => item.source,
      (item) => GsSelectItems.getFromList(GsConfigurations.itemSource),
      (item, value) => item.copyWith(source: value),
    ),
    DataField.textField(
      'Atk',
      (item) => item.atk.toString(),
      (item, value) => item.copyWith(atk: int.tryParse(value) ?? -1),
      isValid: (item) => item.atk >= 0 ? GsValidLevel.good : GsValidLevel.error,
    ),
    DataField.singleSelect(
      'Stat Type',
      (item) => item.statType,
      (item) => GsSelectItems.getFromList(GsConfigurations.statTypes),
      (item, value) => item.copyWith(statType: value),
    ),
    DataField.textField(
      'Stat Value',
      (item) => item.statValue.toString(),
      (item, v) => item.copyWith(statValue: double.tryParse(v) ?? -1),
      isValid: (item) =>
          item.statValue >= 0 ? GsValidLevel.good : GsValidLevel.error,
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
  ];
}
