import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';

List<DataField<GsCharacterInfo>> getCharacterInfoDfs(GsCharacterInfo? model) {
  return [
    model != null
        ? DataField.text('ID', (item) => item.id)
        : DataField.singleSelect(
            'ID',
            (item) => item.id,
            (item) => GsSelectItems.charsWithoutInfo,
            (item, value) => item.copyWith(id: value),
          ),
    DataField.singleSelect(
      'Material Gem',
      (item) => item.gemMaterial,
      (item) => GsSelectItems.getMaterialGroupWithRarity('ascension_gems'),
      (item, value) => item.copyWith(gemMaterial: value),
    ),
    DataField.singleSelect(
      'Material Boss',
      (item) => item.bossMaterial,
      (item) => GsSelectItems.getMaterialGroupWithRarity('normal_boss_drops'),
      (item, value) => item.copyWith(bossMaterial: value),
    ),
    DataField.singleSelect(
      'Material Common',
      (item) => item.commonMaterial,
      (item) => GsSelectItems.getMaterialGroupsWithRarity(
        ['normal_drops', 'elite_drops'],
      ),
      (item, value) => item.copyWith(commonMaterial: value),
    ),
    DataField.singleSelect(
      'Material Region',
      (item) => item.regionMaterial,
      (item) {
        final types = GsConfigurations.matCatRegionCommon;
        return GsSelectItems.getMaterialGroupsWithRegion(types);
      },
      (item, value) => item.copyWith(regionMaterial: value),
      isValid: (item) {
        if (item.regionMaterial.isEmpty) return GsValidLevel.error;
        final chr = Database.i.characters.getItem(item.id);
        final mat = Database.i.materials.getItem(item.regionMaterial);
        if (chr == null || mat == null) return GsValidLevel.error;
        if (mat.group != 'region_materials_${chr.region}') {
          return GsValidLevel.warn1;
        }
        return GsValidLevel.good;
      },
    ),
    DataField.singleSelect(
      'Material Talent',
      (item) => item.talentMaterial,
      (item) {
        final types = GsConfigurations.matCatRegionTalent;
        return GsSelectItems.getMaterialGroupsWithRegion(types);
      },
      (item, value) => item.copyWith(talentMaterial: value),
      isValid: (item) {
        if (item.talentMaterial.isEmpty) return GsValidLevel.error;
        final chr = Database.i.characters.getItem(item.id);
        final mat = Database.i.materials.getItem(item.talentMaterial);
        if (chr == null || mat == null) return GsValidLevel.error;
        if (mat.group != 'talent_materials_${chr.region}') {
          return GsValidLevel.warn1;
        }
        return GsValidLevel.good;
      },
    ),
    DataField.singleSelect(
      'Material Weekly',
      (item) => item.weeklyMaterial,
      (item) => GsSelectItems.getMaterialGroupWithRarity('weekly_boss_drops'),
      (item, value) => item.copyWith(weeklyMaterial: value),
    ),
    DataField.singleSelect(
      'Ascension Stat',
      (item) => item.ascStatType,
      (item) => GsSelectItems.getFromList(GsConfigurations.characterStatTypes),
      (item, value) => item.copyWith(ascStatType: value),
    ),
    DataField.textField(
      'Ascension HP Values',
      (item) => item.ascHpValues,
      (item, value) => item.copyWith(ascHpValues: value),
      isValid: (item) => validateAscension(item.ascHpValues),
      process: processListOfStrings,
    ),
    DataField.textField(
      'Ascension Atk Values',
      (item) => item.ascAtkValues,
      (item, value) => item.copyWith(ascAtkValues: value),
      isValid: (item) => validateAscension(item.ascAtkValues),
      process: processListOfStrings,
    ),
    DataField.textField(
      'Ascension Def Values',
      (item) => item.ascDefValues,
      (item, value) => item.copyWith(ascDefValues: value),
      isValid: (item) => validateAscension(item.ascDefValues),
      process: processListOfStrings,
    ),
    DataField.textField(
      'Ascension Stat Values',
      (item) => item.ascStatValues,
      (item, value) => item.copyWith(ascStatValues: value),
      isValid: (item) => validateAscension(item.ascStatValues),
      process: processListOfStrings,
    ),
    DataField.list(
      'Talents',
      (item) => item.talents.mapIndexed((idx, tal) {
        return DataField.list(
          tal.type,
          (item) => [
            DataField.textField(
              'Name',
              (item) => tal.name,
              (item, value) {
                final list = item.talents.toList();
                list[idx] = item.talents[idx].copyWith(name: value);
                return item.copyWith(talents: list);
              },
              isValid: (item) => validateText(item.talents[idx].name),
            ),
            DataField.textField(
              'Icon',
              (item) => tal.icon,
              (item, value) {
                final list = item.talents.toList();
                list[idx] = item.talents[idx].copyWith(icon: value);
                return item.copyWith(talents: list);
              },
              isValid: (item) => validateText(item.talents[idx].icon),
              process: processImage,
            ),
            DataField.textEditor(
              'Desc',
              (item) => tal.desc,
              (item, value) {
                final list = item.talents.toList();
                list[idx] = item.talents[idx].copyWith(desc: value);
                return item.copyWith(talents: list);
              },
            ),
          ],
        );
      }),
    ),
    DataField.list(
      'Constellations',
      (item) => item.constellations.mapIndexed((idx, con) {
        return DataField.list(
          'C${idx + 1}',
          (item) => [
            DataField.textField(
              'Name',
              (item) => con.name,
              (item, value) {
                final list = item.constellations.toList();
                list[idx] = list[idx].copyWith(name: value);
                return item.copyWith(constellations: list);
              },
              isValid: (item) => validateText(item.constellations[idx].name),
            ),
            DataField.textField(
              'Icon',
              (item) => con.icon,
              (item, value) {
                final list = item.constellations.toList();
                list[idx] = list[idx].copyWith(icon: value);
                return item.copyWith(constellations: list);
              },
              isValid: (item) => validateImage(item.constellations[idx].icon),
              process: processImage,
            ),
            DataField.textEditor(
              'Desc',
              (item) => con.desc,
              (item, value) {
                final list = item.constellations.toList();
                list[idx] = list[idx].copyWith(desc: value);
                return item.copyWith(constellations: list);
              },
            ),
          ],
        );
      }),
    ),
  ];
}
