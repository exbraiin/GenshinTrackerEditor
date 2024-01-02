import 'package:gsdatabase/gsdatabase.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_character.g.dart';

@BuilderGenerator()
abstract class _GsCharacter extends GsModel<GsCharacter> {
  @BuilderWire('enka_id')
  String get enkaId;
  @BuilderWire('name')
  String get name;
  @BuilderWire('namecard_id')
  String get namecardId;
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
  List<_GsCharTalent> get talents;
  @BuilderWire('constellations')
  List<_GsCharConstellation> get constellations;

  @override
  Iterable<Comparable Function(GsCharacter e)> get sorters => [
        (e) => e.rarity,
      ];
}

@BuilderGenerator()
abstract class _GsCharTalent extends GsModel<GsCharTalent> {
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
abstract class _GsCharConstellation extends GsModel<GsCharConstellation> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('icon')
  String get icon;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('type')
  GeCharConstellationType get type;
}
