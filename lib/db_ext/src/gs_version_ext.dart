import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsVersionExt extends GsModelExt<GsVersion> {
  const GsVersionExt();

  @override
  List<DataField<GsVersion>> getFields(String? editId) {
    final ids = Database.i.of<GsVersion>().ids;
    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, editId, ids),
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
      DataField.dateTime(
        'Release Date',
        (item) => item.releaseDate,
        (item, value) => item.copyWith(releaseDate: value),
        validator: (item) => vdDate(item.releaseDate),
      ),
    ];
  }
}
