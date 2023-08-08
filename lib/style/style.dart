import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:flutter/material.dart';

class GsGraphics {
  GsGraphics._();

  static const bgImg = 'assets/bg.png';

  static const _icons = {
    'adventure': 'assets/icons_food/adventure.png',
    'atkBoost': 'assets/icons_food/atkBoost.png',
    'atkCritBoost': 'assets/icons_food/atkCritBoost.png',
    'defBoost': 'assets/icons_food/defBoost.png',
    'recoveryHP': 'assets/icons_food/recoveryHP.png',
    'recoveryHPAll': 'assets/icons_food/recoveryHPAll.png',
    'revive': 'assets/icons_food/revive.png',
    'staminaIncrease': 'assets/icons_food/staminaIncrease.png',
    'staminaReduction': 'assets/icons_food/staminaReduction.png',
  };
  static String getRecipeEffectIcon(String effect) => _icons[effect] ?? '';
}

class GsStyle {
  GsStyle._();

  static Color getRarityColor(int rarity) {
    return const {
          1: Color(0xFF828E98),
          2: Color(0xFF5C956B),
          3: Color(0xFF51A2B4),
          4: Color(0xFFB783C8),
          5: Color(0xFFE2AA52),
        }[rarity] ??
        Colors.white;
  }

  static Color getBannerColor(String type) {
    final item = GeBannerType.values.firstOrNullWhere((e) => e.id == type);
    return item?.color ?? Colors.white;
  }

  static Color getSereniteaColor(String type) {
    final item = GeSereniteaSets.values.firstOrNullWhere((e) => e.id == type);
    return item?.color ?? Colors.white;
  }

  static Color getElementColor(String element) {
    final item = GeElements.values.firstOrNullWhere((e) => e.id == element);
    return item?.color ?? Colors.grey;
  }

  static Color? getRegionElementColor(String region) {
    final element = Database.i.cities.getItem(region)?.element;
    return element?.color;
  }

  static Color getNamecardColor(String type) {
    final idx = GeNamecardType.values.indexWhere((e) => e.id == type);
    return getRarityColor((idx + 5) % 4 + 1);
  }

  static Color getVersionColor(String id) {
    final idx = (double.tryParse(id) ?? 1.0).toInt();
    return getRarityColor((idx + 5) % 5);
  }
}
