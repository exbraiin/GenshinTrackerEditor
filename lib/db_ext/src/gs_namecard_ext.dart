import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsNamecard>> getNamecardDfs(GsNamecard? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.namecards),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsSelectItems.namecardTypes,
      (item, value) => item.copyWith(type: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      isValid: (item) => GsValidators.validateImage(item.image),
      process: GsValidators.processImage,
    ),
    DataField.textField(
      'Background',
      (item) => item.fullImage,
      (item, value) => item.copyWith(fullImage: value),
      isValid: (item) => GsValidators.validateImage(item.fullImage),
      process: GsValidators.processImage,
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
      isValid: (item) => GsValidators.validateText(item.desc),
    ),
    DataField.textField(
      'Obtain',
      (item) => item.obtain,
      (item, value) => item.copyWith(obtain: value),
      isValid: (item) => GsValidators.validateText(item.obtain),
    ),
  ];
}
