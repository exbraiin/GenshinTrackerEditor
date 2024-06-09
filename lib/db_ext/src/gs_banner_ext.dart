import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsBannerExt extends GsModelExt<GsBanner> {
  const GsBannerExt();

  @override
  List<DataField<GsBanner>> getFields(String? editId) {
    final vd = ValidateModels<GsBanner>();
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
      DataField.dateTime(
        'Date Start',
        (item) => item.dateStart,
        (item, value) => item.copyWith(dateStart: value),
        validator: (item) => vdVersion.validateDates(
          item.version,
          item.dateStart,
          item.type.isPermanent ? null : item.dateEnd,
        ),
      ),
      DataField.dateTime(
        'Date End',
        (item) => item.dateEnd,
        (item, value) => item.copyWith(dateEnd: value),
        validator: (item) => vdVersion.validateDates(
          item.version,
          item.dateStart,
          item.type.isPermanent ? null : item.dateEnd,
        ),
      ),
      DataField.multiSelect<GsBanner, String>(
        'Feature 4',
        (item) => item.feature4,
        (item) => GsItemFilter.wishes(4, item.type).filters,
        (item, value) => item.copyWith(feature4: value),
        validator: (item) => !item.type.isPermanent && item.feature4.isEmpty
            ? GsValidLevel.warn2
            : GsValidLevel.good,
      ),
      DataField.multiSelect<GsBanner, String>(
        'Feature 5',
        (item) => item.feature5,
        (item) => GsItemFilter.wishes(5, item.type).filters,
        (item, value) => item.copyWith(feature5: value),
        validator: (item) => !item.type.isPermanent && item.feature5.isEmpty
            ? GsValidLevel.warn2
            : GsValidLevel.good,
      ),
      DataField.singleEnum<GsBanner, GeBannerType>(
        'Type',
        GeBannerType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
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
