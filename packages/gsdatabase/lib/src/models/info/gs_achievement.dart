import 'package:gsdatabase/src/enums/ge_achievement_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_achievement.g.dart';

@BuilderGenerator()
abstract class IGsAchievement extends GsModel<IGsAchievement> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('group')
  String get group;
  @BuilderWire('hidden')
  bool get hidden;
  @BuilderWire('version')
  String get version;
  @BuilderWire('type')
  GeAchievementType get type;
  @BuilderWire('phases')
  List<IGsAchievementPhase> get phases;
}

@BuilderGenerator()
abstract class IGsAchievementPhase extends GsModel<IGsAchievementPhase> {
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('reward')
  int get reward;
}
