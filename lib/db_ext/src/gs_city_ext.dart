import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsRegionExt extends GsModelExt<GsRegion> {
  const GsRegionExt();

  @override
  List<DataField<GsRegion>> getFields(String? editId) {
    final ids = Database.i.of<GsRegion>().ids;
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
      DataField.textImage(
        'Image In-Game',
        (item) => item.imageInGame,
        (item, value) => item.copyWith(imageInGame: value),
        validator: (item) => vdImage(item.imageInGame),
      ),
      DataField.textField(
        'Archon',
        (item) => item.archon,
        (item, value) => item.copyWith(archon: value),
        validator: (item) => vdText(item.archon),
      ),
      DataField.textField(
        'Ideal',
        (item) => item.ideal,
        (item, value) => item.copyWith(ideal: value),
        validator: (item) => vdText(item.ideal),
      ),
      DataField.singleEnum(
        'Element',
        GeElementType.values.toChips(),
        (item) => item.element,
        (item, value) => item.copyWith(element: value),
        validator: (item) => vdContains(item.element, GeElementType.values),
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
