import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsAchievementExt extends GsModelExt<GsAchievement> {
  const GsAchievementExt();

  @override
  List<DataField<GsAchievement>> getFields(String? editId) {
    final ids = Database.i.of<GsAchievement>().ids;
    final groups = GsItemFilter.achievementGroups().ids;
    final versions = GsItemFilter.versions().ids;
    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, editId, ids),
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
      DataField.singleSelect(
        'Group',
        (item) => item.group,
        (item) => GsItemFilter.achievementGroups().filters,
        (item, value) => item.copyWith(group: value),
        validator: (item) => vdContains(item.group, groups),
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
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
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
                validator: (item) => vdText(item.desc),
              ),
              DataField.textField(
                'Reward',
                (item) => item.reward.toString(),
                (item, value) =>
                    item.copyWith(reward: int.tryParse(value) ?? 0),
                validator: (item) => vdNum(item.reward, 1),
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
