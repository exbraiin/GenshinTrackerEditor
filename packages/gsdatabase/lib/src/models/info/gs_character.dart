import 'package:gsdatabase/src/enums/ge_char_constellation_type.dart';
import 'package:gsdatabase/src/enums/ge_char_talent_type.dart';
import 'package:gsdatabase/src/enums/ge_character_asc_stat_type.dart';
import 'package:gsdatabase/src/enums/ge_element_type.dart';
import 'package:gsdatabase/src/enums/ge_item_source_type.dart';
import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/enums/ge_weapon_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_character.g.dart';

@BuilderGenerator()
abstract class IGsCharacter extends GsModel<IGsCharacter> {
  @BuilderWire('enka_id')
  String get enkaId;
  @BuilderWire('name')
  String get name;
  @BuilderWire('title')
  String get title;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('region')
  GeRegionType get region;
  @BuilderWire('weapon')
  GeWeaponType get weapon;
  @BuilderWire('element')
  GeElementType get element;
  @BuilderWire('version')
  String get version;
  @BuilderWire('source')
  GeItemSourceType get source;
  @BuilderWire('description')
  String get description;
  @BuilderWire('constellation')
  String get constellation;
  @BuilderWire('affiliation')
  String get affiliation;
  @BuilderWire('special_dish')
  String get specialDish;
  @BuilderWire('birthday')
  DateTime get birthday;
  @BuilderWire('release_date')
  DateTime get releaseDate;
  @BuilderWire('image')
  String get image;
  @BuilderWire('side_image')
  String get sideImage;
  @BuilderWire('full_image')
  String get fullImage;

  @BuilderWire('constellation_image')
  String get constellationImage;
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

@BuilderGenerator()
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

@BuilderGenerator()
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
