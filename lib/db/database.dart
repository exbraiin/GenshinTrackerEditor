import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db/gs_achievement.dart';
import 'package:data_editor/db/gs_achievement_group.dart';
import 'package:data_editor/db/gs_artifact.dart';
import 'package:data_editor/db/gs_banner.dart';
import 'package:data_editor/db/gs_character.dart';
import 'package:data_editor/db/gs_character_info.dart';
import 'package:data_editor/db/gs_character_outfit.dart';
import 'package:data_editor/db/gs_city.dart';
import 'package:data_editor/db/gs_enemy.dart';
import 'package:data_editor/db/gs_material.dart';
import 'package:data_editor/db/gs_namecard.dart';
import 'package:data_editor/db/gs_recipe.dart';
import 'package:data_editor/db/gs_remarkable_chest.dart';
import 'package:data_editor/db/gs_serenitea.dart';
import 'package:data_editor/db/gs_spincrystal.dart';
import 'package:data_editor/db/gs_version.dart';
import 'package:data_editor/db/gs_viewpoint.dart';
import 'package:data_editor/db/gs_weapon.dart';
import 'package:data_editor/db/gs_weapon_info.dart';
import 'package:data_editor/db/gs_wish.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

export 'package:data_editor/db/gs_achievement.dart';
export 'package:data_editor/db/gs_achievement_group.dart';
export 'package:data_editor/db/gs_artifact.dart';
export 'package:data_editor/db/gs_banner.dart';
export 'package:data_editor/db/gs_character.dart';
export 'package:data_editor/db/gs_character_info.dart';
export 'package:data_editor/db/gs_character_outfit.dart';
export 'package:data_editor/db/gs_city.dart';
export 'package:data_editor/db/gs_enemy.dart';
export 'package:data_editor/db/gs_material.dart';
export 'package:data_editor/db/gs_namecard.dart';
export 'package:data_editor/db/gs_recipe.dart';
export 'package:data_editor/db/gs_remarkable_chest.dart';
export 'package:data_editor/db/gs_serenitea.dart';
export 'package:data_editor/db/gs_spincrystal.dart';
export 'package:data_editor/db/gs_version.dart';
export 'package:data_editor/db/gs_viewpoint.dart';
export 'package:data_editor/db/gs_weapon.dart';
export 'package:data_editor/db/gs_weapon_info.dart';
export 'package:data_editor/db/gs_wish.dart';

int _getCityIndex(String id) =>
    Database.i.cities.data.indexWhere((e) => e.id == id);

int _getCategoryIndex(String id) =>
    Database.i.achievementGroups.data.indexWhere((e) => e.id == id);

Future<Iterable<GsAchievementGroup>> _processAchGroups() {
  return compute(
    (tuple) {
      return tuple.groups.map((group) {
        final items = tuple.achievements.where((e) => e.group == group.id);
        final rewards = items.sumBy((e) => e.reward);
        final achievements = items.sumBy((e) => e.phases.length);
        return group.copyWith(rewards: rewards, achievements: achievements);
      });
    },
    (
      groups: Database.i.achievementGroups.data,
      achievements: Database.i.achievements.data,
    ),
  );
}

class Database {
  static final i = Database._();

  var _loaded = false;
  final modified = PublishSubject();
  final saving = BehaviorSubject<bool>.seeded(false);

