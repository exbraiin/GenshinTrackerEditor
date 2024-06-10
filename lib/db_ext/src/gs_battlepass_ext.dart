import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsBattlepassExt extends GsModelExt<GsBattlepass> {
  const GsBattlepassExt();

  @override
  List<DataField<GsBattlepass>> getFields(String? editId) {
    final vd = ValidateModels<GsBattlepass>();
    final vdVersion = ValidateModels.versions();
    final vdNamecard = ValidateModels.namecards(GeNamecardType.battlepass);

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
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.singleSelect(
        'Namecard Id',
        (item) => item.namecardId,
        (item) {
          final db = Database.i.of<GsBattlepass>().getItem(item.id);
          return vdNamecard.filtersWithId(db?.namecardId);
        },
        (item, value) => item.copyWith(namecardId: value),
        validator: (item) => vdNamecard.validate(item.namecardId),
      ),
      DataField.dateTime(
        'Date Start',
        (item) => item.dateStart,
        (item, value) => item.copyWith(dateStart: value),
        validator: (item) => vdVersion.validateDates(
          item.version,
          item.dateStart,
          item.dateEnd,
        ),
      ),
      DataField.dateTime(
        'Date End',
        (item) => item.dateEnd,
        (item, value) => item.copyWith(dateEnd: value),
        validator: (item) => vdVersion.validateDates(
          item.version,
          item.dateStart,
          item.dateEnd,
        ),
      ),
    ];
  }
}
