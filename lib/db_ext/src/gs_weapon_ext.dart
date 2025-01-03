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
    final vd = ValidateModels<GsWeapon>();
    final vdVersion = ValidateModels.versions();
    final vldMatElite = ValidateModels.materials(GeMaterialType.eliteDrops);
    final vldMatCommon = ValidateModels.materials(GeMaterialType.normalDrops);
    final vldMatWeapon =
        ValidateModels.materials(GeMaterialType.weaponMaterials);

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
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.textImage(
        'Asc Image',
        (item) => item.imageAsc,
        (item, value) => item.copyWith(imageAsc: value),
      ),
      DataField.singleEnum(
        'Type',
        GeWeaponType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        invalid: [GeWeaponType.none],
      ),
      DataField.singleEnum<GsWeapon, GeItemSourceType>(
        'Source',
        GeItemSourceType.values.toChips(),
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        invalid: [GeItemSourceType.none],
        validator: (item, level) {
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
      DataField.intField(
        'Atk',
        (item) => item.ascAtkValue,
        (item, value) => item.copyWith(ascAtkValue: value),
        range: (1, null),
      ),
      DataField.singleEnum(
        'Stat Type',
        GeWeaponAscStatType.values.toChips(),
        (item) => item.statType,
        (item, value) => item.copyWith(statType: value),
      ),
      DataField.doubleField(
        'Stat Value',
        (item) => item.ascStatValue,
        (item, value) => item.copyWith(ascStatValue: value),
        validator: (item) {
          if (!(item.ascStatValue != 0 ||
              item.ascStatValue == 0 &&
                  item.statType == GeWeaponAscStatType.none)) {
            return GsValidLevel.warn3;
          }
          return GsValidLevel.good;
        },
      ),
      DataField.textField(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.textField(
        'Effect Name',
        (item) => item.effectName,
        (item, value) => item.copyWith(effectName: value),
      ),
      DataField.textEditor(
        'Effect Desc',
        (item) => item.effectDesc,
        (item, value) => item.copyWith(effectDesc: value),
      ),
      DataField.singleSelect(
        'Material Weapon',
        (item) => item.matWeapon,
        (item) => vldMatWeapon.filters,
        (item, value) => item.copyWith(matWeapon: value),
        validator: (item) => vldMatWeapon.validate(item.matWeapon),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.matCommon,
        (item) => vldMatCommon.filters,
        (item, value) => item.copyWith(matCommon: value),
        validator: (item) => vldMatCommon.validate(item.matCommon),
      ),
      DataField.singleSelect(
        'Material Elite',
        (item) => item.matElite,
        (item) => vldMatElite.filters,
        (item, value) => item.copyWith(matElite: value),
        validator: (item) => vldMatElite.validate(item.matElite),
      ),
    ];
  }
}
