import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsAchievementExt extends GsModelExt<GsAchievement> {
  const GsAchievementExt();

  @override
  List<DataField<GsAchievement>> getFields(String? editId) {
    final vd = ValidateModels<GsAchievement>();
    final vdVersion = ValidateModels.versions();
    final vdAchievementGroups = ValidateModels<GsAchievementGroup>();

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
      DataField.singleSelect(
        'Group',
        (item) => item.group,
        (item) => vdAchievementGroups.filters,
        (item, value) => item.copyWith(group: value),
        validator: (item) => vdAchievementGroups.validate(item.group),
      ),
      DataField.singleEnum<GsAchievement, GeAchievementType>(
        'Type',
        GeAchievementType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
      ),
      DataField.text(
        'Hidden',
        (item) => item.hidden ? 'Yes' : 'No',
        swap: (item) => item.copyWith(hidden: !item.hidden),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
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
              ),
              DataField.intField(
                'Reward',
                (item) => item.reward,
                (item, value) => item.copyWith(reward: value),
                range: (1, null),
              ),
            ];
          },
        ),
        () => GsAchievementPhase.fromJson({}),
        (item, list) => item.copyWith(phases: list),
      ),
    ];
  }
}
