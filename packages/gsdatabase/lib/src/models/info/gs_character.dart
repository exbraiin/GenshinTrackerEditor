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
}
