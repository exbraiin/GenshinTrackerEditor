import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeWeaponAscStatType implements GeEnum {
  none('none'),
  hpPercent('hpPercent'),
  elementalMastery('elementalMastery'),
  atkPercent('atkPercent'),
  critDmg('critDmg'),
  energyRecharge('energyRecharge'),
  physicalDmg('physicalDmg'),
  critRate('critRate'),
  defPercent('defPercent');

  @override
  final String id;
  const GeWeaponAscStatType(this.id);
}