  final achievementGroups = GsCollection(
    'src/achievement_categories.json',
    GsAchievementGroup.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.order)
        .thenBy((element) => element.name),
    dataToSave: _processAchGroups,
  );
  final achievements = GsCollection(
    'src/achievements.json',
    GsAchievement.fromMap,
    sorted: (list) => list
        .sortedBy((element) => _getCategoryIndex(element.group))
        .thenByDescending((element) => element.version)
        .thenBy((element) => element.name)
        .thenBy((element) => element.reward),
  );
  final artifacts = GsCollection(
    'src/artifacts.json',
    GsArtifact.fromMap,
    sorted: (list) => list
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => _getCityIndex(element.region))
        .thenBy((element) => element.domain)
        .thenBy((element) => element.id),
  );
  final banners = GsCollection(
    'src/banners.json',
    GsBanner.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.type.index)
        .thenBy((e) => DateTime.tryParse(e.dateStart) ?? DateTime(0))
        .thenBy((element) => element.id),
  );
  final characters = GsCollection(
    'src/characters.json',
    GsCharacter.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final characterInfo = GsCollection(
    'src/characters_info.json',
    GsCharacterInfo.fromMap,
    sorted: (list) {
      final characters = Database.i.characters.data;
      return list.sortedBy((e) => characters.indexWhere((c) => c.id == e.id));
    },
  );
  final characterOutfit = GsCollection(
    'src/characters_outfits.json',
    GsCharacterOutfit.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.name),
  );
  final cities = GsCollection(
    'src/cities.json',
    GsCity.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.element.index)
        .thenBy((element) => element.id),
  );
  final enemies = GsCollection(
    'src/enemies.json',
    GsEnemy.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.family.index)
        .thenBy((element) => element.type.index)
        .thenBy((element) => element.name),
  );
  final materials = GsCollection(
    'src/materials.json',
    GsMaterial.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.group.index)
        .thenBy((element) => _getCityIndex(element.region))
        .thenBy((element) => element.subgroup)
        .thenBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final namecards = GsCollection(
    'src/namecards.json',
    GsNamecard.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.type.index)
        .thenBy((element) => element.version)
        .thenBy((element) => element.id),
  );
  final recipes = GsCollection(
    'src/recipes.json',
    GsRecipe.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final remarkableChests = GsCollection(
    'src/remarkable_chests.json',
    GsRemarkableChest.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.type.index)
        .thenBy((element) => element.category.index)
        .thenBy((element) => element.name),
  );
  final sereniteas = GsCollection(
    'src/serenitea_sets.json',
    GsSerenitea.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.category.index)
        .thenBy((element) => element.id),
  );
  final spincrystal = GsCollection(
    'src/spincrystals.json',
    GsSpincrystal.fromMap,
    sorted: (list) => list.sortedBy((element) => element.number),
  );
  final versions = GsCollection(
    'src/versions.json',
    GsVersion.fromMap,
    sorted: (list) => list.sortedBy((element) => element.id),
  );
  final viewpoints = GsCollection(
    'src/viewpoints.json',
    GsViewpoint.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.region)
        .thenBy((element) => element.version)
        .thenBy((element) => element.name),
  );
  final weapons = GsCollection(
    'src/weapons.json',
    GsWeapon.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final weaponInfo = GsCollection(
    'src/weapons_info.json',
    GsWeaponInfo.fromMap,
    sorted: (list) {
      final weapons = Database.i.weapons.data;
      return list.sortedBy((w) => weapons.indexWhere((e) => e.id == w.id));
    },
  );

  GsCollection<R>? collectionOf<R extends GsModel<R>>() =>
      _collections[R] as GsCollection<R>?;

  Map<Type, GsCollection> get _collections => {
        GsAchievementGroup: achievementGroups,
        GsAchievement: achievements,
        GsArtifact: artifacts,
        GsBanner: banners,
        GsCharacter: characters,
        GsCharacterInfo: characterInfo,
        GsCharacterOutfit: characterOutfit,
        GsCity: cities,
        GsEnemy: enemies,
        GsMaterial: materials,
        GsNamecard: namecards,
        GsRecipe: recipes,
        GsRemarkableChest: remarkableChests,
        GsSerenitea: sereniteas,
        GsSpincrystal: spincrystal,
        GsVersion: versions,
        GsViewpoint: viewpoints,
        GsWeapon: weapons,
        GsWeaponInfo: weaponInfo,
      };

  Database._();

  Future<void> _updateAllDataValidators() {
    return DataValidator.i.checkAll();
  }

  Future<bool> load() async {
    if (_loaded) return _loaded;
    _loaded = true;
    await Future.wait(_collections.values.map((e) => e.load()));
    await _updateAllDataValidators();
    modified.add(null);
    return _loaded;
  }

  Future<void> save() async {
    if (!_loaded) return;
    if (saving.value) return;
    saving.add(true);
    await Future.wait(_collections.values.map((e) => e.save()));
    await _combine('src', 'data.json');
    saving.add(false);
  }

  Future<void> _combine(String src, String out) async {
    final entities = await Directory(src).list().toList();
    final files = entities.whereType<File>();

    final data = <String, dynamic>{};
    for (var file in files) {
      final path = file.path.replaceAll('\\', '/');
      final name = path.split('/').last.split('.').first;
      data[name] = json.decode(await file.readAsString());
    }

    final encoded = json.encode(data);
    await File(out).writeAsString(encoded);
  }
}

class GsCollection<T extends GsModel<T>> {
  final String src;
  final T Function(JsonMap m) create;
  final List<T> Function(List<T> list)? _sorted;
  final _data = <T>[];
  final Future<Iterable<T>> Function()? dataToSave;
  List<T> get data => _sorted?.call(_data) ?? _data.toList();

  String get type => (T == GsArtifact).toString();

  GsCollection(
    this.src,
    this.create, {
    this.dataToSave,
    List<T> Function(List<T> list)? sorted,
  }) : _sorted = sorted;

  T? getItem(String id) => _data.firstOrNullWhere((e) => e.id == id);

  Future<void> load() async {
    final file = File(src);
    if (!await file.exists()) return;
    final items = jsonDecode(await file.readAsString()) as JsonMap;
    final entries = items.entries.map((e) => create(e.toMapWithId()));
    _data
      ..clear()
      ..addAll(entries);
  }

