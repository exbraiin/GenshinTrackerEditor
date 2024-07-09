import 'dart:async';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/model_ext.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:rxdart/rxdart.dart';

const _kFilePath = 'gsdata';
const _kFilePathEncoded = 'gsdatab';

final class Database {
  static final i = Database._();

  var _loaded = false;
  final _db = GsDatabase.info(allowWrite: true);

  final modified = PublishSubject<void>();
  Database._();

  Items<T> of<T extends GsModel<T>>() => _db.of<T>();

  Future<bool> load() async {
    if (_loaded) return _loaded;
    _loaded = true;
    if (kDebugMode) await File('Release/gsdata').copy(_kFilePath);
    await _db.load(loadJson: _kFilePath);
    await DataValidator.i.checkAll();
    modified.add(null);
    return _loaded;
  }

  Future<void> save() async {
    await _processAchGroups()
        .then(Database.i.of<GsAchievementGroup>().updateAll);
    await _db.save(loadJson: _kFilePath);
    await _db.save(loadJson: _kFilePathEncoded, encoded: true);
  }

  Iterable<GsMaterial> getMaterialGroups(
    GeMaterialType type, [
    GeMaterialType? type1,
  ]) {
    return of<GsMaterial>()
        .items
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
    final versions = of<GsVersion>().items.sortedBy((e) => e.releaseDate);
    final current =
        versions.lastOrNullWhere((e) => e.releaseDate.isBefore(now));
    if (current != null && current.id == version) return ItemState.current;

    final vs = versions.firstOrNullWhere((e) => e.id == version);
    if (vs != null && vs.releaseDate.isAfter(now)) return ItemState.upcoming;

    return ItemState.none;
  }

  List<GsWish> getAllWishes([int? rarity, GeBannerType? type]) {
    return [
      if (type == null ||
          type == GeBannerType.weapon ||
          type == GeBannerType.chronicled)
        ...of<GsWeapon>()
            .items
            .where((e) => e.rarity == rarity || rarity == null)
            .map(GsWish.fromWeapon),
      if (type == null ||
          type == GeBannerType.character ||
          type == GeBannerType.chronicled)
        ...of<GsCharacter>()
            .items
            .where((e) => e.rarity == rarity || rarity == null)
            .map(GsWish.fromCharacter),
    ];
  }
}

extension ItemsExt<T extends GsModel<T>> on Items<T> {
  void updateItem(T item) {
    setItem(item);
    DataValidator.i.checkLevel<T>(item.id, item);
    Database.i.modified.add(null);
  }

  void updateAll(Iterable<T> items) {
    items.forEach(setItem);
    DataValidator.i.checkItems<T>();
    Database.i.modified.add(null);
  }

  void delete(String? id) {
    if (id == null) return;
    removeItem(id);
    DataValidator.i.checkLevel<T>(id, null);
    Database.i.modified.add(null);
  }

  void deleteAll(Iterable<String> ids) {
    ids.forEach(removeItem);
    DataValidator.i.checkItems<T>();
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
      groups: Database.i.of<GsAchievementGroup>().items,
      achievements: Database.i.of<GsAchievement>().items,
    ),
  );
}
