import 'package:gsdatabase/src/enums/ge_weapon_asc_stat_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

// part 'gs_weapon_info.g.dart';

// @BuilderGenerator()
abstract class IGsWeaponInfo extends GsModel<IGsWeaponInfo> {
  @BuilderWire('effect_name')
  String get effectName;
  @BuilderWire('effect_desc')
  String get effectDesc;
  @BuilderWire('mat_weapon')
  String get matWeapon;
  @BuilderWire('mat_common')
  String get matCommon;
  @BuilderWire('mat_elite')
  String get matElite;
  @BuilderWire('asc_stat_type')
  GeWeaponAscStatType get ascStatType;
  @BuilderWire('asc_atk_values')
  String get ascAtkValues;
  @BuilderWire('asc_stat_values')
  String get ascStatValues;
}
