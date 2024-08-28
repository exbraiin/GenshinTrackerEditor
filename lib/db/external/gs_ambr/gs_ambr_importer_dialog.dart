import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/external/gs_ambr/gs_ambr_importer.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/widgets/gs_selector/src/gs_select_chip.dart';
import 'package:data_editor/widgets/gs_selector/src/gs_single_select.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

final class GsAmbrImporterDialog {
  static final i = GsAmbrImporterDialog._();
  GsAmbrImporterDialog._();

  Future<T> _fetch<T>(
    BuildContext context,
    T item,
    String title,
    Future<List<AmbrItem>> Function() fetchAll,
    Future<T?> Function(String id, [T? other]) fetch,
  ) async {
    final items = await fetchAll();
    if (!context.mounted) return item;
    String? id;
    await SelectDialog<String>(
      title: title,
      items: items
          .sortedBy((e) => e.level)
          .thenBy((e) => e.name)
          .map((item) => item.toSelect()),
      selected: null,
      onConfirm: (value) => id = value,
    ).show(context);
    if (id == null) return item;
    return await fetch(id!, item) ?? item;
  }

  Future<GsArtifact> fetchArtifact(BuildContext ctx, GsArtifact item) {
    return _fetch(
      ctx,
      item,
      'Artifacts',
      GsAmbrImporter.i.fetchArtifacts,
      GsAmbrImporter.i.fetchArtifact,
    );
  }

  Future<GsCharacter> fetchCharacter(BuildContext ctx, GsCharacter item) {
    return _fetch(
      ctx,
      item,
      'Characters',
      GsAmbrImporter.i.fetchCharacters,
      GsAmbrImporter.i.fetchCharacter,
    );
  }

  Future<GsNamecard> fetchNamecard(BuildContext ctx, GsNamecard item) {
    return _fetch(
      ctx,
      item,
      'Namecards',
      GsAmbrImporter.i.fetchNamecards,
      GsAmbrImporter.i.fetchNamecard,
    );
  }

  Future<GsRecipe> fetchRecipe(BuildContext context, GsRecipe item) {
    return _fetch(
      context,
      item,
      'Recipes',
      GsAmbrImporter.i.fetchRecipes,
      GsAmbrImporter.i.fetchRecipe,
    );
  }

  Future<GsWeapon> fetchWeapon(BuildContext ctx, GsWeapon item) {
    return _fetch(
      ctx,
      item,
      'Weapons',
      GsAmbrImporter.i.fetchWeapons,
      GsAmbrImporter.i.fetchWeapon,
    );
  }
}

extension on AmbrItem {
  GsSelectItem<String> toSelect() {
    final color = GsStyle.getRarityColor(level);
    return GsSelectItem<String>(id, name, image: icon, color: color);
  }
}
