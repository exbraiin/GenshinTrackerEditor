import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/importer.dart';

List<DataField<GsCharacterInfo>> getCharacterInfoDfs(GsCharacterInfo? model) {
  final validator = DataValidator.i.getValidator<GsCharacterInfo>();
  final talents = DataValidator.i.getValidator<GsCharTalent>();
  final constellations = DataValidator.i.getValidator<GsCharConstellation>();
  return [
    model != null
        ? DataField.text(
            'ID',
            (item) => item.id,
            validate: (item) => GsValidLevel.good,
          )
        : DataField.singleSelect(
            'ID',
            (item) => item.id,
            (item) => GsItemFilter.charsWithoutInfo().filters,
            (item, value) => item.copyWith(id: value),
            validate: (item) => validator.validateEntry('id', item, model),
          ),
    DataField.singleSelect(
      'Material Gem',
      (item) => item.gemMaterial,
      (item) => GsItemFilter.matGroupsWithRarity(GsItemFilter.matGems).filters,
      (item, value) => item.copyWith(gemMaterial: value),
      validate: (item) => validator.validateEntry('mat_gem', item, model),
    ),
    DataField.singleSelect(
      'Material Boss',
      (item) => item.bossMaterial,
      (item) => GsItemFilter.matGroupsWithRegion(GsItemFilter.matBoss).filters,
      (item, value) => item.copyWith(bossMaterial: value),
      validate: (item) => validator.validateEntry('mat_boss', item, model),
    ),
    DataField.singleSelect(
      'Material Common',
      (item) => item.commonMaterial,
      (item) =>
          GsItemFilter.matGroupsWithRarity(['normal_drops', 'elite_drops'])
              .filters,
      (item, value) => item.copyWith(commonMaterial: value),
      validate: (item) => validator.validateEntry('mat_common', item, model),
    ),
    DataField.singleSelect(
      'Material Region',
      (item) => item.regionMaterial,
      (item) =>
          GsItemFilter.matGroupsWithRegion(GsItemFilter.matRegion).filters,
      (item, value) => item.copyWith(regionMaterial: value),
      validate: (item) => validator.validateEntry('mat_region', item, model),
    ),
    DataField.singleSelect(
      'Material Talent',
      (item) => item.talentMaterial,
      (item) =>
          GsItemFilter.matGroupsWithRegion(GsItemFilter.matTalent).filters,
      (item, value) => item.copyWith(talentMaterial: value),
      validate: (item) => validator.validateEntry('mat_talent', item, model),
    ),
    DataField.singleSelect(
      'Material Weekly',
      (item) => item.weeklyMaterial,
      (item) => GsItemFilter.matGroupsWithRarity(GsItemFilter.matWeek).filters,
      (item, value) => item.copyWith(weeklyMaterial: value),
      validate: (item) => validator.validateEntry('mat_weekly', item, model),
    ),
    DataField.singleSelect(
      'Ascension Stat',
      (item) => item.ascStatType,
      (item) => GsItemFilter.chrStatTypes().filters,
      (item, value) => item.copyWith(ascStatType: value),
      validate: (item) => validator.validateEntry('asc_stat_type', item, model),
    ),
    DataField.textList(
      'Ascension HP Values',
      (item) => item.ascHpValues,
      (item, value) => item.copyWith(ascHpValues: value),
      validate: (item) => validator.validateEntry('asc_hp_values', item, model),
      import: Importer.importCharacterAscensionStatsFromAmbr,
      importTooltip: 'Import from Ambr table',
    ),
    DataField.textList(
      'Ascension Atk Values',
      (item) => item.ascAtkValues,
      (item, value) => item.copyWith(ascAtkValues: value),
      validate: (item) =>
          validator.validateEntry('asc_atk_values', item, model),
    ),
    DataField.textList(
      'Ascension Def Values',
      (item) => item.ascDefValues,
      (item, value) => item.copyWith(ascDefValues: value),
      validate: (item) =>
          validator.validateEntry('asc_def_values', item, model),
    ),
    DataField.textList(
      'Ascension Stat Values',
      (item) => item.ascStatValues,
      (item, value) => item.copyWith(ascStatValues: value),
      validate: (item) =>
          validator.validateEntry('asc_stat_values', item, model),
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
              validate: (item) => talents.validateEntry('name', tal, null),
            ),
            DataField.textImage(
              'Icon',
              (item) => tal.icon,
              (item, value) {
                final list = item.talents.toList();
                list[idx] = item.talents[idx].copyWith(icon: value);
                return item.copyWith(talents: list);
              },
              validate: (item) => talents.validateEntry('icon', tal, null),
            ),
            DataField.textEditor(
              'Desc',
              (item) => tal.desc,
              (item, value) {
                final list = item.talents.toList();
                list[idx] = item.talents[idx].copyWith(desc: value);
                return item.copyWith(talents: list);
              },
              validate: (item) => talents.validateEntry('desc', tal, null),
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
              validate: (item) =>
                  constellations.validateEntry('name', con, null),
            ),
            DataField.textImage(
              'Icon',
              (item) => con.icon,
              (item, value) {
                final list = item.constellations.toList();
                list[idx] = list[idx].copyWith(icon: value);
                return item.copyWith(constellations: list);
              },
              validate: (item) =>
                  constellations.validateEntry('icon', con, null),
            ),
            DataField.textEditor(
              'Desc',
              (item) => con.desc,
              (item, value) {
                final list = item.constellations.toList();
                list[idx] = list[idx].copyWith(desc: value);
                return item.copyWith(constellations: list);
              },
              validate: (item) =>
                  constellations.validateEntry('desc', con, null),
            ),
          ],
        );
      }),
    ),
  ];
}
