import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsEnemyExt extends GsModelExt<GsEnemy> {
  const GsEnemyExt();

  @override
  List<DataField<GsEnemy>> getFields(GsEnemy? model) {
    final ids = Database.i.enemies.data.map((e) => e.id);
    final versions = GsItemFilter.versions().ids;
    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, model, ids),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: generateId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
        validator: (item) => vdText(item.name),
      ),
      DataField.textField(
        'Title',
        (item) => item.title,
        (item, value) => item.copyWith(title: value),
        validator: (item) => vdText(item.title),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.textImage(
        'Full Image',
        (item) => item.fullImage,
        (item, value) => item.copyWith(fullImage: value),
        validator: (item) => vdImage(item.fullImage),
      ),
      DataField.textImage(
        'Splash Image',
        (item) => item.splashImage,
        (item, value) => item.copyWith(splashImage: value),
        validator: (item) => vdImage(item.splashImage, GsValidLevel.warn1),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.textField(
        'Order',
        (item) => item.order.toString(),
        (item, value) => item.copyWith(order: int.tryParse(value) ?? -1),
        validator: (item) => vdNum(item.order, 1),
        refresh: DataButton(
          'Next Order in Family',
          (context, item) {
            final lastOrder = Database.i.enemies.data
                .where((element) => element.family == item.family)
                .sortedBy((element) => element.order)
                .lastOrNull
                ?.order;
            return item.copyWith(order: (lastOrder ?? 0) + 1);
          },
        ),
      ),
      DataField.singleEnum(
        'Type',
        GeEnemyType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        validator: (item) => vdContains(item.type, GeEnemyType.values),
      ),
      DataField.singleEnum(
        'Family',
        GeEnemyFamily.values.toChips(),
        (item) => item.family,
        (item, value) => item.copyWith(family: value),
        validator: (item) => vdContains(item.family, GeEnemyFamily.values),
      ),
      DataField.multiSelect<GsEnemy, String>(
        'Drops',
        (item) => item.drops,
        (item) => GsItemFilter.drops(null, item.type).filters,
        (item, value) => item.copyWith(drops: value),
        validator: (item) => GsValidLevel.good,
      ),
    ];
  }
}
