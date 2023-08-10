import 'dart:async';

import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/external/gs_enka.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

List<DataField<GsCharacter>> getCharacterDfs(GsCharacter? model) {
  final validator = DataValidator.i.getValidator<GsCharacter>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: DataButton(
        'Generate Id',
        (ctx, item) => item.copyWith(id: generateId(item)),
      ),
      import: DataButton(
        'Import from fandom URL',
        (ctx, item) => Importer.importCharacterFromFandom(item),
      ),
    ),
    DataField.textField(
      'Enka ID',
      (item) => item.enkaId,
      (item, value) => item.copyWith(enkaId: value),
      import: DataButton(
        'Select from Enka API',
        (context, item) async {
          await GsEnka.i.load();
          final controller = StreamController<GsCharacter>();
          // ignore: use_build_context_synchronously
          SelectDialog(
            title: 'Select',
            items: GsEnka.i.characters.map(
              (e) => GsSelectItem(
                e.id,
                e.icon.isEmpty ? e.id.toTitle() : '',
                image: e.icon,
                color: GsStyle.getRarityColor(e.rarity),
              ),
            ),
            selected: item.enkaId,
            onConfirm: (value) {
              controller.add(item.copyWith(enkaId: value));
              controller.close();
            },
          ).show(context);
          return controller.stream.first;
        },
        icon: const Icon(Icons.select_all_rounded),
      ),
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
      (item) => GsItemFilter.regions().filters,
      (item, value) => item.copyWith(region: value),
      validate: (item) => validator.validateEntry('region', item, model),
    ),
    DataField.singleEnum(
      'Weapon',
      GeWeaponType.values.toChips(),
      (item) => item.weapon,
      (item, value) => item.copyWith(weapon: value),
      validate: (item) => validator.validateEntry('weapon', item, model),
    ),
    DataField.singleEnum(
      'Element',
      GeElements.values.toChips(),
      (item) => item.element,
      (item, value) => item.copyWith(element: value),
      validate: (item) => validator.validateEntry('element', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.singleEnum(
      'Obtain',
      GeItemSource.values.toChips(),
      (item) => item.source,
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
    DataField.singleEnum(
      'Model Type',
      GeCharacterModelType.values.toChips(),
      (item) => item.modelType,
      (item, value) => item.copyWith(modelType: value),
      validate: (item) => validator.validateEntry('model_type', item, model),
    ),
    DataField.singleSelect(
      'Special Dish',
      (item) => item.specialDish,
      (item) => GsItemFilter.baseRecipes().filters,
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
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.textImage(
      'Full Image',
      (item) => item.fullImage,
      (item, value) => item.copyWith(fullImage: value),
      validate: (item) => validator.validateEntry('full_image', item, model),
    ),
    DataField.textImage(
      'Constellation Image',
      (item) => item.constellationImage,
      (item, value) => item.copyWith(constellationImage: value),
      validate: (item) =>
          validator.validateEntry('constellation_image', item, model),
    ),
  ];
}
