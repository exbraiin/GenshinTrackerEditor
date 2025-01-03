import 'dart:async';

import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/external/gs_enka.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsCharacterExt extends GsModelExt<GsCharacter> {
  const GsCharacterExt();

  @override
  List<DataField<GsCharacter>> getFields(String? editId) {
    late final savedItem = Database.i.of<GsCharacter>().getItem(editId!);
    final (recipeId, namecardId) = editId != null
        ? (savedItem?.specialDish, savedItem?.namecardId)
        : ('', '');

    final vd = ValidateModels<GsCharacter>();
    final vdVersion = ValidateModels.versions();
    final vdRecipes = ValidateModels.specialRecipes(
      savedId: recipeId,
      allowNone: true,
    );
    final vdNamecard = ValidateModels.namecards(
      GeNamecardType.character,
      savedId: namecardId,
    );
    final vldMatReg = ValidateModels.materials(GeMaterialType.regionMaterials);
    final vldMatTal = ValidateModels.materials(GeMaterialType.talentMaterials);
    final vldMatGem = ValidateModels.materials(GeMaterialType.ascensionGems);
    final vldMatBss = ValidateModels.materials(GeMaterialType.normalBossDrops);
    final vldMatWkk = ValidateModels.materials(GeMaterialType.weeklyBossDrops);
    final vldMatMob = ValidateModels.materials(
      GeMaterialType.normalDrops,
      GeMaterialType.eliteDrops,
    );

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vd.validateItemId(item, editId),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: expectedId(item)),
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
            final completer = Completer<GsCharacter>();
            if (!context.mounted) {
              completer.completeError('Could not open dialog!');
              return completer.future;
            }
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
                completer.complete(item.copyWith(enkaId: value));
              },
            ).show(context);
            return completer.future;
          },
          icon: const Icon(Icons.select_all_rounded),
        ),
        empty: GsValidLevel.warn2,
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.textField(
        'Title',
        (item) => item.title,
        (item, value) => item.copyWith(title: value),
      ),
      DataField.singleSelect(
        'Namecard Id',
        (item) => item.namecardId,
        (item) => vdNamecard.filters,
        (item, value) => item.copyWith(namecardId: value),
        validator: (item) => vdNamecard.validate(item.namecardId),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        min: 4,
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
      ),
      DataField.singleEnum(
        'Weapon',
        GeWeaponType.values.toChips(),
        (item) => item.weapon,
        (item, value) => item.copyWith(weapon: value),
        invalid: [GeWeaponType.none],
      ),
      DataField.singleEnum(
        'Element',
        GeElementType.values.toChips(),
        (item) => item.element,
        (item, value) => item.copyWith(element: value),
        invalid: [GeElementType.none],
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.singleEnum(
        'Source',
        GeItemSourceType.values.toChips(),
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        invalid: [GeItemSourceType.none],
        validator: (item, level) {
          const valid = [
            GeItemSourceType.event,
            GeItemSourceType.wishesStandard,
            GeItemSourceType.wishesCharacterBanner,
          ];
          if (!valid.contains(item.source)) return GsValidLevel.warn3;
          return level;
        },
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
        (item) => vdRecipes.filters,
        (item, value) => item.copyWith(specialDish: value),
        validator: (item) => vdRecipes.validate(item.specialDish),
      ),
      DataField.dateTime(
        'Birthday',
        (item) => item.birthday,
        (item, value) => item.copyWith(birthday: value),
        isBirthday: true,
      ),
      DataField.dateTime(
        'Release Date',
        (item) => item.releaseDate,
        (item, value) => item.copyWith(releaseDate: value),
        validator: (item) => vdVersion.validateDates(
          item.version,
          item.releaseDate,
        ),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.textImage(
        'Full Image',
        (item) => item.fullImage,
        (item, value) => item.copyWith(fullImage: value),
      ),
      DataField.textImage(
        'Constellation Image',
        (item) => item.constellationImage,
        (item, value) => item.copyWith(constellationImage: value),
      ),
      DataField.singleSelect(
        'Material Gem',
        (item) => item.gemMaterial,
        (item) => vldMatGem.filters,
        (item, value) => item.copyWith(gemMaterial: value),
        validator: (item) => vldMatGem.validate(item.gemMaterial),
      ),
      DataField.singleSelect(
        'Material Boss',
        (item) => item.bossMaterial,
        (item) => vldMatBss.filters,
        (item, value) => item.copyWith(bossMaterial: value),
        validator: (item) => vldMatBss.validate(item.bossMaterial),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.commonMaterial,
        (item) => vldMatMob.filters,
        (item, value) => item.copyWith(commonMaterial: value),
        validator: (item) => vldMatMob.validate(item.commonMaterial),
      ),
      DataField.singleSelect(
        'Material Region',
        (item) => item.regionMaterial,
        (item) => vldMatReg.filters,
        (item, value) => item.copyWith(regionMaterial: value),
        validator: (item) => vldMatReg.validateWithRegion(
          item.regionMaterial,
          item.region,
        ),
      ),
      DataField.singleSelect(
        'Material Talent',
        (item) => item.talentMaterial,
        (item) => vldMatTal.filters,
        (item, value) => item.copyWith(talentMaterial: value),
        validator: (item) => vldMatTal.validateWithRegion(
          item.talentMaterial,
          item.region,
        ),
      ),
      DataField.singleSelect(
        'Material Weekly',
        (item) => item.weeklyMaterial,
        (item) => vldMatWkk.filters,
        (item, value) => item.copyWith(weeklyMaterial: value),
        validator: (item) => vldMatWkk.validate(item.weeklyMaterial),
      ),
      DataField.singleEnum(
        'Ascension Stat',
        GeCharacterAscStatType.values.toChips(),
        (item) => item.ascStatType,
        (item, value) => item.copyWith(ascStatType: value),
        invalid: [GeCharacterAscStatType.none],
      ),
      DataField.intField(
        'Ascension HP Value',
        (item) => item.ascHpValue,
        (item, value) => item.copyWith(ascHpValue: value),
        range: (1, null),
      ),
      DataField.intField(
        'Ascension Atk Value',
        (item) => item.ascAtkValue,
        (item, value) => item.copyWith(ascAtkValue: value),
        range: (1, null),
      ),
      DataField.intField(
        'Ascension Def Value',
        (item) => item.ascDefValue,
        (item, value) => item.copyWith(ascDefValue: value),
        range: (1, null),
      ),
      DataField.doubleField(
        'Ascension Stat Value',
        (item) => item.ascStatValue,
        (item, value) => item.copyWith(ascStatValue: value),
        range: (1, null),
      ),
    ];
  }
}
