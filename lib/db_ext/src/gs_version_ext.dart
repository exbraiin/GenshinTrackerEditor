import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsVersionExt extends GsModelExt<GsVersion> {
  const GsVersionExt();

  @override
  List<DataField<GsVersion>> getFields(String? editId) {
    final vdVersion = ValidateModels.versions();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdVersion.validateItemId(item, editId),
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
      DataField.dateTime(
        'Release Date',
        (item) => item.releaseDate,
        (item, value) => item.copyWith(releaseDate: value),
        validator: (item) {
          if (vdVersion.ids.contains(item.id)) {
            return vdVersion.validateDates(item.id, item.releaseDate);
          }
          final last = vdVersion.ids.last;
          return vdVersion.validateDates(last, item.releaseDate);
        },
      ),
    ];
  }
}
