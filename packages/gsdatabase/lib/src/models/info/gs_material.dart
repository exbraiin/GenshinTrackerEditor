import 'package:gsdatabase/src/enums/ge_material_type.dart';
import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/enums/ge_weekday_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_material.g.dart';

@BuilderGenerator()
abstract class IGsMaterial extends GsModel<IGsMaterial> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('group')
  GeMaterialType get group;
  @BuilderWire('image')
  String get image;
  @BuilderWire('region')
  GeRegionType get region;
  @BuilderWire('subgroup')
  int get subgroup;
  @BuilderWire('version')
  String get version;
  @BuilderWire('ingredient')
  bool get ingredient;
  @BuilderWire('weekdays')
  List<GeWeekdayType> get weekdays;
}
