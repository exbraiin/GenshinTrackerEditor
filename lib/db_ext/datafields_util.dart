import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

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
      if (noneId != null) GsSelectItem(noneId, 'None'),
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
      GsItemFilter._from(GeArtifactPieces.values, (i) => i.id);

  factory GsItemFilter.eventType() =>
      GsItemFilter._from(GeEventType.values, (i) => i.id);

  // ----- DATABASE ------------------------------------------------------------

  factory GsItemFilter.rarities([int min = 1]) => GsItemFilter._from(
        List.generate(6 - min, (index) => min + index),
        (i) => i.toString(),
        color: GsStyle.getRarityColor,
      );

  factory GsItemFilter.versions() => GsItemFilter._from(
        Database.i.versions.data,
        (i) => i.id,
        color: (i) => GsStyle.getVersionColor(i.id),
      );
  factory GsItemFilter.regions() => GsItemFilter._from(
        Database.i.cities.data,
        noneId: '',
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
        image: (i) => i.image,
      );
  factory GsItemFilter.specialDishes({GsCharacter? character}) {
    final allRecipes = Database.i.recipes.data;
    var recipes = allRecipes.where((e) => e.baseRecipe.isNotEmpty);
    if (character != null) {
      final allChars = Database.i.characters.data;
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
  factory GsItemFilter.nonBaseRecipes([GsRecipe? recipe]) {
    final items = Database.i.recipes.data;
    return GsItemFilter._from(
      items.where((e) => e.baseRecipe.isEmpty).where(
            (e) =>
                recipe?.baseRecipe == e.id ||
                !items.any((t) => t.baseRecipe == e.id),
          ),
      (i) => i.id,
      noneId: '',
      title: (i) => i.name,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
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

  factory GsItemFilter.matGroups(
    GeMaterialCategory type, [
    GeMaterialCategory? type1,
  ]) {
    Color getColor(GsMaterial mat) {
      return [
        GeMaterialCategory.ascensionGems,
        GeMaterialCategory.normalBossDrops,
        GeMaterialCategory.regionMaterials,
        GeMaterialCategory.talentMaterials,
        GeMaterialCategory.weaponMaterials,
        GeMaterialCategory.weeklyBossDrops,
      ].contains(type)
          ? GsStyle.getRegionElementColor(mat.region) ?? Colors.grey
          : GsStyle.getRarityColor(mat.rarity);
    }

    int regionElementIndex(String region) {
      return Database.i.cities.getItem(region)?.element.index ?? -1;
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
  factory GsItemFilter.achievementNamecards() => GsItemFilter._from(
        Database.i.namecards.data
            .where((e) => e.type == GeNamecardType.achievement),
        (i) => i.id,
        noneId: 'none',
        title: (i) => i.name,
        color: (i) => GsStyle.getRarityColor(i.rarity),
      );

  factory GsItemFilter.drops(int? rarity, GeEnemyType? type) {
    bool isValidMat(GsMaterial mat) {
      late final matType = switch (type) {
        GeEnemyType.common => [GeMaterialCategory.normalDrops],
        GeEnemyType.elite => [
            GeMaterialCategory.normalDrops,
            GeMaterialCategory.eliteDrops,
          ],
        GeEnemyType.normalBoss => [GeMaterialCategory.normalBossDrops],
        GeEnemyType.weeklyBoss => [GeMaterialCategory.weeklyBossDrops],
        _ => [],
      };

      return (rarity == null || mat.rarity == rarity) &&
          (type == null || matType.contains(mat.group));
    }

    return GsItemFilter._from(
      Database.i.materials.data.where(isValidMat),
      (i) => i.id,
      title: (i) => i.name,
      image: (i) => i.image,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
}
