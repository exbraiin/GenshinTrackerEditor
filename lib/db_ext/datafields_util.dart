import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db/model_ext.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

typedef Func<R, T> = R Function(T item);

class ValidateModels<T extends GsModel<T>> {
  final List<String> ids;
  final Map<String, dynamic> _extra;
  final List<GsSelectItem<String>> filters;

  ValidateModels._(this.ids, this.filters, [this._extra = const {}]);
  factory ValidateModels._create({
    String? noneId,
    Iterable<T>? items,
    Func<bool, T>? filter,
    Func<Map<String, dynamic>, List<T>>? extra,
    Func<Iterable<T>, Iterable<T>>? sorter,
    GsModelDecorator<T>? decorator,
  }) {
    assert(items == null || filter == null, 'Provide only items or filter');
    if (items == null) {
      items = filter == null
          ? Database.i.of<T>().items
          : Database.i.of<T>().items.where(filter);
      items = sorter?.call(items) ?? items.sorted();
    }
    decorator ??= GsModelDecorator.of<T>();

    var ids = items.map((e) => e.id);
    var filters = items.map((e) {
      return GsSelectItem(
        e.id,
        decorator?.label?.call(e) ?? e.id,
        color: decorator?.color?.call(e) ?? Colors.grey,
        image: decorator?.image?.call(e),
      );
    });
    if (noneId != null) {
      ids = [noneId, ...ids];
      final image = decorator.image != null ? '' : null;
      filters = [GsSelectItem(noneId, 'None', image: image), ...filters];
    }

    return ValidateModels._(
      ids.toList(growable: false),
      filters.toList(growable: false),
      extra?.call(items.toList()) ?? const {},
    );
  }
  factory ValidateModels() => ValidateModels._create();

  static ValidateModels<GsMaterial> ingredients() {
    return ValidateModels._create(
      filter: (e) => e.ingredient,
      sorter: (e) => e.sortedBy((e) => e.rarity).thenBy((e) => e.id),
    );
  }

  static ValidateModels<GsMaterial> materials(
    GeMaterialType type, [
    GeMaterialType? type1,
  ]) {
    return ValidateModels<GsMaterial>._create(
      items: Database.i
          .getMaterialGroups(type, type1)
          .sortedBy((element) => element.region.index)
          .thenBy((element) => element.rarity)
          .thenBy((element) => element.version)
          .thenBy((element) => element.name)
          .toList(),
      extra: (items) => items.map((e) => MapEntry(e.id, e.region)).toMap(),
      decorator: GsModelDecorator(
        label: (item) => item.name,
        image: (item) => item.image,
        color: (item) => switch (type) {
          GeMaterialType.ascensionGems ||
          GeMaterialType.normalBossDrops ||
          GeMaterialType.regionMaterials ||
          GeMaterialType.talentMaterials ||
          GeMaterialType.weaponMaterials ||
          GeMaterialType.weeklyBossDrops =>
            GsStyle.getRegionElementColor(item.region) ?? Colors.grey,
          _ => GsStyle.getRarityColor(item.rarity),
        },
      ),
    );
  }

  static ValidateModels<GsRecipe> baseRecipes() {
    return ValidateModels._create(
      noneId: '',
      filter: (e) => e.baseRecipe.isEmpty && e.type == GeRecipeType.permanent,
    );
  }

  static ValidateModels<GsRecipe> baseRecipesWithIngredients(GsRecipe item) {
    return ValidateModels._create(
      noneId: '',
      filter: (e) =>
          e.baseRecipe.isEmpty &&
          e.type == GeRecipeType.permanent &&
          e.hasSameIngredientsOf(item),
    );
  }

  static ValidateModels<GsRecipe> specialRecipes({
    String? savedId,
    bool allowNone = false,
  }) {
    late final chars = Database.i.of<GsCharacter>().items;
    late final usedIds = chars.map((e) => e.specialDish).toList();

    return ValidateModels<GsRecipe>._create(
      noneId: allowNone ? 'none' : null,
      filter: savedId == null
          ? (item) => item.baseRecipe.isNotEmpty
          : (item) =>
              item.id == savedId ||
              (item.baseRecipe.isNotEmpty && !usedIds.contains(item.id)),
    );
  }

  static ValidateModels<GsVersion> versions() {
    return ValidateModels._create(
      extra: (items) => items.mapIndexed((i, e) {
        final next = i + 1 < items.length ? items[i + 1] : null;
        return MapEntry(e.id, (e.releaseDate, next?.releaseDate));
      }).toMap(),
    );
  }

  static ValidateModels<GsNamecard> namecards(
    GeNamecardType? type, {
    String? savedId,
    bool allowNone = false,
  }) {
    Iterable<String> ids<E extends GsModel<E>>(String Function(E) mapper) =>
        Database.i.of<E>().items.map(mapper);
    var items = Database.i.of<GsNamecard>().items;
    if (type != null) items = items.where((e) => e.type == type);

    late final usedIds = switch (type) {
      GeNamecardType.character => ids<GsCharacter>((e) => e.namecardId),
      GeNamecardType.battlepass => ids<GsBattlepass>((e) => e.namecardId),
      GeNamecardType.achievement => ids<GsAchievementGroup>((e) => e.namecard),
      _ => <String>[],
    };

    return ValidateModels._create(
      items: savedId == null
          ? items
          : items.where((e) => e.id == savedId || !usedIds.contains(e.id)),
      noneId: allowNone ? 'none' : null,
    );
  }

  static Map<GeBannerType?, ValidateModels<GsWish>> wishesByType(int? rarity) {
    return {
      null: ValidateModels.wishes(rarity, null),
      for (final bannerType in GeBannerType.values)
        bannerType: ValidateModels.wishes(rarity, bannerType),
    };
  }

