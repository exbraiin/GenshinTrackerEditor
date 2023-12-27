import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_achievement.g.dart';

@BuilderGenerator()
abstract class _GiAchievement extends GsModel<GiAchievement> {
  @BuilderWire('obtained')
  int get obtained;
}
