import 'dart:async';

import 'package:dartx/dartx.dart';
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
    final ids = Database.i.of<GsCharacter>().ids;
    final namecards = GsItemFilter.namecards(GeNamecardType.character).ids;
    final regions = GsItemFilter.regions().ids;
    final genders = GsItemFilter.genders().ids;
    final versions = GsItemFilter.versions().ids;
    final recipes = GsItemFilter.specialDishes().ids;
    const catGem = GeMaterialType.ascensionGems;
    final matGem = GsItemFilter.matGroups(catGem).ids;
    const catBss = GeMaterialType.normalBossDrops;
    final matBss = GsItemFilter.matGroups(catBss).ids;
    final matMob = GsItemFilter.matGroups(
      GeMaterialType.normalDrops,
      GeMaterialType.eliteDrops,
    ).ids;
    const catWeek = GeMaterialType.weeklyBossDrops;
    final matWeek = GsItemFilter.matGroups(catWeek).ids;
    final matWithRegion = Database.i
        .of<GsMaterial>()
        .items
        .map((e) => MapEntry(e.id, e.region))
        .toMap();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, editId, ids),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: generateId(item)),
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
      DataField.singleSelect(
        'Namecard Id',
        (item) => item.namecardId,
        (item) => GsItemFilter.namecards(
          GeNamecardType.character,
          item.namecardId,
        ).filters,
        (item, value) => item.copyWith(namecardId: value),
        validator: (item) {
          if (item.namecardId == '') return GsValidLevel.warn2;
          return vdContains(item.namecardId, namecards);
        },
      ),
      DataField.singleEnum(
        'Gender',
        GeGenderType.values.toChips(),
        (item) => item.gender,
        (item, value) => item.copyWith(gender: value),
        validator: (item) {
          if (item.gender == GeGenderType.none) {
            return GsValidLevel.warn2;
          }
          return vdContains(item.gender.id, genders);
        },
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity, 4),
        min: 4,
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region.id, regions),
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
        GeElementType.values.toChips(),
        (item) => item.element,
        (item, value) => item.copyWith(element: value),
        validator: (item) => vdContains(item.element, GeElementType.values),
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
        GeItemSourceType.values.toChips(),
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        validator: (item) => vdContains(item.source, GeItemSourceType.values),
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
      DataField.singleSelect(
        'Special Dish',
        (item) => item.specialDish,
        (item) => GsItemFilter.specialDishes(character: item).filters,
        (item, value) => item.copyWith(specialDish: value),
        validator: (item) {
          if (item.specialDish == '') return GsValidLevel.warn2;
          return vdContains(item.specialDish, recipes);
        },
      ),
      DataField.dateTime(
        'Birthday',
        (item) => item.birthday,
        (item, value) => item.copyWith(birthday: value),
        validator: (item) => vdBirthday(item.birthday),
        isBirthday: true,
      ),
      DataField.dateTime(
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
      DataField.singleSelect(
        'Material Gem',
        (item) => item.gemMaterial,
        (item) => GsItemFilter.matGroups(GeMaterialType.ascensionGems).filters,
        (item, value) => item.copyWith(gemMaterial: value),
        validator: (item) => vdContains(item.gemMaterial, matGem),
      ),
      DataField.singleSelect(
        'Material Boss',
        (item) => item.bossMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.normalBossDrops).filters,
        (item, value) => item.copyWith(bossMaterial: value),
        validator: (item) => vdContains(item.bossMaterial, matBss),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.commonMaterial,
        (item) => GsItemFilter.matGroups(
          GeMaterialType.normalDrops,
          GeMaterialType.eliteDrops,
        ).filters,
        (item, value) => item.copyWith(commonMaterial: value),
        validator: (item) => vdContains(item.commonMaterial, matMob),
      ),
      DataField.singleSelect(
        'Material Region',
        (item) => item.regionMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.regionMaterials).filters,
        (item, value) => item.copyWith(regionMaterial: value),
        validator: (item) {
          if (item.regionMaterial.isEmpty) return GsValidLevel.error;
          final matRegion = matWithRegion[item.regionMaterial];
          if (matRegion == null) return GsValidLevel.error;
          if (matRegion != item.region) return GsValidLevel.warn1;
          return GsValidLevel.good;
        },
      ),
      DataField.singleSelect(
        'Material Talent',
        (item) => item.talentMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.talentMaterials).filters,
        (item, value) => item.copyWith(talentMaterial: value),
        validator: (item) {
          if (item.talentMaterial.isEmpty) return GsValidLevel.error;
          final matRegion = matWithRegion[item.talentMaterial];
          if (matRegion == null) return GsValidLevel.error;
          if (matRegion != item.region) return GsValidLevel.warn1;
          return GsValidLevel.good;
        },
      ),
      DataField.singleSelect(
        'Material Weekly',
        (item) => item.weeklyMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.weeklyBossDrops).filters,
        (item, value) => item.copyWith(weeklyMaterial: value),
        validator: (item) => vdContains(item.weeklyMaterial, matWeek),
      ),
      DataField.singleEnum(
        'Ascension Stat',
        GeCharacterAscStatType.values.toChips(),
        (item) => item.ascStatType,
        (item, value) => item.copyWith(ascStatType: value),
        validator: (item) => vdContains(
          item.ascStatType,
          GeCharacterAscStatType.values,
        ),
      ),
      DataField.textList(
        'Ascension HP Values',
        (item) => item.ascHpValues,
        (item, value) => item.copyWith(ascHpValues: value),
        validator: (item) => _vdCharAsc(item.ascHpValues),
      ),
      DataField.textList(
        'Ascension Atk Values',
        (item) => item.ascAtkValues,
        (item, value) => item.copyWith(ascAtkValues: value),
        validator: (item) => _vdCharAsc(item.ascAtkValues),
      ),
      DataField.textList(
        'Ascension Def Values',
        (item) => item.ascDefValues,
        (item, value) => item.copyWith(ascDefValues: value),
        validator: (item) => _vdCharAsc(item.ascDefValues),
      ),
      DataField.textList(
        'Ascension Stat Values',
        (item) => item.ascStatValues,
        (item, value) => item.copyWith(ascStatValues: value),
        validator: (item) => _vdCharAsc(item.ascStatValues),
      ),
      DataField.build<GsCharacter, GsCharTalent>(
        'Talents',
        (item) => item.talents,
        (item) => GsItemFilter.talents().filters,
        (item, child) => DataField<GsCharTalent>.list(
          child.id,
          (tal) => [
            DataField.textField(
              'Name',
              (item) => tal.name,
              (item, value) => item.copyWith(name: value),
              validator: (item) => vdText(item.name),
            ),
            DataField.textImage(
              'Icon',
              (item) => tal.icon,
              (item, value) => item.copyWith(icon: value),
              validator: (item) => vdImage(item.icon),
            ),
            DataField.textEditor(
              'Desc',
              (item) => tal.desc,
              (item, value) => item.copyWith(desc: value),
              validator: (item) => vdText(item.desc),
              autoFormat: (input) => _formatCharTalsAndCons(item, input),
            ),
          ],
        ),
        (item, value) {
          final list = value.map((id) {
            final type = GeCharTalentType.values.fromId(id);
            final old = item.talents.firstOrNullWhere((e) => type == e.type);
            return old ??
                GsCharTalent.fromJson({}).copyWith(id: type.id, type: type);
          }).sortedBy((e) => GeCharTalentType.values.indexOf(e.type));
          return item.copyWith(talents: list);
        },
        (item, field) {
          final list = item.talents.toList();
          final idx = list.indexWhere((e) => e.id == field.id);
          if (idx != -1) list[idx] = field;
          return item.copyWith(talents: list);
        },
      ),
      DataField.build<GsCharacter, GsCharConstellation>(
        'Constellations',
        (item) => item.constellations,
        (item) => GsItemFilter.constellations().filters,
        (item, child) => DataField.list(
          child.id,
          (con) => [
            DataField.textField(
              'Name',
              (item) => con.name,
              (item, value) => item.copyWith(name: value),
              validator: (item) => vdText(con.name),
            ),
            DataField.textImage(
              'Icon',
              (item) => con.icon,
              (item, value) => item.copyWith(icon: value),
              validator: (item) => vdImage(con.icon),
            ),
            DataField.textEditor(
              'Desc',
              (item) => con.desc,
              (item, value) => item.copyWith(desc: value),
              validator: (item) => vdText(con.desc),
              autoFormat: (input) => _formatCharTalsAndCons(item, input),
            ),
          ],
        ),
        (item, value) {
          final list = value.map((id) {
            final t = GeCharConstellationType.values.fromId(id);
            final o = item.constellations.firstOrNullWhere((i) => t == i.type);
            return o ??
                GsCharConstellation.fromJson({}).copyWith(id: t.id, type: t);
          }).sortedBy((e) => e.id);
          return item.copyWith(constellations: list);
        },
        (item, field) {
          final list = item.constellations.toList();
          final idx = list.indexWhere((e) => e.id == field.id);
          if (idx != -1) list[idx] = field;
          return item.copyWith(constellations: list);
        },
      ),
    ];
  }
}

