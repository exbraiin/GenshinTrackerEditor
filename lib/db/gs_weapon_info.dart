import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsWeaponInfo extends GsModel {
  @override
  final String id;
  final String effectName;
  final String effectDesc;
  final String matWeapon;
  final String matCommon;
  final String matElite;
  final String ascStatType;
  final String ascAtkValues;
  final String ascStatValues;

  GsWeaponInfo({
    this.id = '',
    this.effectName = '',
    this.effectDesc = '',
    this.matWeapon = '',
    this.matCommon = '',
    this.matElite = '',
    this.ascStatType = '',
    this.ascAtkValues = '',
    this.ascStatValues = '',
  });

  GsWeaponInfo.fromMap(JsonMap m)
      : id = m.getString('id'),
        effectName = m.getString('effect_name'),
        effectDesc = m.getString('effect_desc'),
        matWeapon = m.getString('mat_weapon'),
        matCommon = m.getString('mat_common'),
        matElite = m.getString('mat_elite'),
        ascStatType = m.getString('asc_stat_type'),
        ascAtkValues = m.getString('asc_atk_values'),
        ascStatValues = m.getString('asc_stat_values');

  GsWeaponInfo copyWith({
    String? id,
    String? effectName,
    String? effectDesc,
    String? matWeapon,
    String? matCommon,
    String? matElite,
    String? ascStatType,
    String? ascAtkValues,
    String? ascStatValues,
  }) {
    return GsWeaponInfo(
      id: id ?? this.id,
      effectName: effectName ?? this.effectName,
      effectDesc: effectDesc ?? this.effectDesc,
      matWeapon: matWeapon ?? this.matWeapon,
      matCommon: matCommon ?? this.matCommon,
      matElite: matElite ?? this.matElite,
      ascStatType: ascStatType ?? this.ascStatType,
      ascAtkValues: ascAtkValues ?? this.ascAtkValues,
      ascStatValues: ascStatValues ?? this.ascStatValues,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'effect_name': effectName,
        'effect_desc': effectDesc,
        'mat_weapon': matWeapon,
        'mat_common': matCommon,
        'mat_elite': matElite,
        'asc_stat_type': ascStatType,
        'asc_atk_values': ascAtkValues,
        'asc_stat_values': ascStatValues,
      };
}
