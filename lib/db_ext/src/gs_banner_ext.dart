import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsBanner>> getBannerDfs(GsBanner? model) {
  final validator = DataValidator.i.getValidator<GsBanner>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) {
        final nameId = item.name.toDbId();
        final dateId = item.dateStart.replaceAll('-', '_');
        final id = '${nameId}_$dateId';
        return item.copyWith(id: id);
      },
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.textImage(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      validate: (item) => validator.validateEntry('image', item, model),
    ),
    DataField.textField(
      'Date Start',
      (item) => item.dateStart,
      (item, value) => item.copyWith(dateStart: value),
      validate: (item) => validator.validateEntry('date_start', item, model),
    ),
    DataField.textField(
      'Date End',
      (item) => item.dateEnd,
      (item, value) => item.copyWith(dateEnd: value),
      validate: (item) => validator.validateEntry('date_end', item, model),
    ),
    DataField.multiSelect<GsBanner, String>(
      'Feature 4',
      (item) => item.feature4,
      (item) => GsItemFilter.wishes(4, item.type).filters,
      (item, value) => item.copyWith(feature4: value),
      validate: (item) => validator.validateEntry('feature_4', item, model),
    ),
    DataField.multiSelect<GsBanner, String>(
      'Feature 5',
      (item) => item.feature5,
      (item) => GsItemFilter.wishes(5, item.type).filters,
      (item, value) => item.copyWith(feature5: value),
      validate: (item) => validator.validateEntry('feature_5', item, model),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsItemFilter.bannerTypes().filters,
      (item, value) => item.copyWith(type: value),
      validate: (item) => validator.validateEntry('type', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
  ];
}
