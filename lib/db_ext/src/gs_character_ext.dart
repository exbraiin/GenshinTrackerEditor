import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsCharacter>> getCharacterDfs(GsCharacter? model) {
  final validator = DataValidator.i.getValidator<GsCharacter>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
      import: Importer.importCharacterFromFandom,
      importTooltip: 'Import from fandom URL',
    ),
    DataField.textField(
      'Enka ID',
      (item) => item.enkaId,
      (item, value) => item.copyWith(enkaId: value),
      validate: (item) => validator.validateEntry('enka_id', item, model),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.textField(
      'Title',
      (item) => item.title,
      (item, value) => item.copyWith(title: value),
      validate: (item) => validator.validateEntry('title', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
      min: 4,
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsItemFilter.regions().items,
      (item, value) => item.copyWith(region: value),
      validate: (item) => validator.validateEntry('region', item, model),
    ),
    DataField.singleSelect(
      'Weapon',
      (item) => item.weapon,
      (item) => GsItemFilter.weaponTypes().items,
      (item, value) => item.copyWith(weapon: value),
      validate: (item) => validator.validateEntry('weapon', item, model),
    ),
    DataField.singleSelect(
      'Element',
      (item) => item.element,
      (item) => GsItemFilter.elements().items,
      (item, value) => item.copyWith(element: value),
      validate: (item) => validator.validateEntry('element', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().items,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.singleSelect(
      'Obtain',
      (item) => item.source,
      (item) => GsItemFilter.itemSource().items,
      (item, value) => item.copyWith(source: value),
      validate: (item) => validator.validateEntry('source', item, model),
    ),
    DataField.textField(
      'Description',
      (item) => item.description,
      (item, value) => item.copyWith(description: value),
      validate: (item) => validator.validateEntry('description', item, model),
    ),
    DataField.textField(
      'Constellation',
      (item) => item.constellation,
      (item, value) => item.copyWith(constellation: value),
      validate: (item) => validator.validateEntry('constellation', item, model),
    ),
    DataField.textField(
      'Affiliation',
      (item) => item.affiliation,
      (item, value) => item.copyWith(affiliation: value),
      validate: (item) => validator.validateEntry('affiliation', item, model),
    ),
    DataField.singleSelect(
      'Special Dish',
      (item) => item.specialDish,
      (item) => GsItemFilter.baseRecipes().items,
      (item, value) => item.copyWith(specialDish: value),
      validate: (item) => validator.validateEntry('special_dish', item, model),
    ),
    DataField.textField(
      'Birthday',
      (item) => item.birthday,
      (item, value) => item.copyWith(birthday: value),
      validate: (item) => validator.validateEntry('birthday', item, model),
    ),
    DataField.textField(
      'Release Date',
      (item) => item.releaseDate,
      (item, value) => item.copyWith(releaseDate: value),
      validate: (item) => validator.validateEntry('release_date', item, model),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
      process: GsDataParser.processImage,
    ),
    DataField.textField(
      'Full Image',
      (item) => item.fullImage,
      (item, value) => item.copyWith(fullImage: value),
      validate: (item) => validator.validateEntry('full_image', item, model),
      process: GsDataParser.processImage,
    ),
    DataField.textField(
      'Constellation Image',
      (item) => item.constellationImage,
      (item, value) => item.copyWith(constellationImage: value),
      validate: (item) =>
          validator.validateEntry('constellation_image', item, model),
      process: GsDataParser.processImage,
    ),
  ];
}
