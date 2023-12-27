import 'package:gsdatabase/src/enums/ge_achievement_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_achievement.g.dart';

@BuilderGenerator()
abstract class _GsAchievement extends GsModel<GsAchievement> {
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
  List<_GsAchievementPhase> get phases;

  @override
  Iterable<Comparable Function(GsAchievement e)> get sorters => [
        (e) => e.version,
      ];
}

@BuilderGenerator()
abstract class _GsAchievementPhase extends GsModel<GsAchievementPhase> {
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('reward')
  int get reward;
}
