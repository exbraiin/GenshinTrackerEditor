import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsWeaponExt extends GsModelExt<GsWeapon> {
  const GsWeaponExt();

  @override
  List<DataField<GsWeapon>> getFields(GsWeapon? model) {
    final ids = Database.i.weapons.data.map((e) => e.id);
    final versions = GsItemFilter.versions().ids;
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
        validator: (item) => vdRarity(item.rarity),
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
      DataField.singleEnum<GsWeapon, GeItemSource>(
        'Source',
        GeItemSource.values.toChips(),
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        validator: (item) => vdContains(item.source, GeItemSource.values),
      ),
      DataField.textField(
        'Atk',
        (item) => item.atk.toString(),
        (item, value) => item.copyWith(atk: int.tryParse(value) ?? -1),
        validator: (item) => vdNum(item.atk, 1),
      ),
      DataField.singleEnum(
        'Stat Type',
        GeWeaponAscensionStatType.values.toChips(),
        (item) => item.statType,
        (item, value) => item.copyWith(statType: value),
        validator: (item) =>
            vdContains(item.statType, GeWeaponAscensionStatType.values),
      ),
      DataField.textField(
        'Stat Value',
        (item) => item.statValue.toString(),
        (item, v) => item.copyWith(statValue: double.tryParse(v) ?? -1),
        validator: (item) {
          if (item.statType == GeWeaponAscensionStatType.none) {
            return item.statValue == 0 ? GsValidLevel.good : GsValidLevel.error;
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
    ];
  }
}
