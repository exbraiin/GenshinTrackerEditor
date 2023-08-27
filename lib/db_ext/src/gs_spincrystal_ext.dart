import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsSpincrystalExt extends GsModelExt<GsSpincrystal> {
  const GsSpincrystalExt();

  @override
  List<DataField<GsSpincrystal>> getFields(GsSpincrystal? model) {
    final ids = Database.i.spincrystal.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
    final versions = GsItemFilter.versions().ids;
    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: generateId(item)),
        ),
        validator: (item) => vdId(item, model, ids),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
        validator: (item) => vdText(item.name),
      ),
      DataField.textField(
        'Number',
        (item) => item.number.toString(),
        (item, value) => item.copyWith(number: int.tryParse(value) ?? 0),
        validator: (item) => vdNum(item.number, 1),
      ),
      DataField.textField(
        'Source',
        (item) => item.source,
        (item, value) => item.copyWith(source: value),
        validator: (item) => vdText(item.source),
      ),
      DataField.singleSelect(
        'Region',
        (item) => item.region,
        (item) => GsItemFilter.regions().filters,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region, regions),
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
