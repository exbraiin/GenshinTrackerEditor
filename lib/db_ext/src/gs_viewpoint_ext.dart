import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsViewpointExt extends GsModelExt<GsViewpoint> {
  const GsViewpointExt();

  @override
  List<DataField<GsViewpoint>> getFields(GsViewpoint? model) {
    final ids = Database.i.viewpoints.data.map((e) => e.id);
    final regions = GsItemFilter.regions().ids;
    final versions = GsItemFilter.versions().ids;
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
      DataField.textField(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
        validator: (item) => vdText(item.desc),
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
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
    ];
  }
}
