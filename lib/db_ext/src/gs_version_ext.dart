import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';

List<DataField<GsVersion>> getVersionDfs(GsVersion? model) {
  final validator = DataValidator.i.getValidator<GsVersion>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
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
    DataField.textField(
      'Release Date',
      (item) => item.releaseDate,
      (item, value) => item.copyWith(releaseDate: value),
      validate: (item) => validator.validateEntry('release_date', item, model),
    ),
  ];
}
