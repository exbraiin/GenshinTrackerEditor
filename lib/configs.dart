import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db/model_ext.dart';
import 'package:data_editor/db_ext/data_validator.dart' as vd;
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/screens/item_edit_screen.dart';
import 'package:data_editor/screens/items_list_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_item.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

const _fandomBaseUrl = 'https://static.wikia.nocookie.net/gensin-impact';
const _fandomUrl = '$_fandomBaseUrl/images/4/4a/Site-favicon.ico';
final _ambrIcon = Image.network('https://ambr.top/favicon.ico');
final _fandomIcon = Image.network(_fandomUrl);
final _paimonMoeIcon = Image.network('https://paimon.moe/favicon.png');

class GsConfigs<T extends GsModel<T>> {
  final String title;
  final GsModelExt<T> pageBuilder;
  final GsItemDecor Function(T item) itemDecoration;
  final List<GsFieldFilter<T>> filters;
  final Iterable<DataButton<T>> import;
  final Iterable<T> Function(Iterable<T> c)? sortByVersion;

  Items<T> get collection {
    try {
      return Database.i.of<T>();
    } catch (error) {
      if (kDebugMode) print('\x1b[31mNo such collection: $T');
      rethrow;
    }
  }

  GsConfigs._({
    required this.title,
    required this.pageBuilder,
    required this.itemDecoration,
    this.sortByVersion,
    this.import = const [],
    this.filters = const [],
  });

