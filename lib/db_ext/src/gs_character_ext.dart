import 'dart:async';

import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/external/gs_enka.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsCharacterExt extends GsModelExt<GsCharacter> {
  const GsCharacterExt();

  @override
  List<DataField<GsCharacter>> getFields(GsCharacter? model) {
    final ids = Database.i.characters.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
    final versions = GsItemFilter.versions().ids;
    final recipes = GsItemFilter.baseRecipes().ids;

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, model, ids),
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
                  e.id.toTitle(),
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
        validator: (item) => vdText(item.enkaId, GsValidLevel.warn2),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
        validator: (item) => vdText(item.name),
      ),
      DataField.textField(
        'Title',
        (item) => item.title,
        (item, value) => item.copyWith(title: value),
        validator: (item) => vdText(item.title),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity, 4),
        min: 4,
      ),
      DataField.singleSelect(
        'Region',
        (item) => item.region,
        (item) => GsItemFilter.regions().filters,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region, regions),
      ),
      DataField.singleEnum(
        'Weapon',
        GeWeaponType.values.toChips(),
        (item) => item.weapon,
        (item, value) => item.copyWith(weapon: value),
        validator: (item) => vdContains(item.weapon, GeWeaponType.values),
      ),
      DataField.singleEnum(
        'Element',
        GeElements.values.toChips(),
        (item) => item.element,
        (item, value) => item.copyWith(element: value),
        validator: (item) => vdContains(item.element, GeElements.values),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.singleEnum(
        'Obtain',
        GeItemSource.values.toChips(),
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        validator: (item) => vdContains(item.source, GeItemSource.values),
      ),
      DataField.textField(
        'Description',
        (item) => item.description,
        (item, value) => item.copyWith(description: value),
        validator: (item) => vdText(item.description),
      ),
      DataField.textField(
        'Constellation',
        (item) => item.constellation,
        (item, value) => item.copyWith(constellation: value),
        validator: (item) => vdText(item.constellation),
      ),
      DataField.textField(
        'Affiliation',
        (item) => item.affiliation,
        (item, value) => item.copyWith(affiliation: value),
        validator: (item) => vdText(item.affiliation),
      ),
      DataField.singleEnum(
        'Model Type',
        GeCharacterModelType.values.toChips(),
        (item) => item.modelType,
        (item, value) => item.copyWith(modelType: value),
        validator: (item) =>
            vdContains(item.modelType, GeCharacterModelType.values),
      ),
      DataField.singleSelect(
        'Special Dish',
        (item) => item.specialDish,
        (item) => GsItemFilter.baseRecipes().filters,
        (item, value) => item.copyWith(specialDish: value),
        validator: (item) => vdContains(item.specialDish, recipes),
      ),
      DataField.textField(
        'Birthday',
        (item) => item.birthday,
        (item, value) => item.copyWith(birthday: value),
        validator: (item) => vdBirthday(item.birthday),
      ),
      DataField.textField(
        'Release Date',
        (item) => item.releaseDate,
        (item, value) => item.copyWith(releaseDate: value),
        validator: (item) => vdDate(item.releaseDate),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.textImage(
        'Side Image',
        (item) => item.sideImage,
        (item, value) => item.copyWith(sideImage: value),
        validator: (item) => vdImage(item.sideImage),
      ),
      DataField.textImage(
        'Full Image',
        (item) => item.fullImage,
        (item, value) => item.copyWith(fullImage: value),
        validator: (item) => vdImage(item.fullImage),
      ),
      DataField.textImage(
        'Constellation Image',
        (item) => item.constellationImage,
        (item, value) => item.copyWith(constellationImage: value),
        validator: (item) => vdImage(item.constellationImage),
      ),
    ];
  }
}
