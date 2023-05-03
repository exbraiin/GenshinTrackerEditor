import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/gs_artifact.dart';
import 'package:data_editor/db/gs_banner.dart';
import 'package:data_editor/db/gs_character.dart';
import 'package:data_editor/db/gs_character_info.dart';
import 'package:data_editor/db/gs_character_outfit.dart';
import 'package:data_editor/db/gs_city.dart';
import 'package:data_editor/db/gs_ingredient.dart';
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
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

export 'package:data_editor/db/gs_artifact.dart';
export 'package:data_editor/db/gs_banner.dart';
export 'package:data_editor/db/gs_character.dart';
export 'package:data_editor/db/gs_character_info.dart';
export 'package:data_editor/db/gs_character_outfit.dart';
export 'package:data_editor/db/gs_city.dart';
export 'package:data_editor/db/gs_ingredient.dart';
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
    Database.i.cities._data.indexWhere((e) => e.id == id);

class Database {
  static final i = Database._();

  var _loaded = false;
  final modified = PublishSubject();
  final saving = BehaviorSubject<bool>.seeded(false);

  final artifacts = GsCollection(
    'src/artifacts.json',
    GsArtifact.fromMap,
    validator: DataValidator.artifacts,
    sorted: (list) => list
        .sortedByDescending((element) => element.rarity)
        .thenBy((element) => _getCityIndex(element.region))
        .thenBy((element) => element.domain)
        .thenBy((element) => element.id),
  );
  final banners = GsCollection(
    'src/banners.json',
    GsBanner.fromMap,
    validator: DataValidator.banners,
    sorted: (list) => list
        .sortedBy((e) => GsConfigurations.bannerTypes.indexOf(e.type))
        .thenBy((e) => DateTime.tryParse(e.dateStart) ?? DateTime(0))
        .thenBy((element) => element.id),
  );
  final characters = GsCollection(
    'src/characters.json',
    GsCharacter.fromMap,
    validator: DataValidator.characters,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final characterInfo = GsCollection(
    'src/characters_info.json',
    GsCharacterInfo.fromMap,
    validator: DataValidator.charactersInfo,
    sorted: (list) {
      final characters = Database.i.characters.data;
      return list.sortedBy((e) => characters.indexWhere((c) => c.id == e.id));
    },
  );
  final characterOutfit = GsCollection(
    'src/characters_outfits.json',
    GsCharacterOutfit.fromMap,
    validator: DataValidator.charactersOutfit,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.name),
  );
  final cities = GsCollection(
    'src/cities.json',
    GsCity.fromMap,
    validator: DataValidator.cities,
    sorted: (list) => list
        .sortedBy((e) => GsConfigurations.elements.indexOf(e.element))
        .thenBy((element) => element.id),
  );
  final ingredients = GsCollection(
    'src/ingredients.json',
    GsIngredient.fromMap,
    validator: DataValidator.ingredients,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final materials = GsCollection(
    'src/materials.json',
    GsMaterial.fromMap,
    validator: DataValidator.materials,
    sorted: (list) => list
        .sortedBy((element) => element.group)
        .thenBy((element) => _getCityIndex(element.region))
        .thenBy((element) => element.subgroup)
        .thenBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final namecards = GsCollection(
    'src/namecards.json',
    GsNamecard.fromMap,
    validator: DataValidator.namecards,
    sorted: (list) => list
        .sortedBy((e) => GsConfigurations.namecardTypes.indexOf(e.type))
        .thenBy((element) => element.id),
  );
  final recipes = GsCollection(
    'src/recipes.json',
    GsRecipe.fromMap,
    validator: DataValidator.recipes,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final remarkableChests = GsCollection(
    'src/remarkable_chests.json',
    GsRemarkableChest.fromMap,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.type)
        .thenBy((element) => element.category)
        .thenBy((element) => element.name),
    validator: DataValidator.remarkableChests,
  );
  final sereniteas = GsCollection(
    'src/serenitea_sets.json',
    GsSerenitea.fromMap,
    validator: DataValidator.sereniteas,
    sorted: (list) => list
        .sortedBy((e) => GsConfigurations.sereniteaType.indexOf(e.category))
        .thenBy((element) => element.id),
  );
  final spincrystal = GsCollection(
    'src/spincrystals.json',
    GsSpincrystal.fromMap,
    validator: DataValidator.spincrystals,
    sorted: (list) => list.sortedBy((element) => element.number),
  );
  final versions = GsCollection(
    'src/versions.json',
    GsVersion.fromMap,
    validator: DataValidator.versions,
    sorted: (list) => list.sortedBy((element) => element.id),
  );
  final viewpoints = GsCollection(
    'src/viewpoints.json',
    GsViewpoint.fromMap,
    validator: DataValidator.viewpoints,
    sorted: (list) => list
        .sortedBy((element) => element.region)
        .thenBy((element) => element.version)
        .thenBy((element) => element.name),
  );
  final weapons = GsCollection(
    'src/weapons.json',
    GsWeapon.fromMap,
    validator: DataValidator.weapons,
    sorted: (list) => list
        .sortedBy((element) => element.rarity)
        .thenBy((element) => element.id),
  );
  final weaponInfo = GsCollection(
    'src/weapons_info.json',
    GsWeaponInfo.fromMap,
    validator: DataValidator.weaponsInfo,
    sorted: (list) {
      final weapons = Database.i.weapons.data;
      return list.sortedBy((w) => weapons.indexWhere((e) => e.id == w.id));
    },
  );

  List<GsCollection> get collections => [
        artifacts,
        banners,
        characters,
        characterInfo,
        characterOutfit,
        cities,
        ingredients,
        materials,
        namecards,
        recipes,
        remarkableChests,
        sereniteas,
        spincrystal,
        versions,
        viewpoints,
        weapons,
        weaponInfo,
      ];

  Database._();

  void _updateAllDataValidators() {
    for (var collection in collections) {
      final validator = collection.validator;
      for (var item in collection._data) {
        validator.checkLevel(item.id, item);
      }
    }
  }

  Future<bool> load() async {
    if (_loaded) return _loaded;
    _loaded = true;
    await GsConfigurations.load();
    await Future.wait(collections.map((e) => e.load()));
    _updateAllDataValidators();
    modified.add(null);
    return _loaded;
  }

  Future<void> save() async {
    if (!_loaded) return;
    if (saving.value) return;
    saving.add(true);
    await Future.wait(collections.map((e) => e.save()));
    await _combine('src', 'data.json');
    // if (Platform.isWindows) await Process.run('explorer', ['.']);
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

enum ItemState {
  none,
  current(color: Colors.green, label: 'New'),
  upcoming(color: Colors.lightBlue, label: 'Upcoming');

  final Color? color;
  final String? label;

  const ItemState({this.color, this.label});
}

extension DatabaseExt on Database {
  Iterable<GsMaterial> getMaterialGroup(String group) {
    final matGroup = materials.data.where((e) => e.group == group);
    return matGroup.groupBy((m) => m.subgroup).values.expand((l) {
      final rarity = l.minBy((m) => m.rarity)?.rarity ?? 1;
      return l.where((m) => m.rarity == rarity);
    });
  }

  Iterable<GsMaterial> getMaterialGroups(List<String> groups) {
    return groups.map(getMaterialGroup).expand((list) => list);
  }

  GsCity getMaterialRegion(GsMaterial material) {
    return cities.data.firstOrNullWhere((m) => material.region == m.id) ??
        GsCity(id: 'none', name: 'None');
  }

  int getWishRarity(String id) {
    return characters.getItem(id)?.rarity ?? weapons.getItem(id)?.rarity ?? 0;
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

  Set<String> getVersions() {
    return versions.data.map((e) => e.id).toSet();
  }

  List<GsRecipe> getAllNonBaseRecipes() {
    return recipes.data.where((e) => e.baseRecipe.isEmpty).toList()
      ..insert(0, GsRecipe.fromMap({'id': '', 'name': 'None'}));
  }

  List<GsRecipe> getAllBaseRecipes() {
    return recipes.data.where((e) => e.baseRecipe.isNotEmpty).toList()
      ..insert(0, GsRecipe.fromMap({'id': 'none', 'name': 'None'}));
  }

  List<GsCity> getRegions() {
    return cities.data.toList()..insert(0, GsCity(id: '', name: 'None'));
  }

  List<GsWish> getAllWishes([int? rarity, String? type]) {
    return [
      if (type == null || type == 'weapon')
        ...weapons.data
            .where((e) => e.rarity == rarity || rarity == null)
            .map(GsWish.fromWeapon),
      if (type == null || type == 'character')
        ...characters.data
            .where((e) => e.rarity == rarity || rarity == null)
            .map(GsWish.fromCharacter),
    ];
  }
}

class GsCollection<T extends GsModel<T>> {
  final String src;
  final T Function(JsonMap m) create;
  final List<T> Function(List<T> list)? sorted;
  final _data = <T>[];
  List<T> get data => sorted?.call(_data) ?? _data.toList();

  final DataValidator<T> validator;

  String get type => (T == GsArtifact).toString();

  GsCollection(
    this.src,
    this.create, {
    this.sorted,
    required this.validator,
  });

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
    if (id != null) validator.checkLevel(id, null);
    validator.checkLevel(item.id, item);
    Database.i.modified.add(null);
  }

  void delete(String? id) {
    if (id == null) return;
    _data.removeWhere((element) => element.id == id);
    validator.checkLevel(id, null);
    Database.i.modified.add(null);
  }
}

abstract class GsModel<T extends GsModel<T>> {
  String get id;
  JsonMap toJsonMap();
  T copyWith();
}

extension JsonMapExt on JsonMap {
  /// Gets an [int] by [key] or [defaultValue].
  int getInt(String key, [int defaultValue = 0]) =>
      this[key] as int? ?? defaultValue;

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

  /// Converts a [JsonMap] into a list of [T] by the [create] function with an id defined by key.
  List<T> getMapToList<T>(String key, T Function(JsonMap m) create) =>
      (this[key] as JsonMap? ?? {})
          .mapEntries((e) => create(e.toMapWithId()))
          .toList();
}
