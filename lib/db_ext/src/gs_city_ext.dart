import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsCity>> getCityDfs(GsCity? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.cities),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      isValid: (item) => GsValidators.validateImage(item.image),
      process: GsValidators.processImage,
    ),
    DataField.singleSelect(
      'Element',
      (item) => item.element,
      (item) => GsSelectItems.elements,
      (item, value) => item.copyWith(element: value),
    ),
    DataField.textField(
      'Reputation',
      (item) => item.reputation.join(', '),
      (item, value) {
        final r = value.split(',').map(int.tryParse).toList();
        if (r.any((element) => element == null)) r.clear();
        final tValue = r.whereNotNull().toList();
        return item.copyWith(reputation: tValue);
      },
      process: GsValidators.processListOfStrings,
      isValid: (item) =>
          item.reputation.isEmpty ? GsValidLevel.warn2 : GsValidLevel.good,
    ),
  ];
}
