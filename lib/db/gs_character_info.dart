import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsCharacterInfo extends GsModel<GsCharacterInfo> {
  @override
  final String id;
  final String gemMaterial;
  final String bossMaterial;
  final String commonMaterial;
  final String regionMaterial;
  final String talentMaterial;
  final String weeklyMaterial;
  final GeCharacterAscensionStatType ascStatType;
  final String ascHpValues;
  final String ascAtkValues;
  final String ascDefValues;
  final String ascStatValues;
  final List<GsCharTalent> talents;
  final List<GsCharConstellation> constellations;

  GsCharacterInfo({
    this.id = '',
    this.gemMaterial = '',
    this.bossMaterial = '',
    this.commonMaterial = '',
    this.regionMaterial = '',
    this.talentMaterial = '',
    this.weeklyMaterial = '',
    this.ascHpValues = '',
    this.ascAtkValues = '',
    this.ascDefValues = '',
    this.ascStatValues = '',
    this.ascStatType = GeCharacterAscensionStatType.hpPercent,
    this.talents = const [],
    this.constellations = const [],
  });

  GsCharacterInfo.fromMap(JsonMap m)
      : id = m.getString('id'),
        gemMaterial = m.getString('mat_gem'),
        bossMaterial = m.getString('mat_boss'),
        commonMaterial = m.getString('mat_common'),
        regionMaterial = m.getString('mat_region'),
        talentMaterial = m.getString('mat_talent'),
        weeklyMaterial = m.getString('mat_weekly'),
        ascStatType = GeCharacterAscensionStatType.values
            .fromId(m.getString('asc_stat_type')),
        ascHpValues = m.getString('asc_hp_values'),
        ascAtkValues = m.getString('asc_atk_values'),
        ascDefValues = m.getString('asc_def_values'),
        ascStatValues = m.getString('asc_stat_values'),
        talents = m.getListOf('talents', GsCharTalent.fromMap),
        constellations =
            m.getListOf('constellations', GsCharConstellation.fromMap);

  @override
  GsCharacterInfo copyWith({
    String? id,
    String? gemMaterial,
    String? bossMaterial,
    String? commonMaterial,
    String? regionMaterial,
    String? talentMaterial,
    String? weeklyMaterial,
    String? ascHpValues,
    String? ascAtkValues,
    String? ascDefValues,
    String? ascStatValues,
    GeCharacterAscensionStatType? ascStatType,
    List<GsCharTalent>? talents,
    List<GsCharConstellation>? constellations,
  }) {
    return GsCharacterInfo(
      id: id ?? this.id,
      gemMaterial: gemMaterial ?? this.gemMaterial,
      bossMaterial: bossMaterial ?? this.bossMaterial,
      commonMaterial: commonMaterial ?? this.commonMaterial,
      regionMaterial: regionMaterial ?? this.regionMaterial,
      talentMaterial: talentMaterial ?? this.talentMaterial,
      weeklyMaterial: weeklyMaterial ?? this.weeklyMaterial,
      ascHpValues: ascHpValues ?? this.ascHpValues,
      ascAtkValues: ascAtkValues ?? this.ascAtkValues,
      ascDefValues: ascDefValues ?? this.ascDefValues,
      ascStatValues: ascStatValues ?? this.ascStatValues,
      ascStatType: ascStatType ?? this.ascStatType,
      talents: talents ?? this.talents,
      constellations: constellations ?? this.constellations,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'mat_gem': gemMaterial,
        'mat_boss': bossMaterial,
        'mat_common': commonMaterial,
        'mat_region': regionMaterial,
        'mat_talent': talentMaterial,
        'mat_weekly': weeklyMaterial,
        'asc_stat_type': ascStatType.id,
        'asc_hp_values': ascHpValues,
        'asc_atk_values': ascAtkValues,
        'asc_def_values': ascDefValues,
        'asc_stat_values': ascStatValues,
        'talents': talents
            .where((e) => e.name.isNotEmpty)
            .map((e) => e.toJsonMap())
            .toList(),
        'constellations': constellations.map((e) => e.toJsonMap()).toList(),
      };
}

class GsCharTalent extends GsModel<GsCharTalent> {
  @override
  String get id => type.id;
  final String name;
  final GeCharacterTalentType type;
  final String icon;
  final String desc;

  GsCharTalent({
    this.name = '',
    this.type = GeCharacterTalentType.normalAttack,
    this.icon = '',
    this.desc = '',
  });

  GsCharTalent.fromMap(JsonMap m)
      : name = m.getString('name'),
        type = GeCharacterTalentType.values.fromId(m.getString('type')),
        icon = m.getString('icon'),
        desc = m.getString('desc');

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'type': type.id,
        'icon': icon,
        'desc': desc,
      };

  @override
  GsCharTalent copyWith({
    String? name,
    GeCharacterTalentType? type,
    String? icon,
    String? desc,
  }) {
    return GsCharTalent(
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
    );
  }
}

class GsCharConstellation extends GsModel<GsCharConstellation> {
  @override
  String get id => type.id;
  final String name;
  final String icon;
  final String desc;
  final GeCharacterConstellationType type;

  GsCharConstellation({
    this.name = '',
    this.icon = '',
    this.desc = '',
    this.type = GeCharacterConstellationType.c1,
  });

  @override
  GsCharConstellation copyWith({
    String? name,
    String? icon,
    String? desc,
    GeCharacterConstellationType? type,
  }) {
    return GsCharConstellation(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
      type: type ?? this.type,
    );
  }

  GsCharConstellation.fromMap(JsonMap m)
      : name = m.getString('name'),
        icon = m.getString('icon'),
        desc = m.getString('desc'),
        type = GeCharacterConstellationType.values.fromId(m.getString('type'));

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'icon': icon,
        'desc': desc,
        'type': type.id,
      };
}
