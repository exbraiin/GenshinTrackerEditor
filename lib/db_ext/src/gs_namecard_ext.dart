import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsNamecard>> getNamecardDfs(GsNamecard? model) {
  final validator = DataValidator.i.getValidator<GsNamecard>();
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
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsItemFilter.namecardTypes().items,
      (item, value) => item.copyWith(type: value),
      validate: (item) => validator.validateEntry('type', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
      min: 4,
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().items,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
      process: GsDataParser.processImage,
    ),
    DataField.textField(
      'Background',
      (item) => item.fullImage,
      (item, value) => item.copyWith(fullImage: value),
      validate: (item) => validator.validateEntry('full_image', item, model),
      process: GsDataParser.processImage,
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
      validate: (item) => validator.validateEntry('desc', item, model),
    ),
    DataField.textField(
      'Obtain',
      (item) => item.obtain,
      (item, value) => item.copyWith(obtain: value),
      validate: (item) => validator.validateEntry('obtain', item, model),
    ),
  ];
}
