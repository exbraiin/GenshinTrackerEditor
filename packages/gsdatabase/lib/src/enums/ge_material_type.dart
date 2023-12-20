import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeMaterialType implements GeEnum {
  none('none'),
  ascensionGems('ascension_gems'),
  forging('forging'),
  furnishing('furnishing'),
  normalDrops('normal_drops'),
  eliteDrops('elite_drops'),
  normalBossDrops('normal_boss_drops'),
  weeklyBossDrops('weekly_boss_drops'),
  regionMaterials('region_materials'),
  talentMaterials('talent_materials'),
  weaponMaterials('weapon_materials');

  @override
  final String id;
  const GeMaterialType(this.id);
}
