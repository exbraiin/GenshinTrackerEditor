import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsCharacterOutfit>> getCharacterOutfitDfs(
  GsCharacterOutfit? model,
) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) => validateId(item, model, Database.i.characterOutfit),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => validateText(item.name),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
    DataField.singleSelect(
      'Character',
      (item) => item.character,
      (item) => GsSelectItems.chars,
      (item, value) => item.copyWith(character: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      isValid: (item) => validateImage(item.image),
      process: processImage,
    ),
    DataField.textField(
      'Full Image',
      (item) => item.fullImage,
      (item, value) => item.copyWith(fullImage: value),
      isValid: (item) => validateImage(item.fullImage),
      process: processImage,
    ),
  ];
}
