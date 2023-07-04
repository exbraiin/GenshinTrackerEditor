import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/gs_achievement_ext.dart';
import 'package:data_editor/db_ext/src/gs_achievement_group_ext.dart';
import 'package:data_editor/db_ext/src/gs_artifact_ext.dart';
import 'package:data_editor/db_ext/src/gs_banner_ext.dart';
import 'package:data_editor/db_ext/src/gs_character_ext.dart';
import 'package:data_editor/db_ext/src/gs_character_info_ext.dart';
import 'package:data_editor/db_ext/src/gs_character_outfit_ext.dart';
import 'package:data_editor/db_ext/src/gs_city_ext.dart';
import 'package:data_editor/db_ext/src/gs_ingredient_ext.dart';
import 'package:data_editor/db_ext/src/gs_material_ext.dart';
import 'package:data_editor/db_ext/src/gs_namecard_ext.dart';
import 'package:data_editor/db_ext/src/gs_recipe_ext.dart';
import 'package:data_editor/db_ext/src/gs_remarkable_chest_ext.dart';
import 'package:data_editor/db_ext/src/gs_serenitea_ext.dart';
import 'package:data_editor/db_ext/src/gs_spincrystal_ext.dart';
import 'package:data_editor/db_ext/src/gs_version_ext.dart';
import 'package:data_editor/db_ext/src/gs_viewpoint_ext.dart';
import 'package:data_editor/db_ext/src/gs_weapon_ext.dart';
import 'package:data_editor/db_ext/src/gs_weapon_info_ext.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'src/gs_artifact_ext.dart';
export 'src/gs_banner_ext.dart';
export 'src/gs_character_ext.dart';
export 'src/gs_character_info_ext.dart';
export 'src/gs_character_outfit_ext.dart';
export 'src/gs_city_ext.dart';
export 'src/gs_ingredient_ext.dart';
export 'src/gs_material_ext.dart';
export 'src/gs_namecard_ext.dart';
export 'src/gs_recipe_ext.dart';
export 'src/gs_serenitea_ext.dart';
export 'src/gs_spincrystal_ext.dart';
export 'src/gs_version_ext.dart';
export 'src/gs_viewpoint_ext.dart';
export 'src/gs_weapon_ext.dart';

class DataFields<T extends GsModel<T>> {
  static final achievements = DataFields._(getAchievementsDfs);
  static final achievementGroups = DataFields._(getAchievementGroupsDfs);
  static final artifacts = DataFields._(getArtifactDfs);
  static final banners = DataFields._(getBannerDfs);
  static final characters = DataFields._(getCharacterDfs);
  static final charactersInfo = DataFields._(getCharacterInfoDfs);
  static final charactersOutfit = DataFields._(getCharacterOutfitDfs);
  static final cities = DataFields._(getCityDfs);
  static final ingredients = DataFields._(getIngredientDfs);
  static final materials = DataFields._(getMaterialDfs);
  static final namecards = DataFields._(getNamecardDfs);
  static final recipes = DataFields._(getRecipeDfs);
  static final remarkableChests = DataFields._(getRemarkableChestDfs);
  static final sereniteas = DataFields._(getSereniteaDfs);
  static final spincrystals = DataFields._(getSpincrystalDfs);
  static final versions = DataFields._(getVersionDfs);
  static final viewpoints = DataFields._(getViewpointtDfs);
  static final weapons = DataFields._(getWeaponDfs);
  static final weaponsInfo = DataFields._(getWeaponInfoDfs);

  final List<DataField<T>> Function(T? item) getDataFields;

  DataFields._(this.getDataFields);
}

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
      final data = _ComputeData(models, _getValidator<T>());
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
      process(db.ingredients.data),
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
    final validator = _getValidator<T>();
    if (model == null) {
      _levels[T]?.remove(id);
    } else {
      (_levels[T] ??= {})[model.id] = validator.validateAll(model);
    }
    return getLevel<T>(id);
  }

  GsValidator<T> getValidator<T extends GsModel<T>>() {
    return _getValidator<T>();
  }
}

Map<String, GsValidLevel> _validateModels<T extends GsModel<T>>(
  _ComputeData<T> data,
) {
  final valid = <String, GsValidLevel>{};
  for (final item in data.models) {
    valid[item.id] = data.validator.validateAll(item);
  }
  return valid;
}

class _ComputeData<T extends GsModel<T>> {
  final List<T> models;
  final GsValidator<T> validator;
  _ComputeData(this.models, this.validator);
}

