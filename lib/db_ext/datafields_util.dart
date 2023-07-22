import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsItemFilter {
  static const wishChar = 'character';
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

  static GsItemFilter _fromStrings(
    Iterable<String> models, {
    String Function(String i)? title,
    String Function(String i)? icon,
    Color Function(String i)? color,
  }) =>
      GsItemFilter._from(
        models,
        (i) => i,
        title: title,
        icon: icon,
        color: color,
      );

  factory GsItemFilter.artifactPieces() =>
      GsItemFilter._fromStrings(GsConfigurations.artifactPieces);
  factory GsItemFilter.rChestCategory() =>
      GsItemFilter._fromStrings(GsConfigurations.rChestCategory);
  factory GsItemFilter.rChestSource() =>
      GsItemFilter._fromStrings(GsConfigurations.rChestSource);
  factory GsItemFilter.recipeType() =>
      GsItemFilter._fromStrings(GsConfigurations.recipeTypes);
  factory GsItemFilter.matCategories() =>
      GsItemFilter._fromStrings(GsConfigurations.materialCategories);
  factory GsItemFilter.weekdays() =>
      GsItemFilter._fromStrings(GsConfigurations.weekdays);
  factory GsItemFilter.itemSource() =>
      GsItemFilter._fromStrings(GsConfigurations.itemSource);
  factory GsItemFilter.chrStatTypes() =>
      GsItemFilter._fromStrings(GsConfigurations.characterStatTypes);
  factory GsItemFilter.weaponTypes() =>
      GsItemFilter._fromStrings(GsConfigurations.weaponTypes);
  factory GsItemFilter.statTypes() =>
      GsItemFilter._fromStrings(GsConfigurations.statTypes);
  factory GsItemFilter.modelType() =>
      GsItemFilter._fromStrings(GsConfigurations.characterModelType);

  factory GsItemFilter.weaponStatTypes() => GsItemFilter._fromStrings(
        ['', ...GsConfigurations.weaponStatTypes],
        title: (i) => i.isEmpty ? 'None' : i.toTitle(),
      );
  factory GsItemFilter.namecardTypes() => GsItemFilter._fromStrings(
        GsConfigurations.namecardTypes,
        color: GsStyle.getNamecardColor,
      );
  factory GsItemFilter.elements() => GsItemFilter._fromStrings(
        GsConfigurations.elements,
        color: GsStyle.getElementColor,
      );
  factory GsItemFilter.bannerTypes() => GsItemFilter._fromStrings(
        GsConfigurations.bannerTypes,
        color: GsStyle.getBannerColor,
      );
  factory GsItemFilter.achievementTypes() => GsItemFilter._fromStrings(
        ['', ...GsConfigurations.achievementTypes],
        title: (i) => i.isEmpty ? 'None' : i.toTitle(),
      );
  factory GsItemFilter.recipeEffects() => GsItemFilter._fromStrings(
        GsConfigurations.recipeEffect,
        icon: GsGraphics.getRecipeEffectIcon,
      );
  factory GsItemFilter.sereniteas() => GsItemFilter._fromStrings(
        GsConfigurations.sereniteaType,
        color: GsStyle.getSereniteaColor,
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
        color: (i) => GsStyle.getElementColor(i.element),
      );
  factory GsItemFilter.ingredients() => GsItemFilter._from(
        Database.i.ingredients.data,
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
  factory GsItemFilter.wishes(int? rarity, String? type) => GsItemFilter._from(
        Database.i.getAllWishes(rarity, type).sortedBy((e) => e.name),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
  factory GsItemFilter.achievementNamecards() => GsItemFilter._from(
        [
          GsNamecard(id: 'none', name: 'None'),
          ...Database.i.namecards.data.where((e) => e.type == 'achievement'),
        ],
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );
}
