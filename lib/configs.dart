import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db/model_ext.dart';
import 'package:data_editor/db_ext/data_validator.dart';
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
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

const _fandomUrl =
    'https://static.wikia.nocookie.net/gensin-impact/images/4/4a/Site-favicon.ico';
final _ambrIcon = Image.network('https://ambr.top/favicon.ico');
final _fandomIcon = Image.network(_fandomUrl);
final _paimonMoeIcon = Image.network('https://paimon.moe/favicon.png');

class GsConfigs<T extends GsModel<T>> {
  final String title;
  final GsItemDecor Function(T item) getDecor;
  final List<GsFieldFilter<T>> filters;
  final Iterable<DataButton<T>> import;

  Items<T> get collection {
    try {
      return Database.i.of<T>();
    } catch (error) {
      print('\x1b[31mNo such collection: $T');
      rethrow;
    }
  }

  GsModelExt<T> get modelExt => GsModelExt.of<T>()!;

  GsConfigs._({
    required this.title,
    required this.getDecor,
    this.import = const [],
    this.filters = const [],
  });

  static final _map = <Type, GsConfigs>{
    GsAchievementGroup: GsConfigs<GsAchievementGroup>._(
      title: 'Achievement Category',
      getDecor: (item) {
        return GsItemDecor(
          label: '${item.achievements} (${item.rewards}✦)\n${item.name}',
          version: item.version,
          image: item.icon,
          color: GsStyle.getRarityColor(4),
          child: _orderItem(item.order),
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
      getDecor: (item) {
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
      getDecor: (item) => GsItemDecor(
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
          (i) => i.region,
        ),
      ],
    ),
    GsBanner: GsConfigs<GsBanner>._(
      title: 'Banners',
      getDecor: (item) {
        final data = item.feature5.firstOrNull;
        final image = data != null
            ? Database.i.of<GsCharacter>().getItem(data)?.image ??
                Database.i.of<GsWeapon>().getItem(data)?.image
            : null;
        return GsItemDecor(
          label: '${item.name}\n${item.dateStart}',
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
      getDecor: (item) => GsItemDecor(
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
          (i) => i.region,
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
    GsCharacterInfo: GsConfigs<GsCharacterInfo>._(
      title: 'Character Info',
      getDecor: (item) {
        final char = Database.i.of<GsCharacter>().getItem(item.id);
        return GsItemDecor(
          label: char?.name ?? item.id,
          image: char?.image,
          version: char?.version ?? '',
          color: GsStyle.getRarityColor(char?.rarity ?? 0),
          regionColor: GsStyle.getRegionElementColor(char?.region ?? ''),
        );
      },
      import: [
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
          (i) => Database.i.of<GsCharacter>().getItem(i.id)?.version ?? '',
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => Database.i.of<GsCharacter>().getItem(i.id)?.region ?? '',
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(4),
          (i) =>
              Database.i.of<GsCharacter>().getItem(i.id)?.rarity.toString() ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Element',
          GeElementType.values,
          (i) => Database.i.of<GsCharacter>().getItem(i.id)?.element.id ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Weapon',
          GeWeaponType.values,
          (i) => Database.i.of<GsCharacter>().getItem(i.id)?.weapon.id ?? '',
        ),
      ],
    ),
    GsCharacterSkin: GsConfigs<GsCharacterSkin>._(
      title: 'Character Outfits',
      getDecor: (item) {
        final char = Database.i.of<GsCharacter>().getItem(item.character);
        return GsItemDecor(
          label: item.name,
          image: char?.image,
          version: item.version,
          color: GsStyle.getRarityColor(item.rarity),
          regionColor: GsStyle.getRegionElementColor(char?.region ?? ''),
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
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: '',
        color: item.element.color,
        regionColor: GsStyle.getRegionElementColor(item.id),
      ),
    ),
    GsEnemy: GsConfigs<GsEnemy>._(
      title: 'Enemies',
      getDecor: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getRarityColor(1),
        image: item.image,
        child: _orderItem(item.order),
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
      getDecor: (item) => GsItemDecor(
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
          (i) => i.region,
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
      getDecor: (item) => GsItemDecor(
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
      getDecor: (item) => GsItemDecor(
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
      getDecor: (item) => GsItemDecor(
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
          (i) => i.region,
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
      getDecor: (item) => GsItemDecor(
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
    ),
    GsSpincrystal: GsConfigs<GsSpincrystal>._(
      title: 'Spincrystals',
      getDecor: (item) => GsItemDecor(
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
          (i) => i.region,
        ),
      ],
    ),
    GsViewpoint: GsConfigs<GsViewpoint>._(
      title: 'Viewpoints',
      getDecor: (item) => GsItemDecor(
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
          (i) => i.region,
        ),
      ],
    ),
    GsEvent: GsConfigs<GsEvent>._(
      title: 'Events',
      getDecor: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getVersionColor(item.version),
      ),
    ),
    GsWeapon: GsConfigs<GsWeapon>._(
      title: 'Weapons',
      getDecor: (item) => GsItemDecor(
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
    GsWeaponInfo: GsConfigs<GsWeaponInfo>._(
      title: 'Weapon Info',
      getDecor: (item) {
        final weapon = Database.i.of<GsWeapon>().getItem(item.id);
        return GsItemDecor(
          label: weapon?.name ?? item.id,
          image: weapon?.image,
          version: weapon?.version ?? '',
          color: GsStyle.getRarityColor(weapon?.rarity ?? 0),
        );
      },
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
          (i) => Database.i.of<GsWeapon>().getItem(i.id)?.version ?? '',
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => Database.i.of<GsWeapon>().getItem(i.id)?.rarity.toString() ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeWeaponType.values,
          (i) => Database.i.of<GsWeapon>().getItem(i.id)?.type.id ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Source',
          GeItemSourceType.values,
          (i) => Database.i.of<GsWeapon>().getItem(i.id)?.source.id ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Stat Type',
          GeWeaponAscStatType.values,
          (i) => Database.i.of<GsWeapon>().getItem(i.id)?.statType.id ?? '',
        ),
      ],
    ),
    GsVersion: GsConfigs<GsVersion>._(
      title: 'Versions',
      getDecor: (item) => GsItemDecor(
        label: item.id,
        version: item.id,
        color: GsStyle.getVersionColor(item.id),
      ),
    ),
  };

  static GsConfigs<T>? getConfig<T extends GsModel<T>>() {
    return _map[T] as GsConfigs<T>?;
  }

  static List<GsConfigs> getAllConfigs() {
    return _map.values.toList();
  }

  Widget toGridItem(BuildContext context) {
    final level = DataValidator.i.getMaxLevel<T>();
    final version = collection.items
            .map((e) => getDecor(e).version)
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
        list: () => collection.items.toList(),
        getDecor: getDecor,
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
        modelExt: modelExt,
        import: import,
      ),
    );
  }
}

Widget _orderItem(int order) {
  return Positioned(
    right: 2,
    bottom: 2,
    child: Container(
      width: 24,
      height: 24,
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
          order.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
