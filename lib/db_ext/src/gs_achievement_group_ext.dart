import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsAchievementGroup>> getAchievementGroupsDfs(
  GsAchievementGroup? model,
) {
  final validator = DataValidator.i.getValidator<GsAchievementGroup>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
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
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.textField(
      'Icon',
      (item) => item.icon,
      (item, value) => item.copyWith(icon: value),
      process: GsDataParser.processImage,
      validate: (item) => validator.validateEntry('icon', item, model),
    ),
    DataField.singleSelect(
      'Namecard',
      (item) => item.namecard,
      (item) => GsItemFilter.achievementNamecards().items,
      (item, value) => item.copyWith(namecard: value),
      validate: (item) => validator.validateEntry('namecard', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().items,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
  ];
}
