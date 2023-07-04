import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsWeapon>> getWeaponDfs(GsWeapon? model) {
  final validator = DataValidator.i.getValidator<GsWeapon>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
    ),
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.textImage(
      'Asc Image',
      (item) => item.imageAsc,
      (item, value) => item.copyWith(imageAsc: value),
      validate: (item) => validator.validateEntry('image_asc', item, model),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsItemFilter.weaponTypes().filters,
      (item, value) => item.copyWith(type: value),
      validate: (item) => validator.validateEntry('type', item, model),
    ),
    DataField.singleSelect(
      'Source',
      (item) => item.source,
      (item) => GsItemFilter.itemSource().filters,
      (item, value) => item.copyWith(source: value),
      validate: (item) => validator.validateEntry('source', item, model),
    ),
    DataField.textField(
      'Atk',
      (item) => item.atk.toString(),
      (item, value) => item.copyWith(atk: int.tryParse(value) ?? -1),
      validate: (item) => validator.validateEntry('atk', item, model),
    ),
    DataField.singleSelect(
      'Stat Type',
      (item) => item.statType,
      (item) => GsItemFilter.statTypes().filters,
      (item, value) => item.copyWith(statType: value),
      validate: (item) => validator.validateEntry('stat_type', item, model),
    ),
    DataField.textField(
      'Stat Value',
      (item) => item.statValue.toString(),
      (item, v) => item.copyWith(statValue: double.tryParse(v) ?? -1),
      validate: (item) => validator.validateEntry('stat_value', item, model),
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
      validate: (item) => validator.validateEntry('desc', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
  ];
}
