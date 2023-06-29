import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsAchievementCategory>> getAchievementCategoriesDfs(
  GsAchievementCategory? model,
) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) => GsValidators.validateId(
        item,
        model,
        Database.i.achievementCategories,
      ),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
      import: (item) async {
        final achv = await Importer.importAchievementsFromFandom(item);
        for (final entry in achv) {
          Database.i.achievements.updateItem(entry.id, entry);
        }
        return item;
      },
      importTooltip: 'Import from fandom URL',
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.textField(
      'Icon',
      (item) => item.icon,
      (item, value) => item.copyWith(icon: value),
      process: GsValidators.processImage,
      isValid: (item) => GsValidators.validateImage(item.icon),
    ),
    DataField.singleSelect(
      'Namecard',
      (item) => item.namecard,
      (item) => GsSelectItems.namecards,
      (item, value) => item.copyWith(namecard: value),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
  ];
}
