import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsAchievement>> getAchievementsDfs(GsAchievement? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) =>
          GsValidators.validateId(item, model, Database.i.achievements),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => GsValidators.validateText(item.name),
    ),
    DataField.textField(
      'Desc',
      (item) => item.desc,
      (item, value) => item.copyWith(desc: value),
      isValid: (item) => GsValidators.validateText(item.desc),
    ),
    DataField.singleSelect(
      'Group',
      (item) => item.group,
      (item) => GsSelectItems.achievementGroups,
      (item, value) => item.copyWith(group: value),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsSelectItems.achievementTypes,
      (item, value) => item.copyWith(type: value),
    ),
    DataField.text(
      'Hidden',
      (item) => item.hidden ? 'Yes' : 'No',
      swap: (item) => item.copyWith(hidden: !item.hidden),
    ),
    DataField.textField(
      'Reward',
      (item) => item.reward.toString(),
      (item, value) => item.copyWith(reward: int.tryParse(value) ?? 0),
      process: (value) => (int.tryParse(value) ?? 0).toString(),
      isValid: (item) =>
          item.reward > 0 ? GsValidLevel.good : GsValidLevel.warn1,
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
  ];
}
