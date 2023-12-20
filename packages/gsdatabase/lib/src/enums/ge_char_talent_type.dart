import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeCharTalentType implements GeEnum {
  normalAttack('Normal Attack'),
  elementalSkill('Elemental Skill'),
  elementalBurst('Elemental Burst'),
  alternateSprint('Alternate Sprint'),
  ascension1stPassive('1st Ascension Passive'),
  ascension4thPassive('4th Ascension Passive'),
  utilityPassive('Utility Passive');

  @override
  final String id;
  const GeCharTalentType(this.id);
}
