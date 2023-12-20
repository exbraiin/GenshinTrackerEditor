import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_achievement_group.g.dart';

@BuilderGenerator()
abstract class IGsAchievementGroup extends GsModel<IGsAchievementGroup> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('icon')
  String get icon;
  @BuilderWire('version')
  String get version;
  @BuilderWire('namecard')
  String get namecard;
  @BuilderWire('order')
  int get order;
  @BuilderWire('rewards')
  int get rewards;
  @BuilderWire('achievements')
  int get achievements;
}
