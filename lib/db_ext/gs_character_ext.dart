import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsCharacter>> getCharacterDfs(GsCharacter? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) => validateId(item, model, Database.i.characters),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => validateText(item.name),
    ),
    DataField.textField(
      'Title',
      (item) => item.title,
      (item, value) => item.copyWith(title: value),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      min: 4,
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsSelectItems.regions,
      (item, value) => item.copyWith(region: value),
    ),
    DataField.singleSelect(
      'Weapon',
      (item) => item.weapon,
      (item) => GsSelectItems.getFromList(GsConfigurations.weaponTypes),
      (item, value) => item.copyWith(weapon: value),
    ),
    DataField.singleSelect(
      'Element',
      (item) => item.element,
      (item) => GsSelectItems.elements,
      (item, value) => item.copyWith(element: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
    DataField.singleSelect(
      'Obtain',
      (item) => item.source,
      (item) => GsSelectItems.getFromList(GsConfigurations.itemSource),
      (item, value) => item.copyWith(source: value),
    ),
    DataField.textField(
      'Description',
      (item) => item.description,
      (item, value) => item.copyWith(description: value),
    ),
    DataField.textField(
      'Constellation',
      (item) => item.constellation,
      (item, value) => item.copyWith(constellation: value),
    ),
    DataField.textField(
      'Affiliation',
      (item) => item.affiliation,
      (item, value) => item.copyWith(affiliation: value),
    ),
    DataField.singleSelect(
      'Special Dish',
      (item) => item.specialDish,
      (item) => GsSelectItems.baseRecipes,
      (item, value) => item.copyWith(specialDish: value),
    ),
    DataField.textField(
      'Birthday',
      (item) => item.birthday,
      (item, value) => item.copyWith(birthday: value),
      isValid: (item) => validateBday(item.birthday),
    ),
    DataField.textField(
      'Release Date',
      (item) => item.releaseDate,
      (item, value) => item.copyWith(releaseDate: value),
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
