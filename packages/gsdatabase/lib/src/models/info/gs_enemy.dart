import 'package:gsdatabase/src/enums/ge_enemy_family_type.dart';
import 'package:gsdatabase/src/enums/ge_enemy_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_enemy.g.dart';

@BuilderGenerator()
abstract mixin class _GsEnemy implements GsModel<GsEnemy> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('title')
  String get title;
  @BuilderWire('image')
  String get image;
  @BuilderWire('full_image')
  String get fullImage;
  @BuilderWire('splash_image')
  String get splashImage;
  @BuilderWire('version')
  String get version;
  @BuilderWire('order')
  int get order;
  @BuilderWire('type')
  GeEnemyType get type;
  @BuilderWire('family')
  GeEnemyFamilyType get family;
  @BuilderWire('drops')
  List<String> get drops;

  @override
  Iterable<Comparable Function(GsEnemy e)> get sorters => [
        (e) => e.family.index,
        (e) => e.order,
      ];
}
