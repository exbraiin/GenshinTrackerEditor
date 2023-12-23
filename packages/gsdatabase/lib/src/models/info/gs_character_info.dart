import 'package:gsdatabase/src/enums/ge_character_asc_stat_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';
import 'package:gsdatabase/src/models/info/gs_character.dart';

// part 'gs_character_info.g.dart';

// @BuilderGenerator()
abstract class IGsCharacterInfo extends GsModel<IGsCharacterInfo> {
  @BuilderWire('mat_gem')
  String get gemMaterial;
  @BuilderWire('mat_boss')
  String get bossMaterial;
  @BuilderWire('mat_common')
  String get commonMaterial;
  @BuilderWire('mat_region')
  String get regionMaterial;
  @BuilderWire('mat_talent')
  String get talentMaterial;
  @BuilderWire('mat_weekly')
  String get weeklyMaterial;
  @BuilderWire('asc_stat_type')
  GeCharacterAscStatType get ascStatType;
  @BuilderWire('asc_hp_values')
  String get ascHpValues;
  @BuilderWire('asc_atk_values')
  String get ascAtkValues;
  @BuilderWire('asc_def_values')
  String get ascDefValues;
  @BuilderWire('asc_stat_values')
  String get ascStatValues;
  @BuilderWire('talents')
  List<IGsCharTalent> get talents;
  @BuilderWire('constellations')
  List<IGsCharConstellation> get constellations;
}

/*
// @BuilderGenerator()
abstract class IGsCharTalent extends GsModel<IGsCharTalent> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('type')
  GeCharTalentType get type;
  @BuilderWire('icon')
  String get icon;
  @BuilderWire('desc')
  String get desc;
}

// @BuilderGenerator()
abstract class IGsCharConstellation extends GsModel<IGsCharConstellation> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('icon')
  String get icon;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('type')
  GeCharConstellationType get type;
}
*/
