import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsItemFilter {
  final Iterable<GsSelectItem<String>> filters;

  Iterable<String> get ids => filters.map((e) => e.value);

  GsItemFilter._(this.filters);

  static GsItemFilter _from<T>(
    Iterable<T> models,
    String Function(T i) selector, {
    String? noneId,
    String Function(T i)? title,
    String Function(T i)? icon,
    String? Function(T i)? image,
    Color Function(T i)? color,
  }) {
    return GsItemFilter._([
      if (noneId != null)
        GsSelectItem(
          noneId,
          'None',
          image: image != null ? '' : null,
        ),
      ...models.map((e) {
        final value = selector(e);
        return GsSelectItem(
          value,
          title?.call(e) ?? value.toTitle(),
          asset: icon?.call(e) ?? '',
          color: color?.call(e) ?? Colors.grey,
          image: image?.call(e),
        );
      }),
    ]);
  }

  // ----- DATABASE ------------------------------------------------------------

  factory GsItemFilter.specialDishes({GsCharacter? character}) {
    final allRecipes = Database.i.of<GsRecipe>().items;
    var recipes = allRecipes.where((e) => e.baseRecipe.isNotEmpty);
    if (character != null) {
      final allChars = Database.i.of<GsCharacter>().items;
      final chars = allChars.where((e) => e.id != character.id);
      recipes = recipes.where((e) => chars.all((c) => c.specialDish != e.id));
    }
    return GsItemFilter._from(
      recipes,
      (i) => i.id,
      noneId: 'none',
      title: (i) => i.name,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
  factory GsItemFilter.wishes(int? rarity, GeBannerType? type) {
    return GsItemFilter._from(
      Database.i
          .getAllWishes(rarity, type)
          .sortedBy((e) => e.isCharacter ? 0 : 1)
          .thenBy((element) => element.name),
      (i) => i.id,
      title: (i) => i.name,
      color: (i) => GsStyle.getRarityColor(i.rarity),
      image: (i) => i.image,
    );
  }
  factory GsItemFilter.drops(int? rarity, GeEnemyType? type) {
    bool isValidMat(GsMaterial mat) {
      late final matType = switch (type) {
        GeEnemyType.common => [GeMaterialType.normalDrops],
        GeEnemyType.elite => [
            GeMaterialType.normalDrops,
            GeMaterialType.eliteDrops,
          ],
        GeEnemyType.normalBoss => [GeMaterialType.normalBossDrops],
        GeEnemyType.weeklyBoss => [GeMaterialType.weeklyBossDrops],
        _ => [],
      };

      return (rarity == null || mat.rarity == rarity) &&
          (type == null || matType.contains(mat.group));
    }

    return GsItemFilter._from(
      Database.i.of<GsMaterial>().items.where(isValidMat),
      (i) => i.id,
      title: (i) => i.name,
      image: (i) => i.image,
      color: (i) => GsStyle.getRarityColor(i.rarity),
    );
  }
}

typedef Func<R, T> = R Function(T item);

class ValidateModels<T extends GsModel<T>> {
  final List<String> ids;
  final List<GsSelectItem<String>> filters;
  final Map<String, dynamic> _extra;

  ValidateModels._(this.ids, this.filters, [this._extra = const {}]);
  factory ValidateModels._create({
    String? noneId,
    Iterable<T>? items,
    Func<bool, T>? filter,
    Func<Map<String, dynamic>, List<T>>? extra,
    GsModelDecorator<T>? decorator,
    Func<Iterable<T>, Iterable<T>>? sorter,
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

  static ValidateModels<GsVersion> versions() {
    return ValidateModels._create(
      extra: (items) => items.mapIndexed((i, e) {
        final next = i + 1 < items.length ? items[i + 1] : null;
        return MapEntry(e.id, (e.releaseDate, next?.releaseDate));
      }).toMap(),
    );
  }

  static ValidateModels<GsNamecard> namecards({
    GeNamecardType? type,
    bool unusedOnly = false,
  }) {
    Iterable<E> of<E extends GsModel<E>>() => Database.i.of<E>().items;
    var items = of<GsNamecard>();
    if (type != null) items = items.where((e) => e.type == type);
    return ValidateModels._create(
      items: items,
      noneId: 'none',
      extra: (item) {
        if (!unusedOnly) return const {};
        final used = switch (type) {
          GeNamecardType.battlepass =>
            of<GsBattlepass>().map((element) => element.namecardId),
          GeNamecardType.character =>
            of<GsCharacter>().map((element) => element.namecardId),
          GeNamecardType.achievement =>
            of<GsAchievementGroup>().map((element) => element.namecard),
          _ => <String>[],
        };
        return {
          'none': 'none',
          'used': used.toList(),
        };
      },
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
}

extension ValidateModelsVersion on ValidateModels<GsVersion> {
  (DateTime, DateTime?)? getDates(String version) {
    return _extra[version];
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

extension ValidateModelsMaterials on ValidateModels<GsMaterial> {
  GsValidLevel validateWithRegion(String id, GeRegionType? region) {
    if (region != null) {
      final matRegion = _extra[id];
      if (matRegion == null) return GsValidLevel.warn3;
      if (matRegion != region) return GsValidLevel.warn1;
    }
    return validate(id);
  }
}

extension ValidateModelsNamecards on ValidateModels<GsNamecard> {
  List<GsSelectItem<String>> filtersWithId(String id) {
    if (_extra.isEmpty) return filters;
    final none = _extra['none'] as String?;
    final used = _extra['used'] as List<String>;
    final save = (_extra['save'] ??= id) as String;
    return filters
        .where(
          (e) => e.value == save || e.value == none || !used.contains(e.value),
        )
        .toList();
  }
}

class GsModelDecorator<T extends GsModel<T>> {
  final Func<String, T>? label;
  final Func<String, T>? image;
  final Func<Color, T>? color;

  GsModelDecorator({this.label, this.image, this.color});
  static GsModelDecorator<E> of<E extends GsModel<E>>() {
    return switch (E) {
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
