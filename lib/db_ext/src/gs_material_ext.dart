import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsMaterial>> getMaterialDfs(GsMaterial? model) {
  final validator = DataValidator.i.getValidator<GsMaterial>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) => item.copyWith(id: generateId(item)),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
      validate: (item) => validator.validateEntry('desc', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsItemFilter.regions().filters,
      (item, value) => item.copyWith(region: value),
      validate: (item) => validator.validateEntry('region', item, model),
    ),
    DataField.singleSelect(
      'Group',
      (item) => item.group,
      (item) => GsItemFilter.matCategories().filters,
      (item, value) => item.copyWith(group: value),
      validate: (item) => validator.validateEntry('group', item, model),
    ),
    DataField.textField(
      'Subgroup',
      (item) => item.subgroup.toString(),
      (item, value) => item.copyWith(subgroup: int.tryParse(value) ?? -1),
      validate: (item) => validator.validateEntry('subgroup', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.multiSelect<GsMaterial, String>(
      'Weekdays',
      (item) => item.weekdays,
      (item) => GsItemFilter.weekdays().filters,
      (item, value) => item.copyWith(weekdays: value),
      validate: (item) => validator.validateEntry('weekdays', item, model),
    ),
  ];
}
