import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsSerenitea>> getSereniteaDfs(GsSerenitea? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.sereniteas),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.singleSelect(
      'Category',
      (item) => item.category,
      (item) => GsSelectItems.sereniteas,
      (item, value) => item.copyWith(category: value),
    ),
    DataField.textField(
      'Image',
      (item) => item.image,
      (item, value) => item.copyWith(image: value),
      process: GsValidators.processImage,
    ),
    DataField.textField(
      'Energy',
      (item) => item.energy.toString(),
      (item, value) => item.copyWith(energy: int.tryParse(value) ?? -1),
      isValid: (item) =>
          item.energy >= 0 ? GsValidLevel.good : GsValidLevel.error,
    ),
    DataField.multiSelect<GsSerenitea, String>(
      'Chars',
      (item) => item.chars,
      (item) => GsSelectItems.getWishes(null, 'character'),
      (item, value) => item.copyWith(chars: value),
      isValid: (item) => item.chars.isEmpty
          ? GsValidLevel.warn2
          : (Database.i
                  .getAllWishes(null, 'character')
                  .map((e) => e.id)
                  .containsAll(item.chars)
              ? GsValidLevel.good
              : GsValidLevel.error),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
  ];
}
