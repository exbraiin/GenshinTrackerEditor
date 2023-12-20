import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsWeaponInfoExt extends GsModelExt<GsWeaponInfo> {
  const GsWeaponInfoExt();

  @override
  List<DataField<GsWeaponInfo>> getFields(GsWeaponInfo? model) {
    const catWeapon = GeMaterialType.weaponMaterials;
    final matWeapon = GsItemFilter.matGroups(catWeapon).ids;
    const catCommon = GeMaterialType.normalDrops;
    final matCommon = GsItemFilter.matGroups(catCommon).ids;
    const catElite = GeMaterialType.eliteDrops;
    final matElite = GsItemFilter.matGroups(catElite).ids;
    return [
      model != null
          ? DataField.text(
              'ID',
              (item) => item.id,
            )
          : DataField.singleSelect(
              'ID',
              (item) => item.id,
              (item) => GsItemFilter.weaponsWithoutInfo().filters,
              (item, value) => item.copyWith(id: value),
              validator: (item) =>
                  item.id.isEmpty ? GsValidLevel.error : GsValidLevel.good,
            ),
      DataField.textField(
        'Effect Name',
        (item) => item.effectName,
        (item, value) => item.copyWith(effectName: value),
        validator: (item) => vdText(item.effectName),
      ),
      DataField.textEditor(
        'Effect Desc',
        (item) => item.effectDesc,
        (item, value) => item.copyWith(effectDesc: value),
        validator: (item) => vdText(item.effectDesc),
      ),
      DataField.singleSelect(
        'Material Weapon',
        (item) => item.matWeapon,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.weaponMaterials).filters,
        (item, value) => item.copyWith(matWeapon: value),
        validator: (item) => vdContains(item.matWeapon, matWeapon),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.matCommon,
        (item) => GsItemFilter.matGroups(GeMaterialType.normalDrops).filters,
        (item, value) => item.copyWith(matCommon: value),
        validator: (item) => vdContains(item.matCommon, matCommon),
      ),
      DataField.singleSelect(
        'Material Elite',
        (item) => item.matElite,
        (item) => GsItemFilter.matGroups(GeMaterialType.eliteDrops).filters,
        (item, value) => item.copyWith(matElite: value),
        validator: (item) => vdContains(item.matElite, matElite),
      ),
      DataField.singleEnum(
        'Ascension Stat',
        GeWeaponAscStatType.values.toChips(),
        (item) => item.ascStatType,
        (item, value) => item.copyWith(ascStatType: value),
        validator: (item) => vdContains(
          item.ascStatType,
          GeWeaponAscStatType.values,
        ),
      ),
      DataField.textList(
        'Ascension Atk Values',
        (item) => item.ascAtkValues,
        (item, value) => item.copyWith(ascAtkValues: value),
        validator: (item) =>
            _vdWeaponAsc(item.ascAtkValues, item.ascStatValues),
      ),
      DataField.textList(
        'Ascension Stat Values',
        (item) => item.ascStatValues,
        (item, value) => item.copyWith(ascStatValues: value),
        validator: (item) =>
            _vdWeaponAsc(item.ascAtkValues, item.ascStatValues),
      ),
    ];
  }

  GsValidLevel _vdWeaponAsc(String atkValues, String statValues) {
    final atk = atkValues.split(',').where((e) => e.isNotEmpty);
    final stat = statValues.split(',').where((e) => e.isNotEmpty);
    return (atk.isNotEmpty && stat.isEmpty) || atk.length == stat.length
        ? GsValidLevel.good
        : GsValidLevel.error;
  }
}
