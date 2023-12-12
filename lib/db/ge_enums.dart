import 'package:dartx/dartx.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

abstract class GeEnum {
  String get id;
}

enum GeAchievementType implements GeEnum {
  none(''),
  exploration('exploration'),
  quest('quest'),
  commission('commission'),
  boss('boss');

  @override
  final String id;
  const GeAchievementType(this.id);
}

enum GeNamecardType implements GeEnum {
  achievement('achievement'),
  battlepass('battlepass'),
  character('character'),
  defaults('default'),
  event('event'),
  offering('offering'),
  reputation('reputation');

  @override
  final String id;
  Color get color => GsStyle.getNamecardColor(id);
  const GeNamecardType(this.id);
}

enum GeRecipeEffectType implements GeEnum {
  recoveryHPAll('recoveryHPAll'),
  recoveryHP('recoveryHP'),
  revive('revive'),
  atkBoost('atkBoost'),
  staminaIncrease('staminaIncrease'),
  staminaReduction('staminaReduction'),
  atkCritBoost('atkCritBoost'),
  defBoost('defBoost'),
  adventure('adventure');

  @override
  final String id;
  const GeRecipeEffectType(this.id);
}

enum GeRecipeType implements GeEnum {
  event('event'),
  permanent('permanent');

  @override
  final String id;
  const GeRecipeType(this.id);
}

enum GeBannerType implements GeEnum {
  standard('standard', Colors.purple),
  beginner('beginner', Colors.yellow),
  character('character', Colors.lightGreen),
  weapon('weapon', Colors.lightBlue);

  @override
  final String id;
  final Color color;

  /// Whether the banner type is beginner or standard.
  bool get isPermanent =>
      this == GeBannerType.beginner || this == GeBannerType.standard;

  const GeBannerType(this.id, this.color);
}

enum GeWeaponType implements GeEnum {
  bow('bow'),
  sword('sword'),
  polearm('polearm'),
  catalyst('catalyst'),
  claymore('claymore');

  @override
  final String id;
  const GeWeaponType(this.id);
}

enum GeElements implements GeEnum {
  anemo('anemo', Color(0xFF71c2a7)),
  geo('geo', Color(0xFFf2b723)),
  electro('electro', Color(0xFFb38dc1)),
  dendro('dendro', Color(0xFF9cc928)),
  hydro('hydro', Color(0xFF5fc1f1)),
  pyro('pyro', Color(0xFFea7838)),
  cryo('cryo', Color(0xFFa4d6e3));

  @override
  final String id;
  final Color color;
  const GeElements(this.id, this.color);
}

enum Regions implements GeEnum {
  none('none'),
  mondstadt('mondstadt'),
  liyue('liyue'),
  inazuma('inazuma'),
  sumeru('sumeru'),
  fontaine('fontaine'),
  natlan('natlan'),
  snezhnaya('snezhnaya');

  @override
  final String id;
  const Regions(this.id);
}

enum GeWeaponAscensionStatType implements GeEnum {
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
  const GeWeaponAscensionStatType(this.id);
}

enum GeCharacterAscensionStatType implements GeEnum {
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
  const GeCharacterAscensionStatType(this.id);
}

enum GeWeekdays implements GeEnum {
  sunday('Sunday'),
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday');

  @override
  final String id;
  const GeWeekdays(this.id);
}

enum GeArtifactPieces implements GeEnum {
  flowerOfLife('flower_of_life'),
  plumeOfDeath('plume_of_death'),
  sandsOfEon('sands_of_eon'),
  gobletOfEonothem('goblet_of_eonothem'),
  circletOfLogos('circlet_of_logos');

  @override
  final String id;
  const GeArtifactPieces(this.id);
}

enum GeEventType implements GeEnum {
  event('event'),
  login('login'),
  flagship('flagship'),
  battlepass('battlepass');

  @override
  final String id;
  const GeEventType(this.id);
}

enum GeMaterialCategory implements GeEnum {
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
  const GeMaterialCategory(this.id);
}

enum GeSereniteaSets implements GeEnum {
  indoor('indoor', Color(0xFFA01F2E)),
  outdoor('outdoor', Color(0xFF303671));

  @override
  final String id;
  final Color color;
  const GeSereniteaSets(this.id, this.color);
}

enum GeRmChestCategory implements GeEnum {
  animal('Animal'),
  building('Building'),
  companion('Companion'),
  courtyard('Courtyard'),
  decoration('Decoration'),
  landform('Landform'),
  landscape('Landscape'),
  largeFurnishing('Large Furnishing'),
  mainBuilding('Main Building'),
  ornaments('Ornaments'),
  outdoorFurnishing('Outdoor Furnishing'),
  smallFurnishing('Small Furnishing'),
  wallDecor('Wall Decor');

  @override
  final String id;
  const GeRmChestCategory(this.id);
}

enum GeItemSource implements GeEnum {
  shop('shop'),
  event('event'),
  fishing('fishing'),
  forging('forging'),
  battlepass('battlepass'),
  exploration('exploration'),
  wishesStandard('wishes_standard'),
  wishesWeaponBanner('wishes_weapon_banner'),
  wishesCharacterBanner('wishes_character_banner');

  @override
  final String id;
  const GeItemSource(this.id);
}

enum GeCharacterTalentType implements GeEnum {
  normalAttack('Normal Attack'),
  elementalSkill('Elemental Skill'),
  elementalBurst('Elemental Burst'),
  alternateSprint('Alternate Sprint'),
  ascension1stPassive('1st Ascension Passive'),
  ascension4thPassive('4th Ascension Passive'),
  utilityPassive('Utility Passive');

  @override
  final String id;
  const GeCharacterTalentType(this.id);
}

enum GeCharacterModelType implements GeEnum {
  shortFemale('short_female'),
  mediumMale('medium_male'),
  mediumFemale('medium_female'),
  tallMale('tall_male'),
  tallFemale('tall_female');

  @override
  final String id;
  const GeCharacterModelType(this.id);
}

enum GeEnemyType implements GeEnum {
  none('none'),
  common('common'),
  elite('elite'),
  normalBoss('normal_boss'),
  weeklyBoss('weekly_boss');

  @override
  final String id;
  const GeEnemyType(this.id);
}

enum GeEnemyFamily implements GeEnum {
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
  const GeEnemyFamily(this.id);
}

extension GeEnumListExt<T extends GeEnum> on List<T> {
  T fromId(String id) => firstOrNullWhere((e) => e.id == id) ?? first;

  List<GsSelectItem<T>> toChips() {
    Color getColor(T value) {
      if (value is GeWeekdays) return GeElements.values[value.index].color;
      if (value is GeElements) return value.color;
      if (value is GeBannerType) return value.color;
      if (value is GeSereniteaSets) return value.color;
      return Colors.grey;
    }

    String getAsset(T value) {
      if (value is GeRecipeEffectType) {
        return GsGraphics.getRecipeEffectIcon(value.id);
      }
      return '';
    }

    return map((value) {
      return GsSelectItem(
        value,
        value.id.isEmpty ? 'None' : value.id.toTitle(),
        color: getColor(value),
        asset: getAsset(value),
      );
    }).toList();
  }
}
