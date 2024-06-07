import 'package:dartx/dartx.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/utils.dart';
import 'package:gsdatabase/gsdatabase.dart'
    hide GsRecipeExt, GsSpincrystalExt, GsEnemyExt;

abstract class GsModelExt<T extends GsModel<T>> {
  const GsModelExt();

  List<DataField<T>> getFields(String? editId);

  GsValidLevel vdId<E extends GsModel<E>>(
    E item,
    String? editId,
    Iterable<String> ids,
  ) {
    // We set the id if the given one is empty in order to validate all items.
    if (editId?.isEmpty ?? false) editId = item.id;
    final id = item.id;
    final expectedId = generateId(item);
    if (id.isEmpty) return GsValidLevel.error;
    final check = id != expectedId ? GsValidLevel.warn1 : GsValidLevel.good;
    final withoutSelf = ids.where((e) => e != editId);
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

  GsValidLevel vdBirthday(DateTime birthday) {
    return birthday.year == 0 ? GsValidLevel.good : GsValidLevel.error;
  }

  GsValidLevel vdDate(DateTime date) {
    final fallback = DateTime(0);
    if (date == fallback) return GsValidLevel.warn2;
    return GsValidLevel.none;
  }

  GsValidLevel vdDates(DateTime? src, DateTime? dst) {
    return src != null && dst != null && dst.isAfter(src)
        ? GsValidLevel.good
        : GsValidLevel.error;
  }

  GsValidLevel vdContains<E>(E value, Iterable<E> values) {
    return values.contains(value) ? GsValidLevel.good : GsValidLevel.error;
  }

  GsValidLevel vdContainsValidId(String e, Iterable<String> values) {
    if (e == '' || e == 'none') return GsValidLevel.warn2;
    return vdContains(e, values);
  }
}

String _dateAsId(DateTime date) {
  return (date.toString().split(' ').firstOrNull ?? '').replaceAll('-', '_');
}

String generateId(GsModel item) {
  if (item is GsBanner) {
    return '${item.name}_${_dateAsId(item.dateStart)}'.toDbId();
  }
  if (item is GsAchievement) {
    return '${item.group}_${item.name}'.toDbId();
  }
  if (item is GsSpincrystal) {
    return item.number.toString();
  }
  if (item is GsEvent) {
    return '${item.name}_${item.version}'.toDbId();
  }
  if (item is GsVersion) {
    return item.id;
  }

  final name = ((item as dynamic)?.name as String?) ?? '';
  return name.toDbId();
}
