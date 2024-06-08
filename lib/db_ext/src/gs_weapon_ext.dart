import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsWeaponExt extends GsModelExt<GsWeapon> {
  const GsWeaponExt();

  @override
  List<DataField<GsWeapon>> getFields(String? editId) {
    final ids = Database.i.of<GsWeapon>().ids;
    final versions = GsItemFilter.versions().ids;
    const catWeapon = GeMaterialType.weaponMaterials;
    final matWeapon = GsItemFilter.matGroups(catWeapon).ids;
    const catCommon = GeMaterialType.normalDrops;
    final matCommon = GsItemFilter.matGroups(catCommon).ids;
    const catElite = GeMaterialType.eliteDrops;
    final matElite = GsItemFilter.matGroups(catElite).ids;

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
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
        validator: (item) => vdText(item.name),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) =>
            item.rarity == 0 ? GsValidLevel.warn2 : vdRarity(item.rarity),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.textImage(
        'Asc Image',
        (item) => item.imageAsc,
        (item, value) => item.copyWith(imageAsc: value),
        validator: (item) => vdImage(item.imageAsc),
      ),
      DataField.singleEnum(
        'Type',
        GeWeaponType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        validator: (item) => vdContains(item.type, GeWeaponType.values),
      ),
      DataField.singleEnum<GsWeapon, GeItemSourceType>(
        'Source',
        GeItemSourceType.values.toChips(),
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        validator: (item) {
          if (item.rarity == 5) {
            const valid = [
              GeItemSourceType.wishesStandard,
              GeItemSourceType.wishesWeaponBanner,
            ];
            return valid.contains(item.source)
                ? GsValidLevel.good
                : GsValidLevel.warn2;
          }
          return item.source != GeItemSourceType.wishesCharacterBanner
              ? GsValidLevel.good
              : GsValidLevel.warn2;
        },
      ),
      DataField.textField(
        'Atk',
        (item) => item.atk.toString(),
        (item, value) => item.copyWith(atk: int.tryParse(value) ?? -1),
        validator: (item) =>
            item.atk == 0 ? GsValidLevel.warn2 : vdNum(item.atk),
      ),
      DataField.singleEnum(
        'Stat Type',
        GeWeaponAscStatType.values.toChips(),
        (item) => item.statType,
        (item, value) => item.copyWith(statType: value),
        validator: (item) =>
            vdContains(item.statType, GeWeaponAscStatType.values),
      ),
      DataField.textField(
        'Stat Value',
        (item) => item.statValue.toString(),
        (item, v) => item.copyWith(statValue: double.tryParse(v) ?? -1),
        validator: (item) {
          if (item.statType == GeWeaponAscStatType.none) {
            return item.statValue == 0 ? GsValidLevel.good : GsValidLevel.warn3;
          }
          return vdNum(item.statValue, 1);
        },
      ),
      DataField.textField(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
        validator: (item) => vdText(item.desc),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
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
        validator: (item) => vdContainsValidId(item.matWeapon, matWeapon),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.matCommon,
        (item) => GsItemFilter.matGroups(GeMaterialType.normalDrops).filters,
        (item, value) => item.copyWith(matCommon: value),
        validator: (item) => vdContainsValidId(item.matCommon, matCommon),
      ),
      DataField.singleSelect(
        'Material Elite',
        (item) => item.matElite,
        (item) => GsItemFilter.matGroups(GeMaterialType.eliteDrops).filters,
        (item, value) => item.copyWith(matElite: value),
        validator: (item) => vdContainsValidId(item.matElite, matElite),
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
}

GsValidLevel _vdWeaponAsc(String atkValues, String statValues) {
  final atk = atkValues.split(',').where((e) => e.isNotEmpty);
  final stat = statValues.split(',').where((e) => e.isNotEmpty);
  return (atk.isNotEmpty && stat.isEmpty) || atk.length == stat.length
      ? GsValidLevel.good
      : GsValidLevel.warn3;
}
