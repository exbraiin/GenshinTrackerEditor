import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsNamecard>> getNamecardDfs(GsNamecard? model) {
  final validator = DataValidator.i.getValidator<GsNamecard>();
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
      'Type',
      (item) => item.type.id,
      (item) => GsItemFilter.namecardTypes().filters,
      (item, value) => item.copyWith(type: GeNamecardType.fromId(value)),
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
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.textImage(
      'Background',
      (item) => item.fullImage,
      (item, value) => item.copyWith(fullImage: value),
      validate: (item) => validator.validateEntry('full_image', item, model),
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
