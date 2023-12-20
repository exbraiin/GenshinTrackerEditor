import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/style/utils.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsCharacterInfoExt extends GsModelExt<GsCharacterInfo> {
  const GsCharacterInfoExt();

  @override
  List<DataField<GsCharacterInfo>> getFields(GsCharacterInfo? model) {
    const catGem = GeMaterialType.ascensionGems;
    final matGem = GsItemFilter.matGroups(catGem).ids;
    const catBss = GeMaterialType.normalBossDrops;
    final matBss = GsItemFilter.matGroups(catBss).ids;
    final matMob = GsItemFilter.matGroups(
      GeMaterialType.normalDrops,
      GeMaterialType.eliteDrops,
    ).ids;
    const catWeek = GeMaterialType.weeklyBossDrops;
    final matWeek = GsItemFilter.matGroups(catWeek).ids;
    final matWithRegion = Database.i
        .of<GsMaterial>()
        .items
        .map((e) => MapEntry(e.id, e.region))
        .toMap();
    final chrWithRegion = Database.i
        .of<GsCharacter>()
        .items
        .map((e) => MapEntry(e.id, e.region))
        .toMap();

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
        (item) => GsItemFilter.matGroups(GeMaterialType.ascensionGems).filters,
        (item, value) => item.copyWith(gemMaterial: value),
        validator: (item) => vdContains(item.gemMaterial, matGem),
      ),
      DataField.singleSelect(
        'Material Boss',
        (item) => item.bossMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.normalBossDrops).filters,
        (item, value) => item.copyWith(bossMaterial: value),
        validator: (item) => vdContains(item.bossMaterial, matBss),
      ),
      DataField.singleSelect(
        'Material Common',
        (item) => item.commonMaterial,
        (item) => GsItemFilter.matGroups(
          GeMaterialType.normalDrops,
          GeMaterialType.eliteDrops,
        ).filters,
        (item, value) => item.copyWith(commonMaterial: value),
        validator: (item) => vdContains(item.commonMaterial, matMob),
      ),
      DataField.singleSelect(
        'Material Region',
        (item) => item.regionMaterial,
        (item) =>
            GsItemFilter.matGroups(GeMaterialType.regionMaterials).filters,
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
            GsItemFilter.matGroups(GeMaterialType.talentMaterials).filters,
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
            GsItemFilter.matGroups(GeMaterialType.weeklyBossDrops).filters,
        (item, value) => item.copyWith(weeklyMaterial: value),
        validator: (item) => vdContains(item.weeklyMaterial, matWeek),
      ),
      DataField.singleEnum(
        'Ascension Stat',
        GeCharacterAscStatType.values.toChips(),
        (item) => item.ascStatType,
        (item, value) => item.copyWith(ascStatType: value),
        validator: (item) => vdContains(
          item.ascStatType,
          GeCharacterAscStatType.values,
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
      DataField.build<GsCharacterInfo, GsCharTalent>(
        'Talents',
        (item) => item.talents,
        (item) => GsItemFilter.talents().filters,
        (item, child) => DataField<GsCharTalent>.list(
          child.id,
          (tal) => [
            DataField.textField(
              'Name',
              (item) => tal.name,
              (item, value) => item.copyWith(name: value),
              validator: (item) => vdText(item.name),
            ),
            DataField.textImage(
              'Icon',
              (item) => tal.icon,
              (item, value) => item.copyWith(icon: value),
              validator: (item) => vdImage(item.icon),
            ),
            DataField.textEditor(
              'Desc',
              (item) => tal.desc,
              (item, value) => item.copyWith(desc: value),
              validator: (item) => vdText(item.desc),
            ),
          ],
        ),
        (item, value) {
          final list = value.map((id) {
            final type = GeCharTalentType.values.fromId(id);
            final old = item.talents.firstOrNullWhere((e) => type == e.type);
            return old ??
                GsCharTalent.fromJson({}).copyWith(id: type.id, type: type);
          }).sortedBy((e) => GeCharTalentType.values.indexOf(e.type));
          return item.copyWith(talents: list);
        },
        (item, field) {
          final list = item.talents.toList();
          final idx = list.indexWhere((e) => e.id == field.id);
          if (idx != -1) list[idx] = field;
          return item.copyWith(talents: list);
        },
      ),
      DataField.build<GsCharacterInfo, GsCharConstellation>(
        'Constellations',
        (item) => item.constellations,
        (item) => GsItemFilter.constellations().filters,
        (item, child) => DataField.list(
          child.id,
          (con) => [
            DataField.textField(
              'Name',
              (item) => con.name,
              (item, value) => item.copyWith(name: value),
              validator: (item) => vdText(con.name),
            ),
            DataField.textImage(
              'Icon',
              (item) => con.icon,
              (item, value) => item.copyWith(icon: value),
              validator: (item) => vdImage(con.icon),
            ),
            DataField.textEditor(
              'Desc',
              (item) => con.desc,
              (item, value) => item.copyWith(desc: value),
              validator: (item) => vdText(con.desc),
            ),
          ],
        ),
        (item, value) {
          final list = value.map((id) {
            final t = GeCharConstellationType.values.fromId(id);
            final o = item.constellations.firstOrNullWhere((i) => t == i.type);
            return o ??
                GsCharConstellation.fromJson({}).copyWith(id: t.id, type: t);
          }).sortedBy((e) => e.id);
          return item.copyWith(constellations: list);
        },
        (item, field) {
          final list = item.constellations.toList();
          final idx = list.indexWhere((e) => e.id == field.id);
          if (idx != -1) list[idx] = field;
          return item.copyWith(constellations: list);
        },
      ),
    ];
  }

  GsValidLevel _vdCharAsc(String value) {
    if (value.isEmpty) return GsValidLevel.warn1;
    if (value.split(',').length != 8) return GsValidLevel.warn2;
    return GsValidLevel.good;
  }
}
