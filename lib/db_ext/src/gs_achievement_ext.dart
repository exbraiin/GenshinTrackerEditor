import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsAchievement>> getAchievementsDfs(GsAchievement? model) {
  final validator = DataValidator.i.getValidator<GsAchievement>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) => item.copyWith(id: generateId(item)),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.singleSelect(
      'Group',
      (item) => item.group,
      (item) => GsItemFilter.achievementGroups().filters,
      (item, value) => item.copyWith(group: value),
      validate: (item) => validator.validateEntry('group', item, model),
    ),
    DataField.singleSelect(
      'Type',
      (item) => item.type,
      (item) => GsItemFilter.achievementTypes().filters,
      (item, value) => item.copyWith(type: value),
      validate: (item) => validator.validateEntry('type', item, model),
    ),
    DataField.text(
      'Hidden',
      (item) => item.hidden ? 'Yes' : 'No',
      swap: (item) => item.copyWith(hidden: !item.hidden),
      validate: (item) => validator.validateEntry('hidden', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.buildList<GsAchievement, GsAchievementPhase>(
      'Phases',
      (item) => item.phases,
      (idx, a, child) => DataField.list(
        '#$idx',
        (item) {
          return [
            DataField.textField(
              'Desc',
              (item) => item.desc,
              (item, value) => item.copyWith(desc: value),
              validate: (e) => validator.validateEntry('phases', a, model),
            ),
            DataField.textField(
              'Reward',
              (item) => item.reward.toString(),
              (item, value) => item.copyWith(reward: int.tryParse(value) ?? 0),
              validate: (e) => validator.validateEntry('phases', a, model),
            ),
          ];
        },
      ),
      () => GsAchievementPhase.fromMap({}),
      (item, list) => item.copyWith(phases: list),
    ),
  ];
}
