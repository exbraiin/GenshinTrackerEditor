import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeEnemyFamilyType implements GeEnum {
  none('none'),
  elemetalLifeform('elemental_lifeform'),
  hilichurl('hilichurl'),
  abyss('abyss'),
  fatui('fatui'),
  automaton('automaton'),
  humanFaction('human_faction'),
  mysticalBeast('mystical_beast'),
  weeklyBoss('weekly_boss');

  @override
  final String id;
  const GeEnemyFamilyType(this.id);
}
