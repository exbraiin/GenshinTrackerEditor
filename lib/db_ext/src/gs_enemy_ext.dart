import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsEnemyExt extends GsModelExt<GsEnemy> {
  const GsEnemyExt();

  @override
  List<DataField<GsEnemy>> getFields(String? editId) {
    final vd = ValidateModels<GsEnemy>();
    final vdVersion = ValidateModels.versions();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vd.validateItemId(item, editId),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: expectedId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.textField(
        'Title',
        (item) => item.title,
        (item, value) => item.copyWith(title: value),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.textImage(
        'Full Image',
        (item) => item.fullImage,
        (item, value) => item.copyWith(fullImage: value),
      ),
      DataField.textImage(
        'Splash Image',
        (item) => item.splashImage,
        (item, value) => item.copyWith(splashImage: value),
        emptyLevel: GsValidLevel.warn1,
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.intField(
        'Order',
        (item) => item.order,
        (item, value) => item.copyWith(order: value),
        range: (1, null),
        refresh: DataButton(
          'Next Order in Family',
          (context, item) {
            final lastOrder = Database.i
                .of<GsEnemy>()
                .items
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
      ),
      DataField.singleEnum(
        'Family',
        GeEnemyFamilyType.values.toChips(),
        (item) => item.family,
        (item, value) => item.copyWith(family: value),
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