  static ValidateModels<GsWish> wishes(int? rarity, GeBannerType? type) {
    return ValidateModels._create(
      items: Database.i
          .getAllWishes(rarity, type)
          .sortedBy((e) => e.isCharacter ? 0 : 1)
          .thenBy((e) => e.name),
    );
  }

  static Map<GeEnemyType?, ValidateModels<GsMaterial>> dropsByType() {
    return {
      null: ValidateModels.drops(null),
      for (final enemyType in GeEnemyType.values)
        enemyType: ValidateModels.drops(enemyType),
    };
  }

  static ValidateModels<GsMaterial> drops(GeEnemyType? type) {
    return ValidateModels._create(
      filter: type != null
          ? (item) => type.materialTypes.contains(item.group)
          : null,
    );
  }

  static ValidateModels<GsMaterial> oculi() {
    return ValidateModels._create(
      noneId: 'none',
      filter: (item) => item.group == GeMaterialType.oculi,
    );
  }

  GsValidLevel validateItemId(T item, String? editId) {
    // We set the id if the given one is empty in order to validate all items.
    if (editId?.isEmpty ?? false) editId = item.id;
    final id = item.id;
    final expected = expectedId(item);
    if (id.isEmpty) return GsValidLevel.error;
    final check = id != expected ? GsValidLevel.warn1 : GsValidLevel.good;
    final withoutSelf = ids.where((e) => e != editId);
    return !withoutSelf.contains(id) ? check : GsValidLevel.error;
  }

  GsValidLevel validate(String id) {
    if (!ids.contains(id)) return GsValidLevel.warn3;
    return GsValidLevel.good;
  }

  GsValidLevel validateAll(Iterable<String> ids) {
    if (!ids.containsAll(ids)) return GsValidLevel.warn3;
    return GsValidLevel.good;
  }
}

extension VeVersion on ValidateModels<GsVersion> {
  (DateTime, DateTime?)? getDates(String version) {
    return _extra[version];
  }

  GsValidLevel validateDate(String version, DateTime date) {
    if (!ids.contains(version)) return GsValidLevel.warn3;
    final dates = getDates(version);
    if (dates == null) return GsValidLevel.warn3;
    if (date.isBefore(dates.$1)) return GsValidLevel.warn3;
    if (dates.$2 != null && date.isAfter(dates.$2!)) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  GsValidLevel validateDates(String version, DateTime src, [DateTime? dst]) {
    if (!ids.contains(version)) return GsValidLevel.warn3;
    final dates = getDates(version);
    if (dates == null) return GsValidLevel.warn3;
    if (!dates.contains(src)) return GsValidLevel.warn3;
    if (dst != null && !dates.contains(dst)) return GsValidLevel.warn3;
    if (dst != null && !dst.isAfter(src)) return GsValidLevel.warn3;
    return GsValidLevel.good;
  }
}

extension VeMaterials on ValidateModels<GsMaterial> {
  GsValidLevel validateWithRegion(String id, GeRegionType? region) {
    if (region != null) {
      final matRegion = _extra[id];
      if (matRegion == null) return GsValidLevel.warn3;
      if (matRegion != region) return GsValidLevel.warn1;
    }
    return validate(id);
  }
}

class GsModelDecorator<T extends GsModel<T>> {
  final Func<String, T>? label;
  final Func<String, T>? image;
  final Func<Color, T>? color;

  GsModelDecorator({this.label, this.image, this.color});
  static GsModelDecorator<E> of<E extends GsModel<E>>() {
    return switch (E) {
      const (GsWish) => GsModelDecorator<GsWish>(
          label: (i) => i.name,
          image: (i) => i.image,
          color: (i) => GsStyle.getRarityColor(i.rarity),
        ),
      const (GsAchievementGroup) => GsModelDecorator<GsAchievementGroup>(
          label: (item) => item.name,
          color: (item) => GsStyle.getRarityColor(4),
        ),
      const (GsCharacter) => GsModelDecorator<GsCharacter>(
          label: (item) => item.name,
          image: (item) => item.image,
          color: (item) => GsStyle.getRarityColor(item.rarity),
        ),
      const (GsVersion) => GsModelDecorator<GsVersion>(
          color: (item) => GsStyle.getVersionColor(item.id),
        ),
      const (GsMaterial) => GsModelDecorator<GsMaterial>(
          label: (item) => item.name,
          image: (item) => item.image,
          color: (item) => GsStyle.getRarityColor(item.rarity),
        ),
      const (GsNamecard) => GsModelDecorator<GsNamecard>(
          label: (i) => i.name,
          image: (i) => i.image,
          color: (i) => GsStyle.getRarityColor(i.rarity),
        ),
      const (GsRecipe) => GsModelDecorator<GsRecipe>(
          label: (item) => item.name,
          image: (item) => item.image,
          color: (i) => GsStyle.getRarityColor(i.rarity),
        ),
      const (GsFurnishing) => GsModelDecorator<GsFurnishing>(
          label: (item) => item.name,
          image: (item) => item.image,
          color: (item) => GsStyle.getRarityColor(item.rarity),
        ),
      const (GsWeapon) => GsModelDecorator<GsWeapon>(
          label: (item) => item.name,
          image: (item) => item.image,
          color: (item) => GsStyle.getRarityColor(item.rarity),
        ),
      _ => GsModelDecorator<E>(),
    } as GsModelDecorator<E>;
  }
}

extension on (DateTime, DateTime?) {
  bool contains(DateTime date) {
    if ($2 == null) return !date.isBefore($1);
    return !date.isBefore($1) && date.isBefore($2!);
  }
}
