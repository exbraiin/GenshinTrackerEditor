import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsSpincrystal>> getSpincrystalDfs(GsSpincrystal? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.spincrystal),
      refresh: (item) => item.copyWith(id: item.number.toString()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.textField(
      'Number',
      (item) => item.number.toString(),
      (item, value) => item.copyWith(number: int.tryParse(value) ?? 0),
      isValid: (item) =>
          item.number > 0 ? GsValidLevel.good : GsValidLevel.error,
    ),
    DataField.textField(
      'Source',
      (item) => item.source,
      (item, value) => item.copyWith(source: value),
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsSelectItems.regions,
      (item, value) => item.copyWith(region: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
  ];
}
