import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsSpincrystalExt extends GsModelExt<GsSpincrystal> {
  const GsSpincrystalExt();

  @override
  List<DataField<GsSpincrystal>> getFields(String? editId) {
    final vd = ValidateModels<GsSpincrystal>();
    final vdVersion = ValidateModels.versions();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: expectedId(item)),
        ),
        validator: (item) => vd.validateItemId(item, editId),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.intField(
        'Number',
        (item) => item.number,
        (item, value) => item.copyWith(number: value),
        range: (1, null),
      ),
      DataField.textField(
        'Source',
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
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
