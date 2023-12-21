import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gsdatabase/src/exporter.dart';
import 'package:rxdart/rxdart.dart';

List<Items> get _infoCollections {
  return [
    Items<GsAchievement>('achievements', GsAchievement.fromJson),
    Items<GsAchievementGroup>(
        'achievement_categories', GsAchievementGroup.fromJson),
    Items<GsArtifact>('artifacts', GsArtifact.fromJson),
    Items<GsBanner>('banners', GsBanner.fromJson),
    Items<GsCharacter>('characters', GsCharacter.fromJson),
    Items<GsCharacterInfo>('characters_info', GsCharacterInfo.fromJson),
    Items<GsCharacterSkin>('characters_outfits', GsCharacterSkin.fromJson),
    Items<GsEvent>('events', GsEvent.fromJson),
    Items<GsEnemy>('enemies', GsEnemy.fromJson),
    Items<GsRegion>('cities', GsRegion.fromJson),
    Items<GsMaterial>('materials', GsMaterial.fromJson),
    Items<GsNamecard>('namecards', GsNamecard.fromJson),
    Items<GsRecipe>('recipes', GsRecipe.fromJson),
    Items<GsFurnitureChest>('remarkable_chests', GsFurnitureChest.fromJson),
    Items<GsSereniteaSet>('serenitea_sets', GsSereniteaSet.fromJson),
    Items<GsSpincrystal>('spincrystals', GsSpincrystal.fromJson),
    Items<GsVersion>('versions', GsVersion.fromJson),
    Items<GsViewpoint>('viewpoints', GsViewpoint.fromJson),
    Items<GsWeapon>('weapons', GsWeapon.fromJson),
    Items<GsWeaponInfo>('weapons_info', GsWeaponInfo.fromJson),
  ];
}

List<Items> get _saveCollections {
  return [
    Items<GiAchievement>('achievements', GiAchievement.fromJson),
    Items<GiWish>('wishes', GiWish.fromJson),
    Items<GiRecipe>('recipes', GiRecipe.fromJson),
    Items<GiFurnitureChest>('remarkable_chests', GiFurnitureChest.fromJson),
    Items<GiCharacter>('characters', GiCharacter.fromJson),
    Items<GiReputation>('reputation', GiReputation.fromJson),
    Items<GiSereniteaSet>('serenitea_sets', GiSereniteaSet.fromJson),
    Items<GiSpincrystal>('spincrystals', GiSpincrystal.fromJson),
    Items<GiPlayerInfo>('user_configs', GiPlayerInfo.fromJson),
  ];
}

JsonMap _preProcessSave(JsonMap json) {
  json['artifacts'] = (json['artifacts'] as JsonMap).map((key, value) {
    final pieces = (value as JsonMap)['pieces'] as JsonMap?;
    if (pieces == null) return MapEntry(key, value);
    value['list_pieces'] = pieces.entries
        .map((e) => <String, dynamic>{'id': e.key, ...e.value})
        .toList();
    return MapEntry(key, value);
  });

  json['recipes'] = (json['recipes'] as JsonMap).map((key, value) {
    final ingredients = (value as JsonMap)['ingredients'] as JsonMap?;
    if (ingredients == null) return MapEntry(key, value);
    value['list_ingredients'] = ingredients.entries
        .map((e) => <String, dynamic>{'id': e.key, 'amount': e.value})
        .toList();
    return MapEntry(key, value);
  });

  const key = 'characters_info';
  json[key] = (json[key] as JsonMap).map((key, value) {
    value['talents'] = (value['talents'] as List)
        .cast<JsonMap>()
        .map((e) => <String, dynamic>{'id': e['type'], ...e})
        .toList();

    value['constellations'] = (value['constellations'] as List)
        .cast<JsonMap>()
        .map((e) => <String, dynamic>{'id': e['type'], ...e})
        .toList();

    return MapEntry(key, value);
  });

  return json;
}

final class GsDatabase {
  final String loadJson;
  final bool allowWrite;
  final List<Items> collections;
  final JsonMap Function(JsonMap map)? _preProcess;
  final _notifier = PublishSubject<void>();
  Stream<void> get didUpdate => _notifier;

  GsDatabase.info({
    required this.loadJson,
    this.allowWrite = false,
  })  : _preProcess = _preProcessSave,
        collections = _infoCollections;

  GsDatabase.save({
    required this.loadJson,
    this.allowWrite = false,
  })  : _preProcess = null,
        collections = _saveCollections;

  Items<T> of<T extends GsModel<T>>() =>
      collections.firstWhere((e) => e is Items<T>) as Items<T>;

  Future<void> load() async {
    final file = File(loadJson);
    final JsonMap map = await file.exists()
        ? await file.readAsString().then((value) => jsonDecode(value))
        : {};
    await Future.value(map)
        .then((value) => _preProcess?.call(value) ?? value)
        .then((value) => collections.map((e) => e._load(value, this)))
        .then((value) => Future.wait(value));
  }

  Future<void> save() async {
    if (!allowWrite) return;
    final map = <String, dynamic>{};
    await Future.wait(collections.map((e) => e._save(map)));
    await File(loadJson).writeAsString(jsonEncode(map));
  }
}

final class Items<T extends GsModel<T>> {
  GsDatabase? _db;
  final _data = <String, T>{};
  final String collectionId;
  final T Function(JsonMap map) parser;

  Iterable<String> get ids => _data.keys;
  Iterable<T> get items => _data.values;

  Items(this.collectionId, this.parser);

  T? getItem(String id) => _data[id];
  bool exists(String id) => _data.containsKey(id);

  void setItem(T item) {
    _data[item.id] = item;
    _db?._notifier.add(null);
  }

  void removeItem(String id) {
    _data.remove(id);
    _db?._notifier.add(null);
  }

  Future<void> _load(JsonMap map, GsDatabase db) async {
    _db = db;
    final items = (map[collectionId] as JsonMap? ?? {})
        .map((k, v) => MapEntry(k, parser({'id': k, ...v})));
    _data.addAll(items);
  }

  Future<void> _save(JsonMap map) async {
    final items = _data.map((k, v) => MapEntry(k, v.toMap()..remove('id')));
    map[collectionId] = items;
  }
}