  static final _versions = ValidateModels.versions();
  static final _map = <Type, GsConfigs>{
    GsAchievementGroup: GsConfigs<GsAchievementGroup>._(
      title: 'Achievement Category',
      pageBuilder: const vd.GsAchievementGroupExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.order)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) {
        return GsItemDecor.rarity(
          label: '${item.achievements} (${item.rewards}✦)\n${item.name}',
          version: item.version,
          rarity: 4,
          image: item.icon,
          child: _orderItem(item.order.toString()),
        );
      },
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
      ],
    ),
    GsAchievement: GsConfigs<GsAchievement>._(
      title: 'Achievement',
      pageBuilder: const vd.GsAchievementExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.group)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) {
        final cat = Database.i.of<GsAchievementGroup>().getItem(item.group);
        return GsItemDecor.rarity(
          label: '${item.name}\n(${item.reward}✦)',
          version: item.version,
          rarity: 4,
          image: cat?.icon,
        );
      },
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeAchievementType.values,
          (i) => i.type,
        ),
        GsFieldFilter(
          'Category',
          ValidateModels<GsAchievementGroup>().filters,
          (i) => i.group,
        ),
      ],
    ),
    GsArtifact: GsConfigs<GsArtifact>._(
      title: 'Artifacts',
      pageBuilder: const vd.GsArtifactExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarity,
        image: item.pieces.firstOrNull?.icon,
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
        GsFieldFilter.fromEnum(
          'Region',
          GeRegionType.values,
          (i) => i.region,
        ),
      ],
    ),
    GsBanner: GsConfigs<GsBanner>._(
      title: 'Banners',
      pageBuilder: const vd.GsBannerExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.type.index)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) {
        final data = item.feature5.firstOrNull;
        final image = data != null
            ? Database.i.of<GsCharacter>().getItem(data)?.image ??
                Database.i.of<GsWeapon>().getItem(data)?.image
            : null;
        return GsItemDecor.color(
          label: '${item.dateStart.toString().split(' ').first}\n${item.name}',
          version: item.version,
          color: item.type.color,
          image: image,
        );
      },
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeBannerType.values,
          (i) => i.type,
        ),
      ],
    ),
    GsCharacter: GsConfigs<GsCharacter>._(
      title: 'Characters',
      pageBuilder: const vd.GsCharacterExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarity.coerceAtLeast(1),
        image: item.image,
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      import: [
        DataButton(
          'Import from fandom URL',
          icon: _fandomIcon,
          (ctx, item) => Importer.importCharacterFromFandom(item),
        ),
        DataButton(
          'Import stats from Ambr table',
          icon: _ambrIcon,
          (ctx, item) => Importer.importCharacterStatsFromAmbr(item),
        ),
        DataButton(
          'Import stats from Paimon.moe',
          icon: _paimonMoeIcon,
          (ctx, item) => Importer.importCharacterInfoFromPaimonMoe(item),
        ),
      ],
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Region',
          GeRegionType.values,
          (i) => i.region,
        ),
        GsFieldFilter.fromEnum(
          'Gender',
          GeGenderType.values,
          (i) => i.gender,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity, 4),
        GsFieldFilter.fromEnum(
          'Element',
          GeElementType.values,
          (i) => i.element,
        ),
        GsFieldFilter.fromEnum(
          'Weapon',
          GeWeaponType.values,
          (i) => i.weapon,
        ),
        GsFieldFilter.fromEnum(
          'Ascension Stat',
          GeCharacterAscStatType.values,
          (i) => i.ascStatType,
        ),
      ],
    ),
    GsCharacterSkin: GsConfigs<GsCharacterSkin>._(
      title: 'Character Outfits',
      pageBuilder: const vd.GsCharacterSkinExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) {
        final char = Database.i.of<GsCharacter>().getItem(item.character);
        return GsItemDecor.rarity(
          label: item.name,
          version: item.version,
          rarity: item.rarity,
          image: char?.image,
          regionColor:
              GsStyle.getRegionElementColor(char?.region ?? GeRegionType.none),
        );
      },
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
      ],
    ),
    GsRegion: GsConfigs<GsRegion>._(
      title: 'Regions',
      pageBuilder: const vd.GsRegionExt(),
      itemDecoration: (item) => GsItemDecor.color(
        label: item.name,
        version: '',
        color: item.element.color,
        image: item.image,
        regionColor:
            GsStyle.getRegionElementColor(GeRegionType.values.fromId(item.id)),
      ),
    ),
    GsEnemy: GsConfigs<GsEnemy>._(
      title: 'Enemies',
      pageBuilder: const vd.GsEnemyExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarityByType)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarityByType,
        image: item.image,
        child: _orderItem(item.order.toString()),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeEnemyType.values,
          (i) => i.type,
        ),
        GsFieldFilter.fromEnum(
          'Family',
          GeEnemyFamilyType.values,
          (i) => i.family,
        ),
      ],
    ),
    GsMaterial: GsConfigs<GsMaterial>._(
      title: 'Materials',
      pageBuilder: const vd.GsMaterialExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarity,
        image: item.image,
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
        GsFieldFilter.fromEnum(
          'Region',
          GeRegionType.values,
          (i) => i.region,
        ),
        GsFieldFilter.fromEnum(
          'Group',
          GeMaterialType.values,
          (i) => i.group,
        ),
        GsFieldFilter(
          'Ingredient',
          [
            const GsSelectItem('true', 'Yes'),
            const GsSelectItem('false', 'No'),
          ],
          (i) => i.ingredient.toString(),
        ),
      ],
    ),
    GsNamecard: GsConfigs<GsNamecard>._(
      title: 'Namecards',
      pageBuilder: const vd.GsNamecardExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.color(
        label: item.name,
        version: item.version,
        color: GsStyle.getNamecardColor(item.type),
        image: item.image,
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
        GsFieldFilter.fromEnum(
          'Type',
          GeNamecardType.values,
          (i) => i.type,
        ),
      ],
    ),
    GsRecipe: GsConfigs<GsRecipe>._(
      title: 'Recipes',
      pageBuilder: const vd.GsRecipeExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarity,
        image: item.image,
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
        GsFieldFilter.fromEnum(
          'Type',
          GeRecipeType.values,
          (i) => i.type,
        ),
        GsFieldFilter.fromEnum(
          'Effect',
          GeRecipeEffectType.values,
          (i) => i.effect,
        ),
      ],
    ),
    GsFurnitureChest: GsConfigs<GsFurnitureChest>._(
      title: 'Remarkable Chests',
      pageBuilder: const vd.GsFurnitureChestExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarity,
        image: item.image,
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
        GsFieldFilter.fromEnum(
          'Region',
          GeRegionType.values,
          (i) => i.region,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeSereniteaSetType.values,
          (i) => i.type,
        ),
      ],
    ),
    GsSereniteaSet: GsConfigs<GsSereniteaSet>._(
      title: 'Sereniteas',
      pageBuilder: const vd.GsSereniteaSetExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.category.index)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.color(
        label: item.name,
        version: item.version,
        color: item.category.color,
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Category',
          GeSereniteaSetType.values,
          (i) => i.category,
        ),
      ],
      import: [
        DataButton(
          'Import from fandom URL',
          icon: _fandomIcon,
          (ctx, item) => Importer.importSereniteaFromFandom(item),
        ),
      ],
    ),
    GsFurnishing: GsConfigs<GsFurnishing>._(
      title: 'Furnishing',
      pageBuilder: const vd.GsFurnishingExt(),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: '',
        rarity: item.rarity,
        image: item.image,
      ),
      filters: [
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
      ],
      import: [
        DataButton(
          'Import from fandom URL',
          icon: _fandomIcon,
          (ctx, item) => Importer.importFurnishingFromFandom(item),
        ),
      ],
    ),
    GsSpincrystal: GsConfigs<GsSpincrystal>._(
      title: 'Spincrystals',
      pageBuilder: const vd.GsSpincrystalExt(),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: '${item.number}',
        version: item.version,
        rarity: 5,
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Region',
          GeRegionType.values,
          (i) => i.region,
        ),
      ],
    ),
    GsViewpoint: GsConfigs<GsViewpoint>._(
      title: 'Viewpoints',
      pageBuilder: const vd.GsViewpointExt(),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: 4,
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Region',
          GeRegionType.values,
          (i) => i.region,
        ),
      ],
    ),
    GsEvent: GsConfigs<GsEvent>._(
      title: 'Events',
      pageBuilder: const vd.GsEventExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.dateStart)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.color(
        label: item.name,
        version: item.version,
        color: GsStyle.getVersionColor(item.version),
        child: _orderItem(item.type.name.substring(0, 1).capitalize()),
      ),
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeEventType.values,
          (i) => i.type,
        ),
      ],
    ),
    GsWeapon: GsConfigs<GsWeapon>._(
      title: 'Weapons',
      pageBuilder: const vd.GsWeaponExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.rarity)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.rarity(
        label: item.name,
        version: item.version,
        rarity: item.rarity,
        image: item.image,
      ),
      import: [
        DataButton(
          'Import stats from Ambr table',
          icon: _ambrIcon,
          (ctx, item) => Importer.importWeaponAscensionStatsFromAmbr(item),
        ),
        DataButton(
          'Import stats from Paimon.moe',
          icon: _paimonMoeIcon,
          (context, item) => Importer.importWeaponInfoFromPaimonMoe(item),
        ),
      ],
      filters: [
        GsFieldFilter(
          'Version',
          _versions.filters,
          (i) => i.version,
        ),
        GsFieldFilter.rarity('Rarity', (i) => i.rarity),
        GsFieldFilter.fromEnum(
          'Type',
          GeWeaponType.values,
          (i) => i.type,
        ),
        GsFieldFilter.fromEnum(
          'Source',
          GeItemSourceType.values,
          (i) => i.source,
        ),
        GsFieldFilter.fromEnum(
          'Stat Type',
          GeWeaponAscStatType.values,
          (i) => i.statType,
        ),
      ],
    ),
    GsBattlepass: GsConfigs<GsBattlepass>._(
      title: 'Battlepass',
      pageBuilder: const vd.GsBattlepassExt(),
      sortByVersion: (c) => c
          .sortedByDescending((e) => e.version)
          .thenByDescending((e) => e.dateStart)
          .thenBy((e) => e.name)
          .thenBy((e) => e.id),
      itemDecoration: (item) => GsItemDecor.color(
        label: item.name,
        version: item.version,
        color: GsStyle.getVersionColor(item.version),
        image: item.image,
      ),
    ),
    GsVersion: GsConfigs<GsVersion>._(
      title: 'Versions',
      pageBuilder: const vd.GsVersionExt(),
      sortByVersion: (c) => c.sortedByDescending((e) => e.id),
      itemDecoration: (item) => GsItemDecor.color(
        label: item.id,
        version: item.id,
        color: GsStyle.getVersionColor(item.id),
      ),
    ),
  };

  static GsConfigs<T>? of<T extends GsModel<T>>() {
    return _map[T] as GsConfigs<T>?;
  }

  static List<GsConfigs> getAllConfigs() {
    return _map.values.toList();
  }

  Widget toGridItem(BuildContext context) {
    final level = vd.DataValidator.i.getMaxLevel<T>();
    final version = collection.items
            .map((e) => itemDecoration(e).version)
            .toSet()
            .sortedBy((element) => element)
            .lastOrNull ??
        '';

    return GsGridItem(
      color: Colors.grey,
      label: title,
      version: version,
      validLevel: level,
      onTap: () => openListScreen(context),
    );
  }

  void openListScreen(BuildContext context) {
    context.pushWidget(
      ItemsListScreen<T>(
        title: title,
        list: () => collection.items.sorted(),
        sortByVersion: sortByVersion,
        getDecor: itemDecoration,
        onTap: openEditScreen,
        filters: filters,
      ),
    );
  }

  void openEditScreen(BuildContext context, T? item) {
    context.pushWidget(
      ItemEditScreen<T>(
        item: item,
        title: title,
        collection: collection,
        modelExt: pageBuilder,
        import: import,
      ),
    );
  }
}

Widget _orderItem(String order) {
  return Positioned(
    top: 4,
    left: 4,
    child: Container(
      height: 24,
      constraints: const BoxConstraints(minWidth: 24),
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color.lerp(Colors.black, Colors.white, 0.4)!,
            Color.lerp(Colors.black, Colors.black, 0.4)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          order,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
