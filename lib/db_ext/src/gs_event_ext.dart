import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsEventExt extends GsModelExt<GsEvent> {
  const GsEventExt();

  @override
  List<DataField<GsEvent>> getFields(String? editId) {
    DateTime? date;
    final ids = Database.i.of<GsEvent>().ids;
    final types = GsItemFilter.eventType().ids;
    final versions = GsItemFilter.versions().ids;
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
      DataField.singleEnum<GsEvent, GeEventType>(
        'Type',
        GeEventType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        validator: (item) => vdContains(item.type.id, types),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) {
          if (item.version != value) {
            date = Database.i.of<GsVersion>().getItem(value)?.releaseDate;
          }
          return item.copyWith(version: value, dateStart: date, dateEnd: date);
        },
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.dateTime(
        'Date Start',
        (item) => item.dateStart,
        (item, value) => item.copyWith(dateStart: value),
        validator: (item) {
          if (item.dateStart.year == 0) return GsValidLevel.warn2;
          return date != null && item.dateStart.isBefore(date!)
              ? GsValidLevel.warn2
              : vdDatesOrder(item.dateStart, item.dateEnd);
        },
      ),
      DataField.dateTime(
        'Date End',
        (item) => item.dateEnd,
        (item, value) => item.copyWith(dateEnd: value),
        validator: (item) {
          if (item.dateEnd.year == 0) return GsValidLevel.warn2;
          return date != null && item.dateStart.isBefore(date!)
              ? GsValidLevel.warn2
              : vdDatesOrder(item.dateStart, item.dateEnd);
        },
      ),
    ];
  }
}
