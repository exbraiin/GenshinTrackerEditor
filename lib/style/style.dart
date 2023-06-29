import 'dart:convert';

import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GsConfigurations {
  GsConfigurations._();

  static Map<String, List<String>>? _map;
  static Future<void> load() async {
    if (_map != null) return;
    final raw = await rootBundle.loadString('assets/config.json');
    final data = jsonDecode(raw) as JsonMap;
    _map = data.map((k, v) => MapEntry(k, (v as List).cast<String>()));
  }

  static List<String> _list(String name) => _map?[name] ?? const [];
  static final achievementTypes = _list('achievement_type');
  static final namecardTypes = _list('namecard_type');
  static final recipeEffect = _list('recipe_effect');
  static final bannerTypes = _list('banner_type');
  static final weaponTypes = _list('weapon_type');
  static final elements = _list('elements');
  static final statTypes = _list('weapon_stats');
  static final recipeTypes = _list('recipe_types');
  static final weekdays = _list('weekdays');
  static final artifactPieces = _list('artifact_pieces');
  static final sereniteaType = _list('serenitea_sets');
  static final materialCategories = _list('material_category');
  static final itemSource = _list('item_source');
  static final talentTypes = _list('talent_types');
  static final weaponStatTypes = _list('weapon_ascension_stats');
  static final rChestSource = _list('rchest_source');
  static final rChestCategory = _list('rchest_category');
  static final characterStatTypes = _list('character_ascension_stats');
}

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
    return const {
          'standard': Colors.purple,
          'beginner': Colors.yellow,
          'character': Colors.lightGreen,
          'weapon': Colors.lightBlue,
        }[type] ??
        Colors.white;
  }

  static Color getSereniteaColor(String type) {
    return const {
          'indoor': Color(0xFFA01F2E),
          'outdoor': Color(0xFF303671),
        }[type] ??
        Colors.white;
  }

  static Color getElementColor(String element) {
    return const {
          'anemo': Color(0xFF71c2a7),
          'geo': Color(0xFFf2b723),
          'electro': Color(0xFFb38dc1),
          'dendro': Color(0xFF9cc928),
          'hydro': Color(0xFF5fc1f1),
          'pyro': Color(0xFFea7838),
          'cryo': Color(0xFFa4d6e3),
        }[element] ??
        Colors.grey;
  }

  static Color? getRegionElementColor(String region) {
    final element = Database.i.cities.getItem(region)?.element;
    if (element == null) return null;
    return getElementColor(element);
  }

  static Color getNamecardColor(String type) {
    final idx = GsConfigurations.namecardTypes.toList().indexOf(type);
    return getRarityColor((idx + 5) % 4 + 1);
  }

  static Color getVersionColor(String id) {
    final idx = (double.tryParse(id) ?? 1.0).toInt();
    return getRarityColor((idx + 5) % 5);
  }
}
