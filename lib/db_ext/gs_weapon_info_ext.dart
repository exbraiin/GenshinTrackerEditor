import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';

List<DataField<GsWeaponInfo>> getWeaponInfoDfs(GsWeaponInfo? model) {
  return [
    model != null
        ? DataField.text('ID', (item) => item.id)
        : DataField.singleSelect(
            'ID',
            (item) => item.id,
            (item) => GsSelectItems.weaponsWithoutInfo,
            (item, value) => item.copyWith(id: value),
          ),
    DataField.textField(
      'Effect Name',
      (item) => item.effectName,
      (item, value) => item.copyWith(effectName: value),
      isValid: (item) => validateText(item.effectName),
    ),
    DataField.textEditor(
      'Effect Desc',
      (item) => item.effectDesc,
      (item, value) => item.copyWith(effectDesc: value),
    ),
    DataField.singleSelect(
      'Material Weapon',
      (item) => item.matWeapon,
      (item) {
        final types = GsConfigurations.matCatRegionWeapon;
        return GsSelectItems.getMaterialGroupsWithRegion(types);
      },
      (item, value) => item.copyWith(matWeapon: value),
    ),
    DataField.singleSelect(
      'Material Common',
      (item) => item.matCommon,
      (item) => GsSelectItems.getMaterialGroupWithRarity('normal_drops'),
      (item, value) => item.copyWith(matCommon: value),
    ),
    DataField.singleSelect(
      'Material Elite',
      (item) => item.matElite,
      (item) => GsSelectItems.getMaterialGroupWithRarity('elite_drops'),
      (item, value) => item.copyWith(matElite: value),
    ),
    DataField.singleSelect(
      'Ascension Stat',
      (item) => item.ascStatType,
      (item) => GsSelectItems.getFromList(GsConfigurations.weaponStatTypes, true),
      (item, value) => item.copyWith(ascStatType: value),
    ),
    DataField.textField(
      'Ascension Atk Values',
      (item) => item.ascAtkValues,
      (item, value) => item.copyWith(ascAtkValues: value),
      isValid: (item) {
        final atk = item.ascAtkValues.split(',').where((e) => e.isNotEmpty);
        final stat = item.ascStatValues.split(',').where((e) => e.isNotEmpty);
        return (atk.isNotEmpty && stat.isEmpty) || atk.length == stat.length
            ? GsValidLevel.good
            : GsValidLevel.error;
      },
    ),
    DataField.textField(
      'Ascension Stat Values',
      (item) => item.ascStatValues,
      (item, value) => item.copyWith(ascStatValues: value),
      isValid: (item) {
        final atk = item.ascAtkValues.split(',').where((e) => e.isNotEmpty);
        final stat = item.ascStatValues.split(',').where((e) => e.isNotEmpty);
        return (atk.isNotEmpty && stat.isEmpty) || atk.length == stat.length
            ? GsValidLevel.good
            : GsValidLevel.error;
      },
    ),
  ];
}
