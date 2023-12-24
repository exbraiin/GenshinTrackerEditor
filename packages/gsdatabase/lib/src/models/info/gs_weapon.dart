import 'package:gsdatabase/src/enums/ge_item_source_type.dart';
import 'package:gsdatabase/src/enums/ge_weapon_asc_stat_type.dart';
import 'package:gsdatabase/src/enums/ge_weapon_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_weapon.g.dart';

@BuilderGenerator()
abstract mixin class _GsWeapon implements GsModel<GsWeapon> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('image')
  String get image;
  @BuilderWire('image_asc')
  String get imageAsc;
  @BuilderWire('type')
  GeWeaponType get type;
  @BuilderWire('atk')
  int get atk;
  @BuilderWire('stat_type')
  GeWeaponAscStatType get statType;
  @BuilderWire('stat_value')
  double get statValue;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('version')
  String get version;
  @BuilderWire('source')
  GeItemSourceType get source;

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
  @BuilderWire('asc_atk_values')
  String get ascAtkValues;
  @BuilderWire('asc_stat_values')
  String get ascStatValues;

  @override
  Iterable<Comparable Function(GsWeapon e)> get sorters => [
        (e) => e.rarity,
      ];
}
