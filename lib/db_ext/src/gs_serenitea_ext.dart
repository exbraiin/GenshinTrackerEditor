import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';

class GsSereniteaExt extends GsModelExt<GsSerenitea> {
  const GsSereniteaExt();

  @override
  List<DataField<GsSerenitea>> getFields(GsSerenitea? model) {
    final ids = Database.i.sereniteas.data.map((e) => e.id);
    final chars = GsItemFilter.wishes(null, GeBannerType.character).ids;
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
      DataField.singleEnum<GsSerenitea, GeSereniteaSets>(
        'Category',
        GeSereniteaSets.values.toChips(),
        (item) => item.category,
        (item, value) => item.copyWith(category: value),
        validator: (item) =>
            vdContains(item.category, GeSereniteaSets.values),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.textField(
        'Energy',
        (item) => item.energy.toString(),
        (item, value) => item.copyWith(energy: int.tryParse(value) ?? -1),
        validator: (item) => vdNum(item.energy, 1),
      ),
      DataField.multiSelect<GsSerenitea, String>(
        'Chars',
        (item) => item.chars,
        (item) => GsItemFilter.wishes(null, GeBannerType.character).filters,
        (item, value) => item.copyWith(chars: value),
        validator: (item) => item.chars.isEmpty
            ? GsValidLevel.warn2
            : (chars.containsAll(item.chars)
                ? GsValidLevel.good
                : GsValidLevel.error),
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
