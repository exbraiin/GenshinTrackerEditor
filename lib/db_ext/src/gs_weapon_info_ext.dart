import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/importer.dart';

List<DataField<GsWeaponInfo>> getWeaponInfoDfs(GsWeaponInfo? model) {
  final validator = DataValidator.i.getValidator<GsWeaponInfo>();
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
            (item) => GsItemFilter.weaponsWithoutInfo().filters,
            (item, value) => item.copyWith(id: value),
            validate: (item) => validator.validateEntry('id', item, model),
          ),
    DataField.textField(
      'Effect Name',
      (item) => item.effectName,
      (item, value) => item.copyWith(effectName: value),
      validate: (item) => validator.validateEntry('effect_name', item, model),
    ),
    DataField.textEditor(
      'Effect Desc',
      (item) => item.effectDesc,
      (item, value) => item.copyWith(effectDesc: value),
      validate: (item) => validator.validateEntry('effect_desc', item, model),
    ),
    DataField.singleSelect(
      'Material Weapon',
      (item) => item.matWeapon,
      (item) =>
          GsItemFilter.matGroupsWithRegion(GsItemFilter.matWeapons).filters,
      (item, value) => item.copyWith(matWeapon: value),
      validate: (item) => validator.validateEntry('mat_weapon', item, model),
    ),
    DataField.singleSelect(
      'Material Common',
      (item) => item.matCommon,
      (item) =>
          GsItemFilter.matGroupsWithRarity(GsItemFilter.matNormal).filters,
      (item, value) => item.copyWith(matCommon: value),
      validate: (item) => validator.validateEntry('mat_common', item, model),
    ),
    DataField.singleSelect(
      'Material Elite',
      (item) => item.matElite,
      (item) => GsItemFilter.matGroupsWithRarity(GsItemFilter.matElite).filters,
      (item, value) => item.copyWith(matElite: value),
      validate: (item) => validator.validateEntry('mat_elite', item, model),
    ),
    DataField.singleSelect(
      'Ascension Stat',
      (item) => item.ascStatType,
      (item) => GsItemFilter.weaponStatTypes().filters,
      (item, value) => item.copyWith(ascStatType: value),
      validate: (item) => validator.validateEntry('asc_stat_type', item, model),
    ),
    DataField.textList(
      'Ascension Atk Values',
      (item) => item.ascAtkValues,
      (item, value) => item.copyWith(ascAtkValues: value),
      validate: (item) =>
          validator.validateEntry('asc_atk_values', item, model),
      import: Importer.importWeaponAscensionStatsFromAmbr,
    ),
    DataField.textList(
      'Ascension Stat Values',
      (item) => item.ascStatValues,
      (item, value) => item.copyWith(ascStatValues: value),
      validate: (item) =>
          validator.validateEntry('asc_stat_values', item, model),
    ),
  ];
}
