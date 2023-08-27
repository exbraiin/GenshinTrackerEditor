import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/utils.dart';

abstract class GsModelExt<T extends GsModel<T>> {
  static GsModelExt<R>? of<R extends GsModel<R>>() {
    return switch (R) {
      GsAchievement => const GsAchievementExt(),
      GsAchievementGroup => const GsAchievementGroupExt(),
      GsArtifact => const GsArtifactExt(),
      GsBanner => const GsBannerExt(),
      GsCharacter => const GsCharacterExt(),
      GsCharacterInfo => const GsCharacterInfoExt(),
      GsCharacterOutfit => const GsCharacterOutfitExt(),
      GsCity => const GsCityExt(),
      GsMaterial => const GsMaterialExt(),
      GsNamecard => const GsNamecardExt(),
      GsRecipe => const GsRecipeExt(),
      GsRemarkableChest => const GsRemarkableChestExt(),
      GsSerenitea => const GsSereniteaExt(),
      GsSpincrystal => const GsSpincrystalExt(),
      GsVersion => const GsVersionExt(),
      GsViewpoint => const GsViewpointExt(),
      GsWeapon => const GsWeaponExt(),
      GsWeaponInfo => const GsWeaponInfoExt(),
      _ => null,
    } as GsModelExt<R>?;
  }

  const GsModelExt();

  List<DataField<T>> getFields(T? model);
  GsValidator<T> getValidator() =>
      GsValidator(getFields(null).map((e) => e.validator));

  GsValidLevel vdId<E extends GsModel<E>>(
    E item,
    E? inDb,
    Iterable<String> ids,
  ) {
    inDb ??= item;
    final id = item.id;
    final expectedId = generateId(item);
    if (id.isEmpty) return GsValidLevel.error;
    final check = id != expectedId ? GsValidLevel.warn1 : GsValidLevel.good;
    final withoutSelf = ids.where((e) => e != inDb?.id);
    return !withoutSelf.contains(id) ? check : GsValidLevel.error;
  }

  GsValidLevel vdNum(num value, [num min = 0]) =>
      value >= min ? GsValidLevel.good : GsValidLevel.error;

  GsValidLevel vdText(
    String name, [
    GsValidLevel empty = GsValidLevel.warn1,
  ]) {
    if (name.isEmpty) return empty;
    if (name.trim() != name) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  GsValidLevel vdRarity(int rarity, [int min = 1]) {
    return rarity.between(min, 5) ? GsValidLevel.good : GsValidLevel.error;
  }

  GsValidLevel vdImage(
    String image, [
    GsValidLevel empty = GsValidLevel.warn2,
  ]) {
    if (image.isEmpty) return empty;
    if (image.trim() != image) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }

  GsValidLevel vdBirthday(String birthday) {
    final date = DateTime.tryParse(birthday);
    return date != null && date.year == 0
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel vdDate(String date) {
    if (date.isEmpty) return GsValidLevel.warn2;
    return DateTime.tryParse(date) == null
        ? GsValidLevel.error
        : GsValidLevel.none;
  }

  GsValidLevel vdDates(String start, String end) {
    final src = DateTime.tryParse(start);
    final dst = DateTime.tryParse(end);
    return src != null && dst != null && dst.isAfter(src)
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel vdContains<E>(E value, Iterable<E> values) {
    return values.contains(value) ? GsValidLevel.good : GsValidLevel.error;
  }
}

String generateId(GsModel item) {
  if (item is GsBanner) {
    return '${item.name}_${item.dateStart.replaceAll('-', '_')}'.toDbId();
  }
  if (item is GsAchievement) {
    return '${item.group}_${item.name}'.toDbId();
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
