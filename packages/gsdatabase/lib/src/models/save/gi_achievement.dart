import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_achievement.g.dart';

@BuilderGenerator()
abstract mixin class _GiAchievement implements GsModel<GiAchievement> {
  @BuilderWire('obtained')
  int get obtained;
}
