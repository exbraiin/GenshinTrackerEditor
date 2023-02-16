import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';

export 'gs_artifact_ext.dart';
export 'gs_banner_ext.dart';
export 'gs_character_ext.dart';
export 'gs_character_info_ext.dart';
export 'gs_character_outfit_ext.dart';
export 'gs_city_ext.dart';
export 'gs_ingredient_ext.dart';
export 'gs_material_ext.dart';
export 'gs_namecard_ext.dart';
export 'gs_recipe_ext.dart';
export 'gs_serenitea_ext.dart';
export 'gs_spincrystal_ext.dart';
export 'gs_version_ext.dart';
export 'gs_weapon_ext.dart';

extension StringExt on String {
  String toTitle() {
    final words = <String>[''];
    final chars = characters;
    for (var char in chars) {
      late final lastChar = words.last.characters.lastOrNull;
      late final isUpper = lastChar?.isCapitalized ?? false;
      if (char == '_' && !isUpper) {
        words.add('');
        continue;
      }
      if (char.isCapitalized && !isUpper) words.add('');
      words.last += char;
    }
    return words
        .where((e) => e.isNotEmpty)
        .map((e) => e.capitalize())
        .join(' ');
  }
}

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

String _toNameId(GsModel item) {
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

String processListOfStrings(String value) =>
    value.split(',').map((e) => e.trim()).where((e) => e.isNotBlank).join(', ');

String processImage(String value) {
  final idx = value.indexOf('/revision');
  if (idx != -1) return value.substring(0, idx);
  return value;
}

GsValidLevel validateId<T extends GsModel<T>>(T item, T? m, GsCollection<T> c) {
  final id = item.id;
  if (id.isEmpty) return GsValidLevel.error;
  final nameId = _toNameId(item);
  final ids = c.data.map((e) => e.id).where((e) => e != m?.id);
  final check = id != nameId ? GsValidLevel.warn1 : GsValidLevel.good;
  return !ids.contains(id) ? check : GsValidLevel.error;
}

GsValidLevel validateText(String name) {
  if (name.isEmpty) return GsValidLevel.warn1;
  if (name.trim() != name) return GsValidLevel.warn2;
  return GsValidLevel.good;
}

GsValidLevel validateImage(String image) {
  if (image.isEmpty) return GsValidLevel.warn2;
  if (image.trim() != image) return GsValidLevel.warn1;
  return GsValidLevel.good;
}

GsValidLevel validateDates(String start, String end) {
  final src = DateTime.tryParse(start);
  final dst = DateTime.tryParse(end);
  return src != null && dst != null && dst.isAfter(src)
      ? GsValidLevel.good
      : GsValidLevel.error;
}

GsValidLevel validateBday(String birthday) {
  final date = DateTime.tryParse(birthday);
  return date != null && date.year == 0
      ? GsValidLevel.good
      : GsValidLevel.error;
}

GsValidLevel validateAscension(String value) {
  if (value.isEmpty) return GsValidLevel.warn1;
  if (value.split(',').length != 8) return GsValidLevel.warn2;
  return GsValidLevel.good;
}