GsValidLevel _vdCharAsc(String value) {
  if (value.isEmpty) return GsValidLevel.warn1;
  if (value.split(',').length != 8) return GsValidLevel.warn2;
  return GsValidLevel.good;
}

String _formatCharTalsAndCons(GsCharacter char, String input) {
  final matches = {
    ...[
      ...char.talents
          .map((e) => MapEntry(e.name, 'skill'))
          .where((e) => e.key.isNotEmpty),
      ...char.constellations
          .map((e) => MapEntry(e.name, 'skill'))
          .where((e) => e.key.isNotEmpty),
    ].toMap(),
    'AoE Anemo DMG': 'anemo',
    'Anemo DMG Bonus': 'anemo',
    'Anemo DMG': 'anemo',
    'Anemo RES': 'anemo',
    'Anemo': 'anemo',
    'AoE Cryo DMG': 'cryo',
    'Cryo DMG Bonus': 'cryo',
    'Cryo DMG': 'cryo',
    'Cryo RES': 'cryo',
    'Cryo': 'cryo',
    'AoE Dendro DMG': 'dendro',
    'Dendro DMG Bonus': 'dendro',
    'Dendro DMG': 'dendro',
    'Dendro RES': 'dendro',
    'Dendro': 'dendro',
    'AoE Electro DMG': 'electro',
    'Electro DMG Bonus': 'electro',
    'Electro DMG': 'electro',
    'Electro RES': 'electro',
    'Electro Infusion': 'electro',
    'Electro-Charged DMG': 'electro',
    'Electro-Charged reaction DMG': 'electro',
    'Electro-related Elemental Reaction': 'electro',
    'Electro': 'electro',
    'AoE Geo DMG': 'geo',
    'Geo Construct': 'geo',
    'Geo DMG Bonus': 'geo',
    'Geo DMG': 'geo',
    'Geo': 'geo',
    'AoE Hydro DMG': 'hydro',
    'Hydro DMG Bonus': 'hydro',
    'Hydro DMG': 'hydro',
    'Hydro RES': 'hydro',
    'Hydro Infusion': 'hydro',
    'Hydro-related Elemental Reactions': 'hydro',
    'Hydro': 'hydro',
    'Wet': 'hydro',
    'AoE Pyro DMG': 'pyro',
    'Pyro DMG Bonus': 'pyro',
    'Pyro DMG': 'pyro',
    'Pyro RES': 'pyro',
    'Pyro': 'pyro',
  };

  var finalText = '';
  input = input.replaceAll(RegExp('<.+?>'), '');
  final text = input.toLowerCase();

  for (var i = 0;; i < text.length) {
    var min = -1;
    MapEntry<String, String>? tEntry;
    for (final entry in matches.entries) {
      final t = text.indexOf(entry.key.toLowerCase(), i);
      if (t == -1) continue;
      if (t < min || min == -1) {
        min = t;
        tEntry = entry;
      }
    }

    if (tEntry != null) {
      finalText += input.substring(i, min);
      finalText += '<color=${tEntry.value}>${tEntry.key}</color>';
      i = min + tEntry.key.length;
    } else {
      finalText += input.substring(i);
      break;
    }
  }
  return finalText;
}
