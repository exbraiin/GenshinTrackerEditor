import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_achievement.g.dart';

@BuilderGenerator()
abstract class IGiAchievement extends GsModel<IGiAchievement> {
  @BuilderWire('obtained')
  int get obtained;
}
