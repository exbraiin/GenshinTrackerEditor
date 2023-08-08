import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsItemFilter {
  static const matGems = ['ascension_gems'];
  static const matBoss = ['normal_boss_drops'];
  static const matDrops = ['normal_drops', 'elite_drops'];
  static const matElite = ['elite_drops'];
  static const matNormal = ['normal_drops'];
  static const matWeek = ['weekly_boss_drops'];
  static const matWeapons = ['weapon_materials'];
  static const matRegion = ['region_materials'];
  static const matTalent = ['talent_materials'];

  final Iterable<GsSelectItem<String>> filters;

  Iterable<String> get ids => filters.map((e) => e.value);

  GsItemFilter._(this.filters);

  static GsItemFilter _from<T>(
    Iterable<T> models,
    String Function(T i) selector, {
    String Function(T i)? title,
    String Function(T i)? icon,
    Color Function(T i)? color,
  }) {
    return GsItemFilter._(
      models.map((e) {
        final value = selector(e);
        return GsSelectItem(
          value,
          title?.call(e) ?? value.toTitle(),
          icon: icon?.call(e) ?? '',
          color: color?.call(e) ?? Colors.grey,
        );
      }),
    );
  }

  static GsItemFilter _fromEnum<T extends GeEnum>(
    List<T> list, {
    String Function(T i)? title,
    String Function(T i)? icon,
    Color Function(T i)? color,
  }) =>
      GsItemFilter._from(
        list,
        (i) => i.id,
        title: title,
        icon: icon,
        color: color,
      );

  factory GsItemFilter.artifactPieces() =>
      GsItemFilter._fromEnum(GeArtifactPieces.values);
  factory GsItemFilter.rChestCategory() =>
      GsItemFilter._fromEnum(GeRmChestCategory.values);
  factory GsItemFilter.recipeType() =>
      GsItemFilter._fromEnum(GeRecipeType.values);
  factory GsItemFilter.matCategories() =>
      GsItemFilter._fromEnum(GeMaterialCategory.values);
  factory GsItemFilter.weekdays() => GsItemFilter._fromEnum(GeWeekdays.values);
  factory GsItemFilter.itemSource() =>
      GsItemFilter._fromEnum(GeItemSource.values);
  factory GsItemFilter.chrStatTypes() =>
      GsItemFilter._fromEnum(GeCharacterAscensionStatType.values);
  factory GsItemFilter.weaponTypes() =>
      GsItemFilter._fromEnum(GeWeaponType.values);
  factory GsItemFilter.modelType() =>
      GsItemFilter._fromEnum(GeCharacterModelType.values);
  factory GsItemFilter.weaponStatTypes() =>
      GsItemFilter._fromEnum(GeWeaponAscensionStatType.values);
  factory GsItemFilter.achievementTypes() =>
      GsItemFilter._fromEnum(GeAchievementType.values);

  factory GsItemFilter.namecardTypes() => GsItemFilter._fromEnum(
        GeNamecardType.values,
        color: (i) => i.color,
      );
  factory GsItemFilter.elements() => GsItemFilter._fromEnum(
        GeElements.values,
        color: (i) => i.color,
      );
  factory GsItemFilter.bannerTypes() => GsItemFilter._fromEnum(
        GeBannerType.values,
        color: (i) => i.color,
      );
  factory GsItemFilter.recipeEffects() => GsItemFilter._fromEnum(
        GeRecipeEffectType.values,
        icon: (i) => GsGraphics.getRecipeEffectIcon(i.id),
      );
  factory GsItemFilter.sereniteas() => GsItemFilter._fromEnum(
        GeSereniteaSets.values,
        color: (i) => i.color,
      );

  // ----- DATABASE ------------------------------------------------------------

  factory GsItemFilter.versions() => GsItemFilter._from(
        Database.i.versions.data,
        (i) => i.id,
        color: (i) => GsStyle.getVersionColor(i.id),
      );
  factory GsItemFilter.regions() => GsItemFilter._from(
        [GsCity(id: '', name: 'None'), ...Database.i.cities.data],
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => i.element.color,
      );
  factory GsItemFilter.ingredients() => GsItemFilter._from(
        Database.i.materials.data
            .where((e) => e.ingredient)
            .sortedBy((e) => e.rarity)
            .thenBy((e) => e.id),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.baseRecipes() => GsItemFilter._from(
        Database.i.getAllBaseRecipes(),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.nonBaseRecipes() => GsItemFilter._from(
        Database.i.getAllNonBaseRecipes(),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.achievementGroups() => GsItemFilter._from(
        Database.i.achievementGroups.data,
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(4),
      );
  factory GsItemFilter.chars() => GsItemFilter._from(
        Database.i.characters.data,
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.charsWithoutInfo() => GsItemFilter._from(
        Database.i.characters.data
            .where((e) => Database.i.characterInfo.getItem(e.id) == null),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.weaponsWithoutInfo() => GsItemFilter._from(
        Database.i.weapons.data
            .where((e) => Database.i.weaponInfo.getItem(e.id) == null),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.matGroupsWithRarity(List<String> types) =>
      GsItemFilter._from(
        Database.i.getMaterialGroups(types).toList(),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.matGroupsWithRegion(List<String> types) =>
      GsItemFilter._from(
        Database.i.getMaterialGroups(types).toList(),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRegionElementColor(i.region) ?? Colors.grey,
      );
  factory GsItemFilter.wishes(int? rarity, GeBannerType? type) =>
      GsItemFilter._from(
        Database.i.getAllWishes(rarity, type).sortedBy((e) => e.name),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.achievementNamecards() => GsItemFilter._from(
        [
          GsNamecard(id: 'none', name: 'None'),
          ...Database.i.namecards.data
              .where((e) => e.type == GeNamecardType.achievement),
        ],
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
}
