import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsAchievementGroupExt extends GsModelExt<GsAchievementGroup> {
  const GsAchievementGroupExt();

  @override
  List<DataField<GsAchievementGroup>> getFields(String? editId) {
    final namecardId = editId != null
        ? Database.i.of<GsAchievementGroup>().getItem(editId)?.namecard
        : '';
    final vd = ValidateModels<GsAchievementGroup>();
    final vdVersion = ValidateModels.versions();
    final vdNamecard = ValidateModels.namecards(
      GeNamecardType.achievement,
      savedId: namecardId,
      allowNone: true,
    );

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
      DataField.textImage(
        'Icon',
        (item) => item.icon,
        (item, value) => item.copyWith(icon: value),
      ),
      DataField.intField(
        'Order',
        (item) => item.order,
        (item, value) => item.copyWith(order: value),
        range: (1, null),
      ),
      DataField.singleSelect(
        'Namecard',
        (item) => item.namecard,
        (item) => vdNamecard.filters,
        (item, value) => item.copyWith(namecard: value),
        validator: (item) => vdNamecard.validate(item.namecard),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
    ];
  }
}
