import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';

typedef It = Iterable<GsSelectItem<String>>;

class GsSelectItems {
  GsSelectItems._();

  static It get versions => Database.i
      .getVersions()
      .map((e) => GsSelectItem(e, e, color: GsStyle.getVersionColor(e)));

  static It get regions =>
      Database.i.getRegions().map((e) => _fromElement(e.id, e.name, e.element));

  static It get elements =>
      GsConfigurations.elements.map((e) => _fromElement(e, e.toTitle(), e));

  static It get ingredients => Database.i.ingredients.data
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It get bannerTypes => GsConfigurations.bannerTypes
      .map((e) => _fromBannerType(e, e.toTitle(), e));

  static It get baseRecipes => Database.i
      .getAllBaseRecipes()
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It get recipeEffects => GsConfigurations.recipeEffect.map((e) {
        final icon = GsGraphics.getRecipeEffectIcon(e);
        return GsSelectItem(e, e.toTitle(), icon: icon);
      });

  static It get sereniteas => GsConfigurations.sereniteaType
      .map((e) => _fromSetCategory(e, e.toTitle(), e));

  static It get nonBaseRecipes => Database.i
      .getAllNonBaseRecipes()
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It get namecardTypes => GsConfigurations.namecardTypes
      .map((e) => _fromNamecardType(e, e.toTitle(), e));

  static It get chars => Database.i.characters.data
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It get charsWithoutInfo => Database.i.characters.data
      .where((e) => Database.i.characterInfo.getItem(e.id) == null)
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It get weaponsWithoutInfo => Database.i.weapons.data
      .where((e) => Database.i.weaponInfo.getItem(e.id) == null)
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It getFromList(List<String> items, {bool withNone = false}) => [
        if (withNone) GsSelectItem('', 'None'),
        ...items.map((e) => GsSelectItem(e, e.toTitle())),
      ];

  static It getMaterialGroupWithRarity(String type) => Database.i
      .getMaterialGroup(type)
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It getMaterialGroupWithRegion(String type) =>
      Database.i.getMaterialGroup(type).map(_fromMatRegion);

  static It getMaterialGroupsWithRarity(List<String> types) => Database.i
      .getMaterialGroups(types)
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static It getMaterialGroupsWithRegion(List<String> types) =>
      Database.i.getMaterialGroups(types).map(_fromMatRegion);

  static It getWishes(int? rarity, String? type) => Database.i
      .getAllWishes(rarity, type)
      .sortedBy((e) => e.name)
      .map((e) => _fromRarity(e.id, e.name, e.rarity));

  static GsSelectItem<String> _fromMatRegion(GsMaterial mat) {
    final element = Database.i.getMaterialRegion(mat).element;
    return _fromElement(mat.id, mat.name, element);
  }

  static GsSelectItem<String> _fromRarity(String v, String l, int r) =>
      GsSelectItem(v, l, color: GsStyle.getRarityColor(r));

  static GsSelectItem<String> _fromElement(String v, String l, String e) =>
      GsSelectItem(v, l, color: GsStyle.getElementColor(e));

  static GsSelectItem<String> _fromBannerType(String v, String l, String t) =>
      GsSelectItem(v, l, color: GsStyle.getBannerColor(t));

  static GsSelectItem<String> _fromNamecardType(String v, String l, String t) =>
      GsSelectItem(v, l, color: GsStyle.getNamecardColor(t));

  static GsSelectItem<String> _fromSetCategory(String v, String l, String c) =>
      GsSelectItem(v, l, color: GsStyle.getSereniteaColor(c));
}

class GsValidators {
  GsValidators._();

  static String _toNameId(GsModel item) {
    if (item is GsBanner) {
      return '${item.name}_${item.dateStart.replaceAll('-', '_')}'.toDbId();
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

  static String processListOfStrings(String value) => value
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotBlank)
      .join(', ');

  static String processImage(String value) {
    final idx = value.indexOf('/revision');
    if (idx != -1) return value.substring(0, idx);
    return value;
  }

  static GsValidLevel validateId<T extends GsModel<T>>(
    T item,
    T? model,
    GsCollection<T> collection,
  ) {
    final id = item.id;
    if (id.isEmpty) return GsValidLevel.error;
    final nameId = _toNameId(item);
    final ids = collection.data.map((e) => e.id).where((e) => e != model?.id);
    final check = id != nameId ? GsValidLevel.warn1 : GsValidLevel.good;
    return !ids.contains(id) ? check : GsValidLevel.error;
  }

  static GsValidLevel validateText(
    String name, [
    GsValidLevel emptyLevel = GsValidLevel.warn1,
  ]) {
    if (name.isEmpty) return emptyLevel;
    if (name.trim() != name) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  static GsValidLevel validateImage(String image) {
    if (image.isEmpty) return GsValidLevel.warn2;
    if (image.trim() != image) return GsValidLevel.warn1;
    return GsValidLevel.good;
  }

  static GsValidLevel validateDates(String start, String end) {
    final src = DateTime.tryParse(start);
    final dst = DateTime.tryParse(end);
    return src != null && dst != null && dst.isAfter(src)
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  static GsValidLevel validateBday(String birthday) {
    final date = DateTime.tryParse(birthday);
    return date != null && date.year == 0
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  static GsValidLevel validateAscension(String value) {
    if (value.isEmpty) return GsValidLevel.warn1;
    if (value.split(',').length != 8) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }
}
