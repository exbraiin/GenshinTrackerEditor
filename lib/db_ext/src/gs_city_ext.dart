import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';

List<DataField<GsCity>> getCityDfs(GsCity? model) {
  final validator = DataValidator.i.getValidator<GsCity>();
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
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.singleEnum(
      'Element',
      GeElements.values.toChips(),
      (item) => item.element,
      (item, value) => item.copyWith(element: value),
      validate: (item) => validator.validateEntry('element', item, model),
    ),
    DataField.textList(
      'Reputation',
      (item) => item.reputation.join(', '),
      (item, value) {
        final r = value.split(',').map(int.tryParse).toList();
        if (r.any((element) => element == null)) r.clear();
        final tValue = r.whereNotNull().toList();
        return item.copyWith(reputation: tValue);
      },
      validate: (item) => validator.validateEntry('reputation', item, model),
    ),
  ];
}
