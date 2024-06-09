import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsGraphics {
  GsGraphics._();

  static const bgImg = 'assets/bg.png';

  static String getRecipeEffectIcon(GeRecipeEffectType type) {
    const folder = 'assets/icons_food';
    return switch (type) {
      GeRecipeEffectType.adventure => '$folder/adventure.png',
      GeRecipeEffectType.atkBoost => '$folder/atkBoost.png',
      GeRecipeEffectType.atkCritBoost => '$folder/atkCritBoost.png',
      GeRecipeEffectType.defBoost => '$folder/defBoost.png',
      GeRecipeEffectType.recoveryHP => '$folder/recoveryHP.png',
      GeRecipeEffectType.recoveryHPAll => '$folder/recoveryHPAll.png',
      GeRecipeEffectType.revive => '$folder/revive.png',
      GeRecipeEffectType.staminaIncrease => '$folder/staminaIncrease.png',
      GeRecipeEffectType.staminaReduction => '$folder/staminaReduction.png',
      GeRecipeEffectType.none => '',
    };
  }
}

class GsStyle {
  GsStyle._();

  static final kMainDecoration = BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.multiply,
      ),
      image: const AssetImage(GsGraphics.bgImg),
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
    return getRarityColor((idx + 5) % 5);
  }
}