class GsValidator<T extends GsModel<T>> {
  final Map<String, GsValidLevel Function(T item, T? other)> _map;
  GsValidator(this._map);

  GsValidLevel validateEntry(String id, T item, T? other) {
    assert(_map[id] != null, 'Entry for $id does not exist for $T.');
    return _map[id]!.call(item, other);
  }

  GsValidLevel validateAll(T item, {Type? debug}) {
    if (kDebugMode) {
      if (T == debug) {
        print('\n${item.id}');
        for (final entry in _map.entries) {
          print('${entry.key}: ${entry.value(item, item)}');
        }
      }
    }
    return _map.values
            .map((e) => e.call(item, item))
            .maxBy((element) => element.index) ??
        GsValidLevel.good;
  }
}

GsValidator<T> _getValidator<T extends GsModel<T>>() {
  GsValidLevel validateId<E extends GsModel<E>>(
    E item,
    E? inDb,
    Iterable<String> ids,
  ) {
    final id = item.id;
    final expectedId = _expectedId(item);
    if (id.isEmpty) return GsValidLevel.error;
    final check = id != expectedId ? GsValidLevel.warn1 : GsValidLevel.good;
    final withoutSelf = ids.where((e) => e != inDb?.id);
    return !withoutSelf.contains(id) ? check : GsValidLevel.error;
  }

  GsValidLevel validateNum(num value, [num min = 0]) =>
      value >= min ? GsValidLevel.good : GsValidLevel.error;

  GsValidLevel validateText(
    String name, [
    GsValidLevel empty = GsValidLevel.warn1,
  ]) {
    if (name.isEmpty) return empty;
    if (name.trim() != name) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  GsValidLevel validateRarity(int rarity, [int min = 1]) {
    return rarity.between(min, 5) ? GsValidLevel.good : GsValidLevel.error;
  }

  GsValidLevel validateImage(
    String image, [
    GsValidLevel empty = GsValidLevel.warn2,
  ]) {
    if (image.isEmpty) return empty;
    if (image.trim() != image) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  GsValidLevel validateBday(String birthday) {
    final date = DateTime.tryParse(birthday);
    return date != null && date.year == 0
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel validateDate(String date) {
    if (date.isEmpty) return GsValidLevel.warn2;
    return DateTime.tryParse(date) == null
        ? GsValidLevel.error
        : GsValidLevel.none;
  }

  GsValidLevel validateDates(String start, String end) {
    final src = DateTime.tryParse(start);
    final dst = DateTime.tryParse(end);
    return src != null && dst != null && dst.isAfter(src)
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel validateCharAsc(String value) {
    if (value.isEmpty) return GsValidLevel.warn1;
    if (value.split(',').length != 8) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  GsValidLevel validateWeaponAsc(String atkValues, String statValues) {
    final atk = atkValues.split(',').where((e) => e.isNotEmpty);
    final stat = statValues.split(',').where((e) => e.isNotEmpty);
    return (atk.isNotEmpty && stat.isEmpty) || atk.length == stat.length
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel validateContains(String value, Iterable<String> values) {
    return values.contains(value) ? GsValidLevel.good : GsValidLevel.error;
  }

  GsValidLevel validateContainsAll(
    List<String> value,
    Iterable<String> values,
  ) {
    return values.all((e) => values.contains(e))
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel validateAll<E extends GsModel<E>>(
    GsValidator<E> validator,
    List<E> list,
  ) {
    return list.map(validator.validateAll).maxBy((e) => e.index) ??
        GsValidLevel.good;
  }

  final versions = GsItemFilter.versions().ids;

  if (T == GsAchievementGroup) {
    final ids = Database.i.achievementGroups.data.map((e) => e.id);
    final namecards = GsItemFilter.achievementNamecards().ids;
    return GsValidator<GsAchievementGroup>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'icon': (item, other) => validateImage(item.icon),
      'version': (item, other) => validateContains(item.version, versions),
      'namecard': (item, other) => validateContains(item.namecard, namecards),
    }) as GsValidator<T>;
  }

  if (T == GsAchievement) {
    final ids = Database.i.achievements.data.map((e) => e.id);
    final types = GsItemFilter.achievementTypes().ids;
    final groups = GsItemFilter.achievementGroups().ids;
    return GsValidator<GsAchievement>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'desc': (item, other) => validateText(item.desc),
      'type': (item, other) => validateContains(item.type, types),
      'group': (item, other) => validateContains(item.group, groups),
      'hidden': (item, other) => GsValidLevel.good,
      'reward': (item, other) => validateNum(item.reward, 1),
      'version': (item, other) => validateContains(item.version, versions),
    }) as GsValidator<T>;
  }

  if (T == GsArtifact) {
    final ids = Database.i.artifacts.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
    final pcVal = _getValidator<GsArtifactPiece>();
    return GsValidator<GsArtifact>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'region': (item, other) => validateContains(item.region, regions),
      'version': (item, other) => validateContains(item.version, versions),
      'rarity': (item, other) => validateRarity(item.rarity),
      'domain': (item, other) => validateText(item.domain),
      '1pc': (item, other) => validateText(item.pc1),
      '2pc': (item, other) => validateText(item.pc2),
      '4pc': (item, other) => validateText(item.pc4),
      'pieces': (item, other) => validateAll(pcVal, item.pieces),
    }) as GsValidator<T>;
  }

  if (T == GsArtifactPiece) {
    return GsValidator<GsArtifactPiece>({
      'name': (item, other) => validateText(item.name),
      'icon': (item, other) => validateText(item.icon),
      'desc': (item, other) => validateText(item.desc),
    }) as GsValidator<T>;
  }

  if (T == GsBanner) {
    final ids = Database.i.banners.data.map((e) => e.id);
    final types = GsItemFilter.bannerTypes().ids;
    return GsValidator<GsBanner>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'image': (item, other) => validateImage(item.image),
      'date_start': (item, other) =>
          validateDates(item.dateStart, item.dateEnd),
      'date_end': (item, other) => validateDates(item.dateStart, item.dateEnd),
      'type': (item, other) => validateContains(item.type, types),
      'version': (item, other) => validateContains(item.version, versions),
      'feature_4': (item, other) {
        final validType = item.type != 'standard' && item.type != 'beginner';
        if (validType && item.feature4.isEmpty) return GsValidLevel.warn2;
        return GsValidLevel.good;
      },
      'feature_5': (item, other) {
        final validType = item.type != 'standard' && item.type != 'beginner';
        if (validType && item.feature5.isEmpty) return GsValidLevel.warn2;
        return GsValidLevel.good;
      },
    }) as GsValidator<T>;
  }

  if (T == GsCharacter) {
    final ids = Database.i.characters.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
    final weapons = GsItemFilter.weaponTypes().ids;
    final elements = GsItemFilter.elements().ids;
    final sources = GsItemFilter.itemSource().ids;
    final recipes = GsItemFilter.baseRecipes().ids;
    return GsValidator<GsCharacter>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'enka_id': (item, other) => validateText(item.enkaId, GsValidLevel.warn2),
      'rarity': (item, other) => validateRarity(item.rarity, 4),
      'title': (item, other) => validateText(item.title),
      'region': (item, other) => validateContains(item.region, regions),
      'weapon': (item, other) => validateContains(item.weapon, weapons),
      'element': (item, other) => validateContains(item.element, elements),
      'version': (item, other) => validateContains(item.version, versions),
      'source': (item, other) => validateContains(item.source, sources),
      'description': (item, other) => validateText(item.description),
      'constellation': (item, other) => validateText(item.constellation),
      'affiliation': (item, other) => validateText(item.affiliation),
      'special_dish': (item, other) =>
          validateContains(item.specialDish, recipes),
      'birthday': (item, other) => validateBday(item.birthday),
      'release_date': (item, other) => validateDate(item.releaseDate),
      'image': (item, other) => validateImage(item.image),
      'full_image': (item, other) => validateImage(item.fullImage),
      'constellation_image': (item, other) =>
          validateImage(item.constellationImage),
    }) as GsValidator<T>;
  }

  if (T == GsCharacterInfo) {
    final ascTypes = GsItemFilter.chrStatTypes().ids;
    final matGem = GsItemFilter.matGroupsWithRegion(GsItemFilter.matGems).ids;
    final matBss = GsItemFilter.matGroupsWithRegion(GsItemFilter.matBoss).ids;
    final matMob = GsItemFilter.matGroupsWithRarity(GsItemFilter.matDrops).ids;
    final matWeek = GsItemFilter.matGroupsWithRarity(GsItemFilter.matWeek).ids;
    final matWithRegion =
        Database.i.materials.data.map((e) => MapEntry(e.id, e.region)).toMap();
    final chrWithRegion =
        Database.i.characters.data.map((e) => MapEntry(e.id, e.region)).toMap();
    final talVal = _getValidator<GsCharTalent>();
    final conVal = _getValidator<GsCharConstellation>();

    return GsValidator<GsCharacterInfo>({
      'id': (item, other) =>
          item.id.isEmpty ? GsValidLevel.error : GsValidLevel.good,
      'mat_gem': (item, other) => validateContains(item.gemMaterial, matGem),
      'mat_boss': (item, other) => validateContains(item.bossMaterial, matBss),
      'mat_common': (item, other) =>
          validateContains(item.commonMaterial, matMob),
      'mat_region': (item, other) {
        if (item.regionMaterial.isEmpty) return GsValidLevel.error;
        final chrRegion = chrWithRegion[item.id];
        final matRegion = matWithRegion[item.regionMaterial];
        if (chrRegion == null || matRegion == null) return GsValidLevel.error;
        if (matRegion != chrRegion) return GsValidLevel.warn1;
        return GsValidLevel.good;
      },
      'mat_talent': (item, other) {
        if (item.talentMaterial.isEmpty) return GsValidLevel.error;
        final chrRegion = chrWithRegion[item.id];
        final matRegion = matWithRegion[item.talentMaterial];
        if (chrRegion == null || matRegion == null) return GsValidLevel.error;
        if (matRegion != chrRegion) return GsValidLevel.warn1;
        return GsValidLevel.good;
      },
      'mat_weekly': (item, other) =>
          validateContains(item.weeklyMaterial, matWeek),
      'asc_stat_type': (item, other) =>
          validateContains(item.ascStatType, ascTypes),
      'asc_hp_values': (item, other) => validateCharAsc(item.ascHpValues),
      'asc_atk_values': (item, other) => validateCharAsc(item.ascAtkValues),
      'asc_def_values': (item, other) => validateCharAsc(item.ascDefValues),
      'asc_stat_values': (item, other) => validateCharAsc(item.ascStatValues),
      'talents': (item, other) => validateAll(talVal, item.talents),
      'constellations': (item, other) =>
          validateAll(conVal, item.constellations),
    }) as GsValidator<T>;
  }

  if (T == GsCharTalent) {
    return GsValidator<GsCharTalent>({
      'name': (item, other) => validateText(
            item.name,
            item.type == 'Alternate Sprint'
                ? GsValidLevel.warn1
                : GsValidLevel.warn2,
          ),
      'type': (item, other) => validateText(
            item.type,
            item.type == 'Alternate Sprint'
                ? GsValidLevel.warn1
                : GsValidLevel.warn2,
          ),
      'icon': (item, other) => validateText(
            item.icon,
            item.type == 'Alternate Sprint'
                ? GsValidLevel.warn1
                : GsValidLevel.warn2,
          ),
      'desc': (item, other) => validateText(
            item.desc,
            item.type == 'Alternate Sprint'
                ? GsValidLevel.warn1
                : GsValidLevel.warn2,
          ),
    }) as GsValidator<T>;
  }

  if (T == GsCharConstellation) {
    return GsValidator<GsCharConstellation>({
      'name': (item, other) => validateText(item.name, GsValidLevel.warn2),
      'icon': (item, other) => validateText(item.icon, GsValidLevel.warn2),
      'desc': (item, other) => validateText(item.desc, GsValidLevel.warn2),
    }) as GsValidator<T>;
  }

  if (T == GsCharacterOutfit) {
    final ids = Database.i.characterOutfit.data.map((e) => e.id);
    final characters = Database.i.characterInfo.data.map((e) => e.id);
    return GsValidator<GsCharacterOutfit>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'image': (item, other) => validateImage(item.image),
      'rarity': (item, other) => validateRarity(item.rarity),
      'version': (item, other) => validateContains(item.version, versions),
      'character': (item, other) =>
          validateContains(item.character, characters),
      'full_image': (item, other) => validateImage(item.fullImage),
    }) as GsValidator<T>;
  }

  if (T == GsCity) {
    final ids = Database.i.cities.data.map((e) => e.id);
    final elements = GsItemFilter.elements().ids;
    return GsValidator<GsCity>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'image': (item, other) => validateImage(item.image),
      'element': (item, other) => validateContains(item.element, elements),
      'reputation': (item, other) =>
          item.reputation.isEmpty ? GsValidLevel.warn2 : GsValidLevel.good,
    }) as GsValidator<T>;
  }

  if (T == GsIngredient) {
    final ids = Database.i.ingredients.data.map((e) => e.id);
    return GsValidator<GsIngredient>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'desc': (item, other) => validateText(item.desc),
      'image': (item, other) => validateImage(item.image),
      'rarity': (item, other) => validateRarity(item.rarity),
      'version': (item, other) => validateContains(item.version, versions),
    }) as GsValidator<T>;
  }

  if (T == GsMaterial) {
    final ids = Database.i.materials.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
    final weekdays = GsItemFilter.weekdays().ids;
    final categories = GsItemFilter.matCategories().ids;
    return GsValidator<GsMaterial>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'desc': (item, other) => validateText(item.desc),
      'group': (item, other) => validateContains(item.group, categories),
      'image': (item, other) => validateText(item.image),
      'region': (item, other) => validateContains(item.region, regions),
      'rarity': (item, other) => validateRarity(item.rarity),
      'subgroup': (item, other) => validateNum(item.subgroup),
      'version': (item, other) => validateContains(item.version, versions),
      'weekdays': (item, other) => validateContainsAll(item.weekdays, weekdays),
    }) as GsValidator<T>;
  }

  if (T == GsNamecard) {
    final ids = Database.i.namecards.data.map((e) => e.id);
    final types = GsItemFilter.namecardTypes().ids;
    return GsValidator<GsNamecard>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'rarity': (item, other) => validateRarity(item.rarity),
      'version': (item, other) => validateContains(item.version, versions),
      'image': (item, other) => validateImage(item.image),
      'full_image': (item, other) => validateImage(item.fullImage),
      'desc': (item, other) => validateText(item.desc),
      'obtain': (item, other) => validateText(item.obtain),
      'type': (item, other) => validateContains(item.type, types),
    }) as GsValidator<T>;
  }

  if (T == GsRecipe) {
    final ids = Database.i.recipes.data.map((e) => e.id);
    final types = GsItemFilter.recipeType().ids;
    final effects = GsItemFilter.recipeEffects().ids;
    final baseRecipes = GsItemFilter.nonBaseRecipes().ids;
    return GsValidator<GsRecipe>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'type': (item, other) => validateContains(item.type, types),
      'version': (item, other) => validateContains(item.version, versions),
      'image': (item, other) => validateImage(item.image),
      'effect': (item, other) => validateContains(item.effect, effects),
      'rarity': (item, other) => validateRarity(item.rarity),
      'desc': (item, other) => validateText(item.desc),
      'effect_desc': (item, other) => validateText(item.effectDesc),
      'base_recipe': (item, other) =>
          validateContains(item.baseRecipe, baseRecipes),
    }) as GsValidator<T>;
  }

  if (T == GsAmount) {
    return GsValidator<GsAmount>({
      'id': (item, other) => GsValidLevel.good,
      'amount': (item, other) => validateNum(item.amount, 1),
    }) as GsValidator<T>;
  }

  if (T == GsRemarkableChest) {
    final ids = Database.i.remarkableChests.data.map((e) => e.id);
    final types = GsItemFilter.sereniteas().ids;
    final regions = GsItemFilter.regions().ids;
    final sources = GsItemFilter.rChestSource().ids;
    final categories = GsItemFilter.rChestCategory().ids;
    return GsValidator<GsRemarkableChest>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'type': (item, other) => validateContains(item.type, types),
      'image': (item, other) => validateImage(item.image),
      'rarity': (item, other) => validateRarity(item.rarity),
      'energy': (item, other) => validateNum(item.energy, 1),
      'region': (item, other) => validateContains(item.region, regions),
      'source': (item, other) => validateContains(item.source, sources),
      'version': (item, other) => validateContains(item.version, versions),
      'category': (item, other) => validateContains(item.category, categories),
    }) as GsValidator<T>;
  }

  if (T == GsSerenitea) {
    final ids = Database.i.sereniteas.data.map((e) => e.id);
    final categories = GsItemFilter.sereniteas().ids;
    final chars = GsItemFilter.wishes(null, GsItemFilter.wishChar).ids;
    return GsValidator<GsSerenitea>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'image': (item, other) => validateImage(item.image),
      'energy': (item, other) => validateNum(item.energy, 1),
      'category': (item, other) => validateContains(item.category, categories),
      'chars': (item, other) => item.chars.isEmpty
          ? GsValidLevel.warn2
          : (chars.containsAll(item.chars)
              ? GsValidLevel.good
              : GsValidLevel.error),
      'version': (item, other) => validateContains(item.version, versions),
    }) as GsValidator<T>;
  }

  if (T == GsSpincrystal) {
    final ids = Database.i.spincrystal.data.map((e) => e.id);
    final regions = Database.i.cities.data.map((e) => e.id);
    return GsValidator<GsSpincrystal>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'number': (item, other) => validateNum(item.number, 1),
      'source': (item, other) => validateText(item.source),
      'region': (item, other) => validateContains(item.region, regions),
      'version': (item, other) => validateContains(item.version, versions),
    }) as GsValidator<T>;
  }

  if (T == GsVersion) {
    final ids = Database.i.versions.data.map((e) => e.id);
    return GsValidator<GsVersion>({
      'id': (item, other) => validateId(item, other, ids),
      'release_date': (item, other) => validateDate(item.releaseDate),
      'name': (item, other) => validateText(item.name),
      'image': (item, other) => validateImage(item.image),
    }) as GsValidator<T>;
  }

  if (T == GsViewpoint) {
    final ids = Database.i.viewpoints.data.map((e) => e.id);
    final regions = Database.i.cities.data.map((e) => e.id);
    return GsValidator<GsViewpoint>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'desc': (item, other) => validateText(item.desc),
      'image': (item, other) => validateImage(item.image),
      'region': (item, other) => validateContains(item.region, regions),
      'version': (item, other) => validateContains(item.version, versions),
    }) as GsValidator<T>;
  }

  if (T == GsWeapon) {
    final ids = Database.i.weapons.data.map((e) => e.id);
    final types = GsItemFilter.weaponTypes().ids;
    final sources = GsItemFilter.itemSource().ids;
    final statTypes = GsItemFilter.statTypes().ids;
    return GsValidator<GsWeapon>({
      'id': (item, other) => validateId(item, other, ids),
      'name': (item, other) => validateText(item.name),
      'image': (item, other) => validateImage(item.image),
      'image_asc': (item, other) => validateImage(item.imageAsc),
      'version': (item, other) => validateContains(item.version, versions),
      'rarity': (item, other) => validateRarity(item.rarity),
      'type': (item, other) => validateContains(item.type, types),
      'atk': (item, other) => validateNum(item.atk, 1),
      'stat_type': (item, other) => validateContains(item.statType, statTypes),
      'stat_value': (item, other) {
        if (item.statType == 'none') {
          return item.statValue == 0 ? GsValidLevel.good : GsValidLevel.error;
        }
        return validateNum(item.statValue, 1);
      },
      'desc': (item, other) => validateText(item.desc),
      'source': (item, other) => validateContains(item.source, sources),
    }) as GsValidator<T>;
  }

  if (T == GsWeaponInfo) {
    final ids = GsItemFilter.weaponsWithoutInfo().ids;
    final matWeapon =
        GsItemFilter.matGroupsWithRegion(GsItemFilter.matWeapons).ids;
    final matCommon =
        GsItemFilter.matGroupsWithRarity(GsItemFilter.matNormal).ids;
    final matElite =
        GsItemFilter.matGroupsWithRarity(GsItemFilter.matElite).ids;
    final ascType = GsItemFilter.weaponStatTypes().ids;
    return GsValidator<GsWeaponInfo>({
      'id': (item, other) => validateContains(item.id, ids),
      'effect_name': (item, other) => validateText(item.effectName),
      'effect_desc': (item, other) => validateText(item.effectDesc),
      'mat_weapon': (item, other) =>
          validateContains(item.matWeapon, matWeapon),
      'mat_common': (item, other) =>
          validateContains(item.matCommon, matCommon),
      'mat_elite': (item, other) => validateContains(item.matElite, matElite),
      'asc_stat_type': (item, other) =>
          validateContains(item.ascStatType, ascType),
      'asc_atk_values': (item, other) =>
          validateWeaponAsc(item.ascAtkValues, item.ascStatValues),
      'asc_stat_values': (item, other) =>
          validateWeaponAsc(item.ascAtkValues, item.ascStatValues),
    }) as GsValidator<T>;
  }

  return GsValidator({});
}

String _expectedId(GsModel item) {
  if (item is GsBanner) {
    return '${item.name}_${item.dateStart.replaceAll('-', '_')}'.toDbId();
  }
  if (item is GsAchievement) {
    return '${item.group}_${item.name}_${item.reward}'.toDbId();
  }
  if (item is GsSpincrystal) {
    return item.number.toString();
  }
  if (item is GsVersion) {
    return item.id;
  }

  final name = ((item as dynamic)?.name as String?) ?? '';
  return name.toDbId();
}
