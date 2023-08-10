import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsRemarkableChest>> getRemarkableChestDfs(
  GsRemarkableChest? model,
) {
  final validator = DataValidator.i.getValidator<GsRemarkableChest>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: DataButton(
        'Generate Id',
        (ctx, item) => item.copyWith(id: generateId(item)),
      ),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.singleEnum<GsRemarkableChest, GeSereniteaSets>(
      'Type',
      GeSereniteaSets.values.toChips(),
      (item) => item.type,
      (item, value) => item.copyWith(type: value),
      validate: (item) => validator.validateEntry('type', item, model),
    ),
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
    ),
    DataField.textField(
      'Energy',
      (item) => item.energy.toString(),
      (item, value) => item.copyWith(energy: int.tryParse(value) ?? 0),
      validate: (item) => validator.validateEntry('energy', item, model),
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsItemFilter.regions().filters,
      (item, value) => item.copyWith(region: value),
      validate: (item) => validator.validateEntry('region', item, model),
    ),
    DataField.textField(
      'Source',
      (item) => item.source,
      (item, value) => item.copyWith(source: value),
      validate: (item) => validator.validateEntry('source', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.singleEnum<GsRemarkableChest, GeRmChestCategory>(
      'Category',
      GeRmChestCategory.values.toChips(),
      (item) => item.category,
      (item, value) => item.copyWith(category: value),
      validate: (item) => validator.validateEntry('category', item, model),
    ),
  ];
}
