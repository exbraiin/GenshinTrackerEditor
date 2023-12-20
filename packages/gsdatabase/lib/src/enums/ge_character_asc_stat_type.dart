import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeCharacterAscStatType implements GeEnum {
  anemoDmgBonus('anemoDmgBonus'),
  geoDmgBonus('geoDmgBonus'),
  electroDmgBonus('electroDmgBonus'),
  dendroDmgBonus('dendroDmgBonus'),
  hydroDmgBonus('hydroDmgBonus'),
  pyroDmgBonus('pyroDmgBonus'),
  cryoDmgBonus('cryoDmgBonus'),
  hpPercent('hpPercent'),
  atkPercent('atkPercent'),
  defPercent('defPercent'),
  critDmg('critDmg'),
  critRate('critRate'),
  healing('healing'),
  physicalDmg('physicalDmg'),
  energyRecharge('energyRecharge'),
  elementalMastery('elementalMastery');

  @override
  final String id;
  const GeCharacterAscStatType(this.id);
}
