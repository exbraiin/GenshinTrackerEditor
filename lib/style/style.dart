import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/style/assets.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

abstract final class GsGraphics {
  static String getRecipeEffectIcon(GeRecipeEffectType type) {
    return switch (type) {
      GeRecipeEffectType.adventure => Assets.adventure,
      GeRecipeEffectType.atkBoost => Assets.atkBoost,
      GeRecipeEffectType.atkCritBoost => Assets.atkCritBoost,
      GeRecipeEffectType.defBoost => Assets.defBoost,
      GeRecipeEffectType.recoveryHP => Assets.recoveryHP,
      GeRecipeEffectType.recoveryHPAll => Assets.recoveryHPAll,
      GeRecipeEffectType.revive => Assets.revive,
      GeRecipeEffectType.staminaIncrease => Assets.staminaIncrease,
      GeRecipeEffectType.staminaReduction => Assets.staminaReduction,
      GeRecipeEffectType.special => Assets.special,
      GeRecipeEffectType.none => '',
    };
  }

  static String getRarityIcon(int rarity) {
    return switch (rarity) {
      1 => Assets.item1Star,
      2 => Assets.item2Star,
      3 => Assets.item3Star,
      4 => Assets.item4Star,
      5 => Assets.item5Star,
      _ => '',
    };
  }
}

abstract final class GsStyle {
  static final kMainDecoration = BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.multiply,
      ),
      image: const AssetImage(Assets.bg),
    ),
  );

  static Color getRarityColor(int rarity) {
    return switch (rarity) {
      1 => const Color(0xFF828E98),
      2 => const Color(0xFF5C956B),
      3 => const Color(0xFF51A2B4),
      4 => const Color(0xFFB783C8),
      5 => const Color(0xFFE2AA52),
      _ => Colors.grey,
    };
  }

  static Color? getRegionElementColor(GeRegionType region) {
    return Database.i.of<GsRegion>().getItem(region.id)?.element.color;
  }

  static Color getNamecardColor(GeNamecardType type) {
    return switch (type) {
      GeNamecardType.none => getRarityColor(1),
      GeNamecardType.defaults => getRarityColor(1),
      GeNamecardType.achievement => getRarityColor(2),
      GeNamecardType.offering => getRarityColor(2),
      GeNamecardType.event => getRarityColor(3),
      GeNamecardType.reputation => getRarityColor(3),
      GeNamecardType.character => getRarityColor(4),
      GeNamecardType.battlepass => getRarityColor(5),
    };
  }

  static Color getVersionColor(String id) {
    final idx = (double.tryParse(id) ?? 1.0).toInt();
    if (!idx.between(1, GeElementType.values.length)) {
      return GeElementType.none.color;
    }
    return GeElementType.values[idx + 1].color;
  }
}
