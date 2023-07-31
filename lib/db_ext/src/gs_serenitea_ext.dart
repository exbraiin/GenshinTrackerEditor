import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsSerenitea>> getSereniteaDfs(GsSerenitea? model) {
  final validator = DataValidator.i.getValidator<GsSerenitea>();
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
    DataField.singleSelect(
      'Category',
      (item) => item.category,
      (item) => GsItemFilter.sereniteas().filters,
      (item, value) => item.copyWith(category: value),
      validate: (item) => validator.validateEntry('category', item, model),
    ),
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.textField(
      'Energy',
      (item) => item.energy.toString(),
      (item, value) => item.copyWith(energy: int.tryParse(value) ?? -1),
      validate: (item) => validator.validateEntry('energy', item, model),
    ),
    DataField.multiSelect<GsSerenitea, String>(
      'Chars',
      (item) => item.chars,
      (item) => GsItemFilter.wishes(null, GsItemFilter.wishChar).filters,
      (item, value) => item.copyWith(chars: value),
      validate: (item) => validator.validateEntry('chars', item, model),
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
