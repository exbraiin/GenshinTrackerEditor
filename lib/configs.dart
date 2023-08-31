import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/screens/item_edit_screen.dart';
import 'package:data_editor/screens/items_list_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_item.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsConfigs<T extends GsModel<T>> {
  final String title;
  final GsItemDecor Function(T item) getDecor;
  final List<GsFieldFilter<T>> filters;

  GsCollection<T> get collection => Database.i.collectionOf<T>()!;
  GsModelExt<T> get modelExt => GsModelExt.of<T>()!;

  GsConfigs._({
    required this.title,
    required this.getDecor,
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
        final cat = Database.i.achievementGroups.getItem(item.group);
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
            ? Database.i.characters.getItem(data)?.image ??
                Database.i.weapons.getItem(data)?.image
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
          GeElements.values,
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
        final char = Database.i.characters.getItem(item.id);
        return GsItemDecor(
          label: char?.name ?? item.id,
          image: char?.image,
          version: char?.version ?? '',
          color: GsStyle.getRarityColor(char?.rarity ?? 0),
          regionColor: GsStyle.getRegionElementColor(char?.region ?? ''),
        );
      },
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => Database.i.characters.getItem(i.id)?.version ?? '',
        ),
        GsFieldFilter.fromFilter(
          'Region',
          GsItemFilter.regions(),
          (i) => Database.i.characters.getItem(i.id)?.region ?? '',
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(4),
          (i) => Database.i.characters.getItem(i.id)?.rarity.toString() ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Element',
          GeElements.values,
          (i) => Database.i.characters.getItem(i.id)?.element.id ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Weapon',
          GeWeaponType.values,
          (i) => Database.i.characters.getItem(i.id)?.weapon.id ?? '',
        ),
      ],
    ),
    GsCharacterOutfit: GsConfigs<GsCharacterOutfit>._(
      title: 'Character Outfits',
      getDecor: (item) {
        final char = Database.i.characters.getItem(item.character);
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
    GsCity: GsConfigs<GsCity>._(
      title: 'Cities',
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: '',
        color: item.element.color,
        regionColor: GsStyle.getRegionElementColor(item.id),
      ),
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
          GeMaterialCategory.values,
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
        color: item.type.color,
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
          GeAchievementType.values,
          (i) => i.type.toString(),
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
    GsRemarkableChest: GsConfigs<GsRemarkableChest>._(
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
          'Category',
          GeRmChestCategory.values,
          (i) => i.category.id,
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeSereniteaSets.values,
          (i) => i.type.id,
        ),
      ],
    ),
    GsSerenitea: GsConfigs<GsSerenitea>._(
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
          GeSereniteaSets.values,
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
          GeItemSource.values,
          (i) => i.source.id,
        ),
        GsFieldFilter.fromEnum(
          'Stat Type',
          GeWeaponAscensionStatType.values,
          (i) => i.statType.id,
        ),
      ],
    ),
    GsWeaponInfo: GsConfigs<GsWeaponInfo>._(
      title: 'Weapon Info',
      getDecor: (item) {
        final weapon = Database.i.weapons.getItem(item.id);
        return GsItemDecor(
          label: weapon?.name ?? item.id,
          image: weapon?.image,
          version: weapon?.version ?? '',
          color: GsStyle.getRarityColor(weapon?.rarity ?? 0),
        );
      },
      filters: [
        GsFieldFilter.fromFilter(
          'Version',
          GsItemFilter.versions(),
          (i) => Database.i.weapons.getItem(i.id)?.version ?? '',
        ),
        GsFieldFilter.fromFilter(
          'Rarity',
          GsItemFilter.rarities(),
          (i) => Database.i.weapons.getItem(i.id)?.rarity.toString() ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Type',
          GeWeaponType.values,
          (i) => Database.i.weapons.getItem(i.id)?.type.id ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Source',
          GeItemSource.values,
          (i) => Database.i.weapons.getItem(i.id)?.source.id ?? '',
        ),
        GsFieldFilter.fromEnum(
          'Stat Type',
          GeWeaponAscensionStatType.values,
          (i) => Database.i.weapons.getItem(i.id)?.statType.id ?? '',
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
    final version = collection.data
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
        list: () => collection.data,
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
      ),
    );
  }
}
