import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsBanner>> getBannerDfs(GsBanner? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.banners),
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
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      process: GsValidators.processImage,
    ),
    DataField.textField(
      'Date Start',
      (item) => item.dateStart,
      (item, value) => item.copyWith(dateStart: value),
      isValid: (item) =>
          GsValidators.validateDates(item.dateStart, item.dateEnd),
    ),
    DataField.textField(
      'Date End',
      (item) => item.dateEnd,
      (item, value) => item.copyWith(dateEnd: value),
      isValid: (item) =>
          GsValidators.validateDates(item.dateStart, item.dateEnd),
    ),
    DataField.multiSelect<GsBanner, String>(
      'Feature 4',
      (item) => item.feature4,
      (item) => GsSelectItems.getWishes(4, item.type),
      (item, value) => item.copyWith(feature4: value),
      isValid: (item) {
        final validType = item.type != 'standard' && item.type != 'beginner';
        if (validType && item.feature4.isEmpty) return GsValidLevel.warn2;
        return GsValidLevel.good;
      },
    ),
    DataField.multiSelect<GsBanner, String>(
      'Feature 5',
      (item) => item.feature5,
      (item) => GsSelectItems.getWishes(5, item.type),
      (item, value) => item.copyWith(feature5: value),
      isValid: (item) {
        final validType = item.type != 'standard' && item.type != 'beginner';
        if (validType && item.feature5.isEmpty) return GsValidLevel.warn2;
        return GsValidLevel.good;
      },
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsSelectItems.bannerTypes,
      (item, value) => item.copyWith(type: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
  ];
}
