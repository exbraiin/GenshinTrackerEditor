import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsEventExt extends GsModelExt<GsEvent> {
  const GsEventExt();

  @override
  List<DataField<GsEvent>> getFields(String? editId) {
    final vd = ValidateModels<GsEvent>();
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
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.singleEnum<GsEvent, GeEventType>(
        'Type',
        GeEventType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        invalid: [GeEventType.none],
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) {
          final dates = vdVersion.getDates(item.version);
          return item.copyWith(
            version: value,
            dateStart: dates?.$1,
            dateEnd: dates?.$2,
          );
        },
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.dateTime(
        'Date Start',
        (item) => item.dateStart,
        (item, value) => item.copyWith(dateStart: value),
        validator: (item) => vdVersion.validateDate(
          item.version,
          item.dateStart,
        ),
      ),
      DataField.dateTime(
        'Date End',
        (item) => item.dateEnd,
        (item, value) => item.copyWith(dateEnd: value),
        validator: (item) => vdVersion.validateDate(
          item.version,
          item.dateEnd,
        ),
      ),
    ];
  }
}
