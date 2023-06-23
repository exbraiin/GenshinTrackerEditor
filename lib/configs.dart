import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/screens/item_edit_screen.dart';
import 'package:data_editor/screens/items_list_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_item.dart';
import 'package:flutter/material.dart';

class GsConfigs<T extends GsModel<T>> {
  final String title;
  final GsItemDecor Function(T item) getDecor;
  final GsCollection<T> collection;

  GsConfigs._({
    required this.title,
    required this.getDecor,
    required this.collection,
  });

  static final _map = <Type, GsConfigs>{
    GsArtifact: GsConfigs<GsArtifact>._(
      title: 'Artifacts',
      collection: Database.i.artifacts,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.pieces.first.icon,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
    ),
    GsBanner: GsConfigs<GsBanner>._(
      title: 'Banners',
      collection: Database.i.banners,
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
          color: GsStyle.getBannerColor(item.type),
        );
      },
    ),
    GsCharacter: GsConfigs<GsCharacter>._(
      title: 'Characters',
      collection: Database.i.characters,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
    ),
    GsCharacterInfo: GsConfigs<GsCharacterInfo>._(
      title: 'Character Info',
      collection: Database.i.characterInfo,
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
      collection: Database.i.characterOutfit,
    ),
    GsCity: GsConfigs<GsCity>._(
      title: 'Cities',
      collection: Database.i.cities,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: '',
        color: GsStyle.getElementColor(item.element),
        regionColor: GsStyle.getRegionElementColor(item.id),
      ),
    ),
    GsIngredient: GsConfigs<GsIngredient>._(
      title: 'Ingredients',
      collection: Database.i.ingredients,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
      ),
    ),
    GsMaterial: GsConfigs<GsMaterial>._(
      title: 'Materials',
      collection: Database.i.materials,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
    ),
    GsNamecard: GsConfigs<GsNamecard>._(
      title: 'Namecards',
      collection: Database.i.namecards,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getNamecardColor(item.type),
      ),
    ),
    GsRecipe: GsConfigs<GsRecipe>._(
      title: 'Recipes',
      collection: Database.i.recipes,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
      ),
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
      collection: Database.i.remarkableChests,
    ),
    GsSerenitea: GsConfigs<GsSerenitea>._(
      title: 'Sereniteas',
      collection: Database.i.sereniteas,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getSereniteaColor(item.category),
      ),
    ),
    GsSpincrystal: GsConfigs<GsSpincrystal>._(
      title: 'Spincrystals',
      collection: Database.i.spincrystal,
      getDecor: (item) => GsItemDecor(
        label: '${item.number}',
        version: item.version,
        color: GsStyle.getRarityColor(5),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
    ),
    GsViewpoint: GsConfigs<GsViewpoint>._(
      title: 'Viewpoints',
      collection: Database.i.viewpoints,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        version: item.version,
        color: GsStyle.getRarityColor(4),
        regionColor: GsStyle.getRegionElementColor(item.region),
      ),
    ),
    GsWeapon: GsConfigs<GsWeapon>._(
      title: 'Weapons',
      collection: Database.i.weapons,
      getDecor: (item) => GsItemDecor(
        label: item.name,
        image: item.image,
        version: item.version,
        color: GsStyle.getRarityColor(item.rarity),
      ),
    ),
    GsWeaponInfo: GsConfigs<GsWeaponInfo>._(
      title: 'Weapon Info',
      collection: Database.i.weaponInfo,
      getDecor: (item) {
        final weapon = Database.i.weapons.getItem(item.id);
        return GsItemDecor(
          label: weapon?.name ?? item.id,
          image: weapon?.image,
          version: weapon?.version ?? '',
          color: GsStyle.getRarityColor(weapon?.rarity ?? 0),
        );
      },
    ),
    GsVersion: GsConfigs<GsVersion>._(
      title: 'Versions',
      collection: Database.i.versions,
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
    final level = collection.validator.getMaxLevel();
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
    context.pushWidget(() {
      return ItemsListScreen<T>(
        title: title,
        list: () => collection.data,
        getDecor: getDecor,
        validator: collection.validator,
        onTap: openEditScreen,
      );
    });
  }

  void openEditScreen(BuildContext context, T? item) {
    context.pushWidget(() {
      return ItemEditScreen<T>(
        item: item,
        title: title,
        collection: collection,
        fields: collection.validator.getDataFields(item),
      );
    });
  }
}
