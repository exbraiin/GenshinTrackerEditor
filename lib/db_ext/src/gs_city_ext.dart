import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsCity>> getCityDfs(GsCity? model) {
  final validator = DataValidator.i.getValidator<GsCity>();
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
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
      process: GsDataParser.processImage,
    ),
    DataField.singleSelect(
      'Element',
      (item) => item.element,
      (item) => GsItemFilter.elements().items,
      (item, value) => item.copyWith(element: value),
      validate: (item) => validator.validateEntry('element', item, model),
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
      process: GsDataParser.processListOfStrings,
      validate: (item) => validator.validateEntry('reputation', item, model),
    ),
  ];
}
