import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsCityExt extends GsModelExt<GsCity> {
  const GsCityExt();

  @override
  List<DataField<GsCity>> getFields(GsCity? model) {
    final ids = Database.i.cities.data.map((e) => e.id);
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
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.singleEnum(
        'Element',
        GeElements.values.toChips(),
        (item) => item.element,
        (item, value) => item.copyWith(element: value),
        validator: (item) => vdContains(item.element, GeElements.values),
      ),
      DataField.textList(
        'Reputation',
        (item) => item.reputation.join(', '),
        (item, value) {
          final r = value.split(',').map(int.tryParse).toList();
          if (r.any((element) => element == null)) r.clear();
          final tValue = r.whereNotNull().toList();
          return item.copyWith(reputation: tValue);
        },
        validator: (item) =>
            item.reputation.isEmpty ? GsValidLevel.warn2 : GsValidLevel.good,
      ),
    ];
  }
}
