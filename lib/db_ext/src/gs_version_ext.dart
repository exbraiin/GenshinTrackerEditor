import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsVersion>> getVersionDfs(GsVersion? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.versions),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      process: GsValidators.processImage,
    ),
    DataField.textField(
      'Release Date',
      (item) => item.releaseDate,
      (item, value) => item.copyWith(releaseDate: value),
    ),
  ];
}
