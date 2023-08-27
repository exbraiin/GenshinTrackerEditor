import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'src/gs_achievement_ext.dart';
export 'src/gs_achievement_group_ext.dart';
export 'src/gs_artifact_ext.dart';
export 'src/gs_banner_ext.dart';
export 'src/gs_character_ext.dart';
export 'src/gs_character_info_ext.dart';
export 'src/gs_character_outfit_ext.dart';
export 'src/gs_city_ext.dart';
export 'src/gs_material_ext.dart';
export 'src/gs_namecard_ext.dart';
export 'src/gs_recipe_ext.dart';
export 'src/gs_remarkable_chest_ext.dart';
export 'src/gs_serenitea_ext.dart';
export 'src/gs_spincrystal_ext.dart';
export 'src/gs_version_ext.dart';
export 'src/gs_viewpoint_ext.dart';
export 'src/gs_weapon_ext.dart';
export 'src/gs_weapon_info_ext.dart';

// The validator level.
enum GsValidLevel {
  none,
  good,
  warn1(color: Colors.lightBlue),
  warn2(color: Colors.orange, label: 'Missing'),
  error(color: Colors.red, label: 'Invalid');

  final Color? color;
  final String? label;

  bool get isErrorOrWarn2 =>
      this == GsValidLevel.error || this == GsValidLevel.warn2;

  const GsValidLevel({this.color, this.label});
}

class DataValidator {
  static final i = DataValidator._();

  final _levels = <Type, Map<String, GsValidLevel>>{};

  DataValidator._();

  Future<void> checkAll() async {
    final db = Database.i;

    Future<void> process<T extends GsModel<T>>(List<T> models) {
      final validator = GsModelExt.of<T>()!.getValidator();
      final data = _ComputeData(models, validator);
      return compute(_validateModels<T>, data)
          .then((value) => _levels[T] = value);
    }

    await Future.wait([
      process(db.achievementGroups.data),
      process(db.achievements.data),
      process(db.artifacts.data),
      process(db.banners.data),
      process(db.characters.data),
      process(db.characterInfo.data),
      process(db.characterOutfit.data),
      process(db.cities.data),
      process(db.materials.data),
      process(db.namecards.data),
      process(db.recipes.data),
      process(db.remarkableChests.data),
      process(db.sereniteas.data),
      process(db.spincrystal.data),
      process(db.versions.data),
      process(db.viewpoints.data),
      process(db.weapons.data),
      process(db.weaponInfo.data),
    ]);
  }

  /// Gets the level for the given [id].
  GsValidLevel getLevel<T extends GsModel<T>>(String id) =>
      _levels[T]?[id] ?? GsValidLevel.good;

  /// Gets the max level for this type.
  GsValidLevel getMaxLevel<T extends GsModel<T>>() {
    return _levels[T]?.values.maxBy((e) => e.index) ?? GsValidLevel.good;
  }

  GsValidLevel checkLevel<T extends GsModel<T>>(String id, T? model) {
    final validator = GsModelExt.of<T>()!.getValidator();
    if (model == null) {
      _levels[T]?.remove(id);
    } else {
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

class _ComputeData<T extends GsModel<T>> {
  final List<T> models;
  final GsValidator<T> validator;
  _ComputeData(this.models, this.validator);
}

class GsValidator<T extends GsModel<T>> {
  final Iterable<GsValidLevel Function(T item)> _validators;

  GsValidator(this._validators);
  GsValidator.empty() : _validators = const {};

  GsValidLevel validate(T item) {
    return _validators
            .map((e) => e.call(item))
            .maxBy((element) => element.index) ??
        GsValidLevel.good;
  }
}
