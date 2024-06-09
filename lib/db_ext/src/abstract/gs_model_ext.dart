import 'package:dartx/dartx.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/utils.dart';
import 'package:gsdatabase/gsdatabase.dart'
    hide GsRecipeExt, GsSpincrystalExt, GsEnemyExt;

abstract class GsModelExt<T extends GsModel<T>> {
  const GsModelExt();

  List<DataField<T>> getFields(String? editId);

  GsValidLevel vdContains<E>(E value, Iterable<E> values) {
    return values.contains(value) ? GsValidLevel.good : GsValidLevel.warn3;
  }
}

String expectedId(GsModel item) {
  String bannerId(GsBanner item) {
    final date = item.dateStart.toString().split(' ').firstOrNull ?? '';
    return '${item.name}_${date.replaceAll('-', '_')}'.toDbId();
  }

  return switch (item) {
    final GsVersion item => item.id,
    final GsBanner item => bannerId(item),
    final GsEvent item => '${item.name}_${item.version}'.toDbId(),
    final GsAchievement item => '${item.group}_${item.name}'.toDbId(),
    final GsSpincrystal item => item.number.toString(),
    _ => (((item as dynamic)?.name as String?) ?? '').toDbId(),
  };
}
