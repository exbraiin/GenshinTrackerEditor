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
    this.import = const [],
    this.filters = const [],
  });

  static final _map = <Type, GsConfigs>{
    GsAchievementGroup: GsConfigs<GsAchievementGroup>._(
      title: 'Achievement Category',
      pageBuilder: const vd.GsAchievementGroupExt(),
      itemDecoration: (item) {
        return GsItemDecor(
          label: '${item.achievements} (${item.rewards}✦)\n${item.name}',
          version: item.version,
          image: item.icon,
          color: GsStyle.getRarityColor(4),
          child: _orderItem(item.order.toString()),
        );
      },
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
      ],
    ),
    GsAchievement: GsConfigs<GsAchievement>._(
      title: 'Achievement',
      pageBuilder: const vd.GsAchievementExt(),
      itemDecoration: (item) {
        final cat = Database.i.of<GsAchievementGroup>().getItem(item.group);
        return GsItemDecor(
          label: '${item.name}\n(${item.reward}✦)',
          version: item.version,
          color: GsStyle.getRarityColor(4),
          image: cat?.icon,
        );
      },
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeAchievementType.values,
          (i) => i.type.id,
        ),
        GsFieldFilter.fromFilter(
          'Category',
          GsItemFilter.achievementGroups(),
          (i) => i.group,
        ),
      ],
    ),
    GsArtifact: GsConfigs<GsArtifact>._(
      title: 'Artifacts',
      pageBuilder: const vd.GsArtifactExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.pieces.firstOrNull?.icon,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => i.region.id,
        ),
      ],
    ),
    GsBanner: GsConfigs<GsBanner>._(
      title: 'Banners',
      pageBuilder: const vd.GsBannerExt(),
      itemDecoration: (item) {
        final data = item.feature5.firstOrNull;
        final image = data != null
            ? Database.i.of<GsCharacter>().getItem(data)?.image ??
                Database.i.of<GsWeapon>().getItem(data)?.image
            : null;
        return GsItemDecor(
          label: '${item.name}\n${item.dateStart.toString().split(' ').first}',
          image: image,
          version: item.version,
          color: item.type.color,
        );
      },
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeBannerType.values,
          (i) => i.type.id,
        ),
      ],
    ),
    GsCharacter: GsConfigs<GsCharacter>._(
      title: 'Characters',
      pageBuilder: const vd.GsCharacterExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
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
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => i.region.id,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(4),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromEnum(
          'Element',
          GeElementType.values,
          (i) => i.element.id,
        ),
        GsFieldFilter.fromEnum(
          'Weapon',
          GeWeaponType.values,
          (i) => i.weapon.id,
        ),
      ],
    ),
    GsCharacterSkin: GsConfigs<GsCharacterSkin>._(
      title: 'Character Outfits',
      pageBuilder: const vd.GsCharacterSkinExt(),
      itemDecoration: (item) {
        final char = Database.i.of<GsCharacter>().getItem(item.character);
        return GsItemDecor(
          label: item.name,
          image: char?.image,
          version: item.version,
          color: GsStyle.getRarityColor(item.rarity),
          regionColor:
              GsStyle.getRegionElementColor(char?.region ?? GeRegionType.none),
        );
      },
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
      ],
    ),
    GsRegion: GsConfigs<GsRegion>._(
      title: 'Cities',
      pageBuilder: const vd.GsRegionExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: '',
        color: item.element.color,
        regionColor:
            GsStyle.getRegionElementColor(GeRegionType.values.fromId(item.id)),
      ),
    ),
    GsEnemy: GsConfigs<GsEnemy>._(
      title: 'Enemies',
      pageBuilder: const vd.GsEnemyExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getRarityColor(1),
        image: item.image,
        child: _orderItem(item.order.toString()),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeEnemyType.values,
          (i) => i.type.id,
        ),
        GsFieldFilter.fromEnum(
          'Family',
          GeEnemyFamilyType.values,
          (i) => i.family.id,
        ),
      ],
    ),
    GsMaterial: GsConfigs<GsMaterial>._(
      title: 'Materials',
      pageBuilder: const vd.GsMaterialExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => i.region.id,
        ),
        GsFieldFilter.fromEnum(
          'Group',
          GeMaterialType.values,
          (i) => i.group.id,
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
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getNamecardColor(item.type),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeNamecardType.values,
          (i) => i.type.id,
        ),
      ],
    ),
    GsRecipe: GsConfigs<GsRecipe>._(
      title: 'Recipes',
      pageBuilder: const vd.GsRecipeExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeRecipeType.values,
          (i) => i.type.id,
        ),
        GsFieldFilter.fromEnum(
          'Effect',
          GeRecipeEffectType.values,
          (i) => i.effect.id,
        ),
      ],
    ),
    GsFurnitureChest: GsConfigs<GsFurnitureChest>._(
      title: 'Remarkable Chests',
      pageBuilder: const vd.GsFurnitureChestExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => i.region.id,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeSereniteaSetType.values,
          (i) => i.type.id,
        ),
      ],
    ),
    GsSereniteaSet: GsConfigs<GsSereniteaSet>._(
      title: 'Sereniteas',
      pageBuilder: const vd.GsSereniteaSetExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: item.category.color,
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Category',
          GeSereniteaSetType.values,
          (i) => i.category.id,
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
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        version: '',
        color: GsStyle.getRarityColor(item.rarity),
        image: item.image,
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
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
      itemDecoration: (item) => GsItemDecor(
        label: '${item.number}',
        version: item.version,
        color: GsStyle.getRarityColor(5),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => i.region.id,
        ),
      ],
    ),
    GsViewpoint: GsConfigs<GsViewpoint>._(
      title: 'Viewpoints',
      pageBuilder: const vd.GsViewpointExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getRarityColor(4),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => i.region.id,
        ),
      ],
    ),
    GsEvent: GsConfigs<GsEvent>._(
      title: 'Events',
      pageBuilder: const vd.GsEventExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getVersionColor(item.version),
        child: _orderItem(item.type.name.substring(0, 1).capitalize()),
      ),
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeEventType.values,
          (i) => i.type.id,
        ),
      ],
    ),
    GsWeapon: GsConfigs<GsWeapon>._(
      title: 'Weapons',
      pageBuilder: const vd.GsWeaponExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
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
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => i.version,
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => i.rarity.toString(),
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeWeaponType.values,
          (i) => i.type.id,
        ),
        GsFieldFilter.fromEnum(
          'Source',
          GeItemSourceType.values,
          (i) => i.source.id,
        ),
        GsFieldFilter.fromEnum(
          'Stat Type',
          GeWeaponAscStatType.values,
          (i) => i.statType.id,
        ),
      ],
    ),
    GsBattlepass: GsConfigs<GsBattlepass>._(
      title: 'Battlepass',
      pageBuilder: const vd.GsBattlepassExt(),
      itemDecoration: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        image: item.image,
        color: GsStyle.getVersionColor(item.version),
      ),
    ),
    GsVersion: GsConfigs<GsVersion>._(
      title: 'Versions',
      pageBuilder: const vd.GsVersionExt(),
      itemDecoration: (item) => GsItemDecor(
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
    right: 2,
    bottom: 2,
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
