import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/style/utils.dart';

class GsCharacterInfoExt extends GsModelExt<GsCharacterInfo> {
  const GsCharacterInfoExt();

  @override
  List<DataField<GsCharacterInfo>> getFields(GsCharacterInfo? model) {
    const catGem = GeMaterialCategory.ascensionGems;
    final matGem = GsItemFilter.matGroups(catGem).ids;
    const catBss = GeMaterialCategory.normalBossDrops;
    final matBss = GsItemFilter.matGroups(catBss).ids;
    final matMob = GsItemFilter.matGroups(
      GeMaterialCategory.normalDrops,
      GeMaterialCategory.eliteDrops,
    ).ids;
    const catWeek = GeMaterialCategory.weeklyBossDrops;
    final matWeek = GsItemFilter.matGroups(catWeek).ids;
    final matWithRegion =
        Database.i.materials.data.map((e) => MapEntry(e.id, e.region)).toMap();
    final chrWithRegion =
        Database.i.characters.data.map((e) => MapEntry(e.id, e.region)).toMap();

    return [
      model != null
          ? DataField.text(
              'ID',
              (item) => item.id,
            )
          : DataField.singleSelect(
              'ID',
              (item) => item.id,
              (item) => GsItemFilter.charsWithoutInfo().filters,
              (item, value) => item.copyWith(id: value),
              validator: (item) =>
                  item.id.isEmpty ? GsValidLevel.error : GsValidLevel.good,
            ),
      DataField.singleSelect(
        'Material Gem',
        (item) => item.gemMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialCategory.ascensionGems).filters,
        (item, value) => item.copyWith(gemMaterial: value),
        validator: (item) => vdContains(item.gemMaterial, matGem),
      ),
      DataField.singleSelect(
        'Material Boss',
        (item) => item.bossMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialCategory.normalBossDrops).filters,
        (item, value) => item.copyWith(bossMaterial: value),
        validator: (item) => vdContains(item.bossMaterial, matBss),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.commonMaterial,
        (item) => GsItemFilter.matGroups(
          GeMaterialCategory.normalDrops,
          GeMaterialCategory.eliteDrops,
        ).filters,
        (item, value) => item.copyWith(commonMaterial: value),
        validator: (item) => vdContains(item.commonMaterial, matMob),
      ),
      DataField.singleSelect(
        'Material Region',
        (item) => item.regionMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialCategory.regionMaterials).filters,
        (item, value) => item.copyWith(regionMaterial: value),
        validator: (item) {
          if (item.regionMaterial.isEmpty) return GsValidLevel.error;
          final chrRegion = chrWithRegion[item.id];
          final matRegion = matWithRegion[item.regionMaterial];
          if (chrRegion == null || matRegion == null) return GsValidLevel.error;
          if (matRegion != chrRegion) return GsValidLevel.warn1;
          return GsValidLevel.good;
        },
      ),
      DataField.singleSelect(
        'Material Talent',
        (item) => item.talentMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialCategory.talentMaterials).filters,
        (item, value) => item.copyWith(talentMaterial: value),
        validator: (item) {
          if (item.talentMaterial.isEmpty) return GsValidLevel.error;
          final chrRegion = chrWithRegion[item.id];
          final matRegion = matWithRegion[item.talentMaterial];
          if (chrRegion == null || matRegion == null) return GsValidLevel.error;
          if (matRegion != chrRegion) return GsValidLevel.warn1;
          return GsValidLevel.good;
        },
      ),
      DataField.singleSelect(
        'Material Weekly',
        (item) => item.weeklyMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialCategory.weeklyBossDrops).filters,
        (item, value) => item.copyWith(weeklyMaterial: value),
        validator: (item) => vdContains(item.weeklyMaterial, matWeek),
      ),
      DataField.singleEnum(
        'Ascension Stat',
        GeCharacterAscensionStatType.values.toChips(),
        (item) => item.ascStatType,
        (item, value) => item.copyWith(ascStatType: value),
        validator: (item) => vdContains(
          item.ascStatType,
          GeCharacterAscensionStatType.values,
        ),
      ),
      DataField.textList(
        'Ascension HP Values',
        (item) => item.ascHpValues,
        (item, value) => item.copyWith(ascHpValues: value),
        validator: (item) => _vdCharAsc(item.ascHpValues),
      ),
      DataField.textList(
        'Ascension Atk Values',
        (item) => item.ascAtkValues,
        (item, value) => item.copyWith(ascAtkValues: value),
        validator: (item) => _vdCharAsc(item.ascAtkValues),
      ),
      DataField.textList(
        'Ascension Def Values',
        (item) => item.ascDefValues,
        (item, value) => item.copyWith(ascDefValues: value),
        validator: (item) => _vdCharAsc(item.ascDefValues),
      ),
      DataField.textList(
        'Ascension Stat Values',
        (item) => item.ascStatValues,
        (item, value) => item.copyWith(ascStatValues: value),
        validator: (item) => _vdCharAsc(item.ascStatValues),
      ),
      DataField.list(
        'Talents',
        (item) => item.talents.mapIndexed((idx, tal) {
          return DataField.list(
            tal.type,
            (item) => [
              DataField.textField(
                'Name',
                (item) => tal.name,
                (item, value) {
                  final list = item.talents.toList();
                  list[idx] = item.talents[idx].copyWith(name: value);
                  return item.copyWith(talents: list);
                },
                validator: (item) => _vdTalentText(tal),
              ),
              DataField.textImage(
                'Icon',
                (item) => tal.icon,
                (item, value) {
                  final list = item.talents.toList();
                  list[idx] = item.talents[idx].copyWith(icon: value);
                  return item.copyWith(talents: list);
                },
                validator: (item) => _vdTalentText(tal),
              ),
              DataField.textEditor(
                'Desc',
                (item) => tal.desc,
                (item, value) {
                  final list = item.talents.toList();
                  list[idx] = item.talents[idx].copyWith(desc: value);
                  return item.copyWith(talents: list);
                },
                validator: (item) => _vdTalentText(tal),
              ),
            ],
          );
        }),
      ),
      DataField.list(
        'Constellations',
        (item) => item.constellations.mapIndexed((idx, con) {
          return DataField.list(
            'C${idx + 1}',
            (item) => [
              DataField.textField(
                'Name',
                (item) => con.name,
                (item, value) {
                  final list = item.constellations.toList();
                  list[idx] = list[idx].copyWith(name: value);
                  return item.copyWith(constellations: list);
                },
                validator: (item) => vdText(con.name, GsValidLevel.warn2),
              ),
              DataField.textImage(
                'Icon',
                (item) => con.icon,
                (item, value) {
                  final list = item.constellations.toList();
                  list[idx] = list[idx].copyWith(icon: value);
                  return item.copyWith(constellations: list);
                },
                validator: (item) => vdImage(con.icon),
              ),
              DataField.textEditor(
                'Desc',
                (item) => con.desc,
                (item, value) {
                  final list = item.constellations.toList();
                  list[idx] = list[idx].copyWith(desc: value);
                  return item.copyWith(constellations: list);
                },
                validator: (item) => vdText(con.desc, GsValidLevel.warn2),
              ),
            ],
          );
        }),
      ),
    ];
  }

  GsValidLevel _vdTalentText(GsCharTalent item) {
    return vdText(
      item.desc,
      item.type == 'Alternate Sprint' ? GsValidLevel.warn1 : GsValidLevel.warn2,
    );
  }

  GsValidLevel _vdCharAsc(String value) {
    if (value.isEmpty) return GsValidLevel.warn1;
    if (value.split(',').length != 8) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }
}