  Future<void> save() async {
    final file = File(src);
    final data = await dataToSave?.call() ?? this.data;
    final map = data.map((e) => MapEntry(e.id, e.toJsonMap())).toMap();
    final encoded = jsonEncode(map);
    await file.writeAsString(encoded);
  }

  void updateItem(String? id, T item) {
    final idx = _data.indexWhere((e) => e.id == id);
    if (idx == -1) {
      _data.add(item);
    } else {
      _data[idx] = item;
    }
    if (id != null) DataValidator.i.checkLevel<T>(id, null);
    DataValidator.i.checkLevel<T>(item.id, item);
    Database.i.modified.add(null);
  }

  void updateAll(Iterable<T> items, {bool clear = false, bool check = false}) {
    if (clear) _data.clear();
    for (final item in items) {
      final idx = _data.indexWhere((e) => e.id == item.id);
      if (idx == -1) {
        _data.add(item);
      } else {
        _data[idx] = item;
      }
    }
    if (check) {
      for (final model in _data) {
        DataValidator.i.checkLevel<T>(model.id, model);
      }
    }
    Database.i.modified.add(null);
  }

  void delete(String? id) {
    if (id == null) return;
    _data.removeWhere((element) => element.id == id);
    DataValidator.i.checkLevel<T>(id, null);
    Database.i.modified.add(null);
  }
}

enum ItemState {
  none,
  current(color: Colors.green, label: 'New'),
  upcoming(color: Colors.lightBlue, label: 'Upcoming');

  final Color? color;
  final String? label;

  const ItemState({this.color, this.label});
}

typedef JsonMap = Map<String, dynamic>;

abstract class GsModel<T extends GsModel<T>> {
  String get id;
  JsonMap toJsonMap();
  T copyWith();
}

extension DatabaseExt on Database {
  Iterable<GsMaterial> getMaterialGroups(
    GeMaterialCategory type, [
    GeMaterialCategory? type1,
  ]) {
    return materials.data
        .where((e) => e.group == type || e.group == type1)
        .groupBy((e) => e.subgroup)
        .values
        .expand((l) {
      final rarity = l.minBy((m) => m.rarity)?.rarity ?? 1;
      return l.where((m) => m.rarity == rarity);
    });
  }

  ItemState getItemStateByVersion(String version) {
    final now = DateTime.now();
    final current = versions.data
        .lastOrNullWhere((element) => element.dateTime.isBefore(now));
    if (current != null && current.id == version) return ItemState.current;

    final vs = versions.data.firstOrNullWhere((e) => e.id == version);
    if (vs != null && vs.dateTime.isAfter(now)) return ItemState.upcoming;

    return ItemState.none;
  }

  List<GsWish> getAllWishes([int? rarity, GeBannerType? type]) {
    return [
      if (type == null || type == GeBannerType.weapon)
        ...weapons.data
            .where((e) => e.rarity == rarity || rarity == null)
            .map(GsWish.fromWeapon),
      if (type == null || type == GeBannerType.character)
        ...characters.data
            .where((e) => e.rarity == rarity || rarity == null)
            .map(GsWish.fromCharacter),
    ];
  }
}

extension MapEntryExt on MapEntry<String, dynamic> {
  JsonMap toMapWithId() => {'id': key, ...value as JsonMap? ?? {}};
}

extension JsonMapExt on JsonMap {
  /// Gets an [int] by [key] or [defaultValue].
  int getInt(String key, [int defaultValue = 0]) =>
      this[key] as int? ?? defaultValue;

  /// Gets a [bool] by [key] or [defaultValue].
  // ignore: avoid_positional_boolean_parameters
  bool getBool(String key, [bool defaultValue = false]) =>
      this[key] as bool? ?? defaultValue;

  /// Gets a [List] of [int] by [key] or [value].
  List<int> getIntList(String key, [List<int> value = const []]) =>
      (this[key] as List? ?? []).cast<int>();

  /// Gets a [double] by [key] or [defaultValue].
  double getDouble(String key, [double defaultValue = 0]) =>
      (this[key] as num? ?? defaultValue).toDouble();

  /// Gets a [String] by [key] or [defaultValue].
  String getString(String key, [String defaultValue = '']) =>
      this[key] as String? ?? defaultValue;

  /// Gets a [List] of [String] by [key] or [value].
  List<String> getStringList(String key, [List<String> value = const []]) =>
      (this[key] as List? ?? value).cast<String>();

  List<T> getListOf<T>(String key, T Function(JsonMap m) create) =>
      (this[key] as List? ?? []).map((e) => create(e)).toList();

  /// Converts a [JsonMap] into a list of [T] by the [create] function with an id defined by key.
  List<T> getMapToList<T>(String key, T Function(JsonMap m) create) =>
      (this[key] as JsonMap? ?? {})
          .mapEntries((e) => create(e.toMapWithId()))
          .toList();
}
