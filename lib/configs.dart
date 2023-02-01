import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/screens/item_edit_screen.dart';
import 'package:data_editor/screens/items_list_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_item.dart';
import 'package:flutter/material.dart';

class GsConfigs<T extends GsModel> {
  final String title;
  final GsItemDecor Function(T item) getDecor;
  final GsCollection<T> collection;

  GsConfigs._({
    required this.title,
    required this.getDecor,
    required this.collection,
  });

  static List<GsConfigs> getAllConfigs() {
    return [
      GsConfigs<GsArtifact>._(
        title: 'Artifacts',
        collection: Database.i.artifacts,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
      ),
      GsConfigs<GsBanner>._(
        title: 'Banners',
        collection: Database.i.banners,
        getDecor: (item) => GsItemDecor(
          '${item.name}\n${item.dateStart}',
          item.version,
          GsStyle.getBannerColor(item.type),
        ),
      ),
      GsConfigs<GsCharacter>._(
        title: 'Characters',
        collection: Database.i.characters,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
      ),
      GsConfigs<GsCharacterInfo>._(
        title: 'Character Info',
        collection: Database.i.characterInfo,
        getDecor: (item) {
          final char = Database.i.characters.getItem(item.id);
          return GsItemDecor(
            char?.name ?? item.id,
            char?.version ?? '',
            GsStyle.getRarityColor(char?.rarity ?? 0),
          );
        },
      ),
      GsConfigs<GsCharacterOutfit>._(
        title: 'Character Outfits',
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
        collection: Database.i.characterOutfit,
      ),
      GsConfigs<GsCity>._(
        title: 'Cities',
        collection: Database.i.cities,
        getDecor: (item) => GsItemDecor(
          item.name,
          '',
          GsStyle.getElementColor(item.element),
        ),
      ),
      GsConfigs<GsIngredient>._(
        title: 'Ingredients',
        collection: Database.i.ingredients,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
      ),
      GsConfigs<GsMaterial>._(
        title: 'Materials',
        collection: Database.i.materials,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
          Text(
            '${item.subgroup}: ${item.group.toTitle()}',
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(color: Colors.black38),
          ),
        ),
      ),
      GsConfigs<GsNamecard>._(
        title: 'Namecards',
        collection: Database.i.namecards,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getNamecardColor(item.type),
        ),
      ),
      GsConfigs<GsRecipe>._(
        title: 'Recipes',
        collection: Database.i.recipes,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
      ),
      GsConfigs<GsRemarkableChest>._(
        title: 'Remarkable Chests',
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
        collection: Database.i.remarkableChests,
      ),
      GsConfigs<GsSerenitea>._(
        title: 'Sereniteas',
        collection: Database.i.sereniteas,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getSereniteaColor(item.category),
        ),
      ),
      GsConfigs<GsSpincrystal>._(
        title: 'Spincrystals',
        collection: Database.i.spincrystal,
        getDecor: (item) => GsItemDecor(
          '${item.number}',
          item.version,
          GsStyle.getRarityColor(5),
        ),
      ),
      GsConfigs<GsWeapon>._(
        title: 'Weapons',
        collection: Database.i.weapons,
        getDecor: (item) => GsItemDecor(
          item.name,
          item.version,
          GsStyle.getRarityColor(item.rarity),
        ),
      ),
      GsConfigs<GsWeaponInfo>._(
        title: 'Weapon Info',
        collection: Database.i.weaponInfo,
        getDecor: (item) {
          final weapon = Database.i.weapons.getItem(item.id);
          return GsItemDecor(
            weapon?.name ?? item.id,
            weapon?.version ?? '',
            GsStyle.getRarityColor(weapon?.rarity ?? 0),
          );
        },
      ),
      GsConfigs<GsVersion>._(
        title: 'Versions',
        collection: Database.i.versions,
        getDecor: (item) => GsItemDecor(
          item.id,
          item.id,
          GsStyle.getVersionColor(item.id),
        ),
      ),
    ];
  }

  GsGridItem toGridItem(BuildContext context) {
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
      onTap: () => context.pushWidget(() {
        return ItemsListScreen<T>(
          title: title,
          list: () => collection.data,
          getDecor: getDecor,
          validator: collection.validator,
          onTap: (context, item) => context.pushWidget(() {
            return ItemEditScreen<T>(
              item: item,
              title: title,
              collection: collection,
              fields: collection.validator.getDataFields(item),
            );
          }),
        );
      }),
    );
  }
}
