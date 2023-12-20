import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsAchievementGroupExt extends GsModelExt<GsAchievementGroup> {
  const GsAchievementGroupExt();

  @override
  List<DataField<GsAchievementGroup>> getFields(GsAchievementGroup? model) {
    final ids = Database.i.of<GsAchievementGroup>().ids;
    final versions = GsItemFilter.versions().ids;
    final namecards = GsItemFilter.achievementNamecards().ids;

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
      DataField.textImage(
        'Icon',
        (item) => item.icon,
        (item, value) => item.copyWith(icon: value),
        validator: (item) => vdImage(item.icon),
      ),
      DataField.textField(
        'Order',
        (item) => item.order.toString(),
        (item, value) => item.copyWith(order: int.tryParse(value) ?? -1),
        validator: (item) => vdNum(item.order, 1),
      ),
      DataField.singleSelect(
        'Namecard',
        (item) => item.namecard,
        (item) => GsItemFilter.achievementNamecards().filters,
        (item, value) => item.copyWith(namecard: value),
        validator: (item) => vdContains(item.namecard, namecards),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
    ];
  }
}
