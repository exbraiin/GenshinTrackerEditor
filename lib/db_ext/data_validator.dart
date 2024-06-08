import 'package:dartx/dartx.dart';
import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

export 'src/gs_achievement_ext.dart';
export 'src/gs_achievement_group_ext.dart';
export 'src/gs_artifact_ext.dart';
export 'src/gs_banner_ext.dart';
export 'src/gs_battlepass_ext.dart';
export 'src/gs_character_ext.dart';
export 'src/gs_character_outfit_ext.dart';
export 'src/gs_city_ext.dart';
export 'src/gs_enemy_ext.dart';
export 'src/gs_event_ext.dart';
export 'src/gs_furnishing_ext.dart';
export 'src/gs_material_ext.dart';
export 'src/gs_namecard_ext.dart';
export 'src/gs_recipe_ext.dart';
export 'src/gs_remarkable_chest_ext.dart';
export 'src/gs_serenitea_ext.dart';
export 'src/gs_spincrystal_ext.dart';
export 'src/gs_version_ext.dart';
export 'src/gs_viewpoint_ext.dart';
export 'src/gs_weapon_ext.dart';

// The validator level.
enum GsValidLevel {
  none,
  good,
  warn1(color: Colors.lightBlue),
  warn2(color: Colors.orange, label: 'Missing'),
  warn3(color: Colors.deepOrange, label: 'Wrong'),
  error(color: Colors.red, label: 'Invalid');

  final Color? color;
  final String? label;

  bool get isInvalid =>
      this == GsValidLevel.warn2 ||
      this == GsValidLevel.warn3 ||
      this == GsValidLevel.error;

  const GsValidLevel({this.color, this.label});
}

class DataValidator {
  static final i = DataValidator._();

  final _levels = <Type, Map<String, GsValidLevel>>{};

  DataValidator._();

  Future<void> checkItems<T extends GsModel<T>>() {
    final models = Database.i.of<T>().items.toList();
    final validator = _getValidator<T>();
    final data = _ComputeData(models.toList(), validator);
    return compute(_validateModels<T>, data)
        .then((value) => _levels[T] = value);
  }

  Future<void> checkAll() async {
    await Future.wait([
      checkItems<GsAchievementGroup>(),
      checkItems<GsAchievement>(),
      checkItems<GsArtifact>(),
      checkItems<GsBanner>(),
      checkItems<GsCharacter>(),
      checkItems<GsCharacterSkin>(),
      checkItems<GsRegion>(),
      checkItems<GsEnemy>(),
      checkItems<GsMaterial>(),
      checkItems<GsNamecard>(),
      checkItems<GsRecipe>(),
      checkItems<GsFurnitureChest>(),
      checkItems<GsSereniteaSet>(),
      checkItems<GsFurnishing>(),
      checkItems<GsSpincrystal>(),
      checkItems<GsVersion>(),
      checkItems<GsViewpoint>(),
      checkItems<GsEvent>(),
      checkItems<GsBattlepass>(),
      checkItems<GsWeapon>(),
    ]);
  }

  /// Gets the level for the given [id].
  GsValidLevel getLevel<T extends GsModel<T>>(String id) =>
      _levels[T]?[id] ?? GsValidLevel.good;

  /// Gets the max level for this type.
  GsValidLevel getMaxLevel<T extends GsModel<T>>() {
    return _levels[T]?.values.maxBy((e) => e.index) ?? GsValidLevel.good;
  }

  /// Checks the level for the given [id].
  /// * If [model] is null, it is removed from the levels list.
  /// * Otherwise it updates its level value and returns it.
  GsValidLevel checkLevel<T extends GsModel<T>>(String id, T? model) {
    if (model == null) {
      _levels[T]?.remove(id);
    } else {
      final validator = _getValidator<T>();
      (_levels[T] ??= {})[model.id] = validator.validate(model);
    }
    return getLevel<T>(id);
  }
}

Map<String, GsValidLevel> _validateModels<T extends GsModel<T>>(
  _ComputeData<T> data,
) {
  final valid = <String, GsValidLevel>{};
  for (final item in data.models) {
    valid[item.id] = data.validator.validate(item);
  }
  return valid;
}

_GsValidator<T> _getValidator<T extends GsModel<T>>() {
  // We send an empty id so the "validate id" method can reassign the id.
  final fields = GsConfigs.of<T>()?.pageBuilder.getFields('') ?? [];
  return _GsValidator(fields.map((e) => e.validator));
}

class _ComputeData<T extends GsModel<T>> {
  final Iterable<T> models;
  final _GsValidator validator;

  _ComputeData(this.models, this.validator);
}

class _GsValidator<T extends GsModel<T>> {
  final Iterable<DValidator<T>> _validators;

  _GsValidator(this._validators);

  GsValidLevel validate(T item) {
    return _validators
            .map((e) => e.call(item))
            .maxBy((element) => element.index) ??
        GsValidLevel.good;
  }
}
