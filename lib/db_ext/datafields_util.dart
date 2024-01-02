import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsItemFilter {
  final Iterable<GsSelectItem<String>> filters;

  Iterable<String> get ids => filters.map((e) => e.value);

  GsItemFilter._(this.filters);

  static GsItemFilter _from<T>(
    Iterable<T> models,
    String Function(T i) selector, {
    String? noneId,
    String Function(T i)? title,
    String Function(T i)? icon,
    String? Function(T i)? image,
    Color Function(T i)? color,
  }) {
    return GsItemFilter._([
      if (noneId != null) GsSelectItem(noneId, 'None', image: ''),
      ...models.map((e) {
        final value = selector(e);
        return GsSelectItem(
          value,
          title?.call(e) ?? value.toTitle(),
          asset: icon?.call(e) ?? '',
          color: color?.call(e) ?? Colors.grey,
          image: image?.call(e),
        );
      }),
    ]);
  }

  factory GsItemFilter.artifactPieces() =>
      GsItemFilter._from(GeArtifactPieceType.values, (i) => i.id);

  factory GsItemFilter.eventType() =>
      GsItemFilter._from(GeEventType.values, (i) => i.id);

  factory GsItemFilter.talents() =>
      GsItemFilter._from(GeCharTalentType.values, (i) => i.id);

  factory GsItemFilter.constellations() =>
      GsItemFilter._from(GeCharConstellationType.values, (i) => i.id);

  factory GsItemFilter.regions() => GsItemFilter._from(
        GeRegionType.values,
        noneId: '',
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRegionElementColor(i) ?? Colors.grey,
      );

  // ----- DATABASE ------------------------------------------------------------

  factory GsItemFilter.rarities([int min = 1]) => GsItemFilter._from(
        List.generate(6 - min, (index) => min + index),
        (i) => i.toString(),
        color: GsStyle.getRarityColor,
      );

  factory GsItemFilter.namecards([GeNamecardType? type, String? id]) {
    var items = Database.i.of<GsNamecard>().items;
    if (type != null) items = items.where((e) => e.type == type);
    if (id != null) {
      final ids = switch (type) {
        GeNamecardType.battlepass =>
          Database.i.of<GsBattlepass>().items.map((e) => e.namecardId),
        GeNamecardType.character =>
          Database.i.of<GsCharacter>().items.map((e) => e.namecardId),
        GeNamecardType.achievement =>
          Database.i.of<GsAchievementGroup>().items.map((e) => e.namecard),
        _ => <String>[],
      };
      items = items.where((e) => e.id == id || !ids.contains(e.id));
    }

    return GsItemFilter._from(
      items,
      (i) => i.id,
      noneId: 'none',
      title: (i) => i.name,
      image: (i) => i.image,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }

  factory GsItemFilter.versions() => GsItemFilter._from(
        Database.i.of<GsVersion>().items,
        (i) => i.id,
        color: (i) => GsStyle.getVersionColor(i.id),
      );
  factory GsItemFilter.ingredients() => GsItemFilter._from(
        Database.i
            .of<GsMaterial>()
            .items
            .where((e) => e.ingredient)
            .sortedBy((e) => e.rarity)
            .thenBy((e) => e.id),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
        image: (i) => i.image,
      );
  factory GsItemFilter.furnishing() => GsItemFilter._from(
        Database.i.of<GsFurnishing>().items,
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
        image: (i) => i.image,
      );
  factory GsItemFilter.specialDishes({GsCharacter? character}) {
    final allRecipes = Database.i.of<GsRecipe>().items;
    var recipes = allRecipes.where((e) => e.baseRecipe.isNotEmpty);
    if (character != null) {
      final allChars = Database.i.of<GsCharacter>().items;
      final chars = allChars.where((e) => e.id != character.id);
      recipes = recipes.where((e) => chars.all((c) => c.specialDish != e.id));
    }
    return GsItemFilter._from(
      recipes,
      (i) => i.id,
      noneId: 'none',
      title: (i) => i.name,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
  factory GsItemFilter.nonBaseRecipes() {
    final allRecipes = Database.i.of<GsRecipe>().items;
    final recipes = allRecipes.where((e) => e.baseRecipe.isEmpty);
    return GsItemFilter._from(
      recipes,
      (i) => i.id,
      noneId: '',
      title: (i) => i.name,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
  factory GsItemFilter.achievementGroups() => GsItemFilter._from(
        Database.i.of<GsAchievementGroup>().items,
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(4),
      );
  factory GsItemFilter.chars() => GsItemFilter._from(
        Database.i.of<GsCharacter>().items,
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );

  factory GsItemFilter.matGroups(
    GeMaterialType type, [
    GeMaterialType? type1,
  ]) {
    Color getColor(GsMaterial mat) {
      return [
        GeMaterialType.ascensionGems,
        GeMaterialType.normalBossDrops,
        GeMaterialType.regionMaterials,
        GeMaterialType.talentMaterials,
        GeMaterialType.weaponMaterials,
        GeMaterialType.weeklyBossDrops,
      ].contains(type)
          ? GsStyle.getRegionElementColor(mat.region) ?? Colors.grey
          : GsStyle.getRarityColor(mat.rarity);
    }

    int regionElementIndex(GeRegionType region) {
      return Database.i.of<GsRegion>().getItem(region.id)?.element.index ?? -1;
    }

    return GsItemFilter._from(
      Database.i
          .getMaterialGroups(type, type1)
          .sortedBy((element) => regionElementIndex(element.region))
          .thenBy((element) => element.rarity)
          .thenBy((element) => element.version)
          .thenBy((element) => element.name)
          .toList(),
      (i) => i.id,
      title: (i) => i.name,
      image: (i) => i.image,
      color: getColor,
    );
  }

  factory GsItemFilter.wishes(int? rarity, GeBannerType? type) =>
      GsItemFilter._from(
        Database.i.getAllWishes(rarity, type).sortedBy((e) => e.name),
        (i) => i.id,
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
        image: (i) => i.image,
      );

  factory GsItemFilter.drops(int? rarity, GeEnemyType? type) {
    bool isValidMat(GsMaterial mat) {
      late final matType = switch (type) {
        GeEnemyType.common => [GeMaterialType.normalDrops],
        GeEnemyType.elite => [
            GeMaterialType.normalDrops,
            GeMaterialType.eliteDrops,
          ],
        GeEnemyType.normalBoss => [GeMaterialType.normalBossDrops],
        GeEnemyType.weeklyBoss => [GeMaterialType.weeklyBossDrops],
        _ => [],
      };

      return (rarity == null || mat.rarity == rarity) &&
          (type == null || matType.contains(mat.group));
    }

    return GsItemFilter._from(
      Database.i.of<GsMaterial>().items.where(isValidMat),
      (i) => i.id,
      title: (i) => i.name,
      image: (i) => i.image,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
}
