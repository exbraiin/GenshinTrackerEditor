import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsSpincrystal>> getSpincrystalDfs(GsSpincrystal? model) {
  final validator = DataValidator.i.getValidator<GsSpincrystal>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      refresh: (item) => item.copyWith(id: generateId(item)),
      validate: (item) => validator.validateEntry('id', item, model),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.textField(
      'Number',
      (item) => item.number.toString(),
      (item, value) => item.copyWith(number: int.tryParse(value) ?? 0),
      validate: (item) => validator.validateEntry('number', item, model),
    ),
    DataField.textField(
      'Source',
      (item) => item.source,
      (item, value) => item.copyWith(source: value),
      validate: (item) => validator.validateEntry('source', item, model),
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsItemFilter.regions().filters,
      (item, value) => item.copyWith(region: value),
      validate: (item) => validator.validateEntry('region', item, model),
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
