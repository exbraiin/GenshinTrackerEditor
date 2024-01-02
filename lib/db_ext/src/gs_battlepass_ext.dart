import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsBattlepassExt extends GsModelExt<GsBattlepass> {
  const GsBattlepassExt();

  @override
  List<DataField<GsBattlepass>> getFields(String? editId) {
    final ids = Database.i.of<GsBattlepass>().ids;
    final versions = GsItemFilter.versions().ids;
    final namecards = GsItemFilter.namecards(GeNamecardType.battlepass).ids;

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, editId, ids),
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
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.singleSelect(
        'Namecard Id',
        (item) => item.namecardId,
        (item) => GsItemFilter.namecards(
          GeNamecardType.battlepass,
          item.namecardId,
        ).filters,
        (item, value) => item.copyWith(namecardId: value),
        validator: (item) {
          if (item.namecardId == '') return GsValidLevel.warn2;
          return vdContains(item.namecardId, namecards);
        },
      ),
      DataField.dateTime(
        'Date Start',
        (item) => item.dateStart,
        (item, value) => item.copyWith(dateStart: value),
        validator: (item) => vdDates(item.dateStart, item.dateEnd),
      ),
      DataField.dateTime(
        'Date End',
        (item) => item.dateEnd,
        (item, value) => item.copyWith(dateEnd: value),
        validator: (item) => vdDates(item.dateStart, item.dateEnd),
      ),
    ];
  }
}
