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

    return GsItemFilter._from(
      Database.i
          .getMaterialGroups(type, type1)
          .sortedBy((element) => element.region)
          .thenBy((element) => element.rarity)
          .toList(),
      (i) => i.id,
      title: (i) => i.name,
      color: getColor,
    );
  }

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
