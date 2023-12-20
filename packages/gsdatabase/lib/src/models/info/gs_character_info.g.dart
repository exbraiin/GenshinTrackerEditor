// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_character_info.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsCharacterInfo extends GsModel<GsCharacterInfo> {
  @override
  final String id;
  final String gemMaterial;
  final String bossMaterial;
  final String commonMaterial;
  final String regionMaterial;
  final String talentMaterial;
  final String weeklyMaterial;
  final GeCharacterAscStatType ascStatType;
  final String ascHpValues;
  final String ascAtkValues;
  final String ascDefValues;
  final String ascStatValues;
  final List<GsCharTalent> talents;
  final List<GsCharConstellation> constellations;

  /// Creates a new [GsCharacterInfo] instance.
  GsCharacterInfo({
    required this.id,
    required this.gemMaterial,
    required this.bossMaterial,
    required this.commonMaterial,
    required this.regionMaterial,
    required this.talentMaterial,
    required this.weeklyMaterial,
    required this.ascStatType,
    required this.ascHpValues,
    required this.ascAtkValues,
    required this.ascDefValues,
    required this.ascStatValues,
    required this.talents,
    required this.constellations,
  });

  /// Creates a new [GsCharacterInfo] instance from the given map.
  GsCharacterInfo.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        gemMaterial = m['mat_gem'] as String? ?? '',
        bossMaterial = m['mat_boss'] as String? ?? '',
        commonMaterial = m['mat_common'] as String? ?? '',
        regionMaterial = m['mat_region'] as String? ?? '',
        talentMaterial = m['mat_talent'] as String? ?? '',
        weeklyMaterial = m['mat_weekly'] as String? ?? '',
        ascStatType = GeCharacterAscStatType.values.fromId(m['asc_stat_type']),
        ascHpValues = m['asc_hp_values'] as String? ?? '',
        ascAtkValues = m['asc_atk_values'] as String? ?? '',
        ascDefValues = m['asc_def_values'] as String? ?? '',
        ascStatValues = m['asc_stat_values'] as String? ?? '',
        talents = (m['talents'] as List? ?? const [])
            .map((e) => GsCharTalent.fromJson(e))
            .toList(),
        constellations = (m['constellations'] as List? ?? const [])
            .map((e) => GsCharConstellation.fromJson(e))
            .toList();

  /// Copies this model with the given parameters.
  @override
  GsCharacterInfo copyWith({
    String? id,
    String? gemMaterial,
    String? bossMaterial,
    String? commonMaterial,
    String? regionMaterial,
    String? talentMaterial,
    String? weeklyMaterial,
    GeCharacterAscStatType? ascStatType,
    String? ascHpValues,
    String? ascAtkValues,
    String? ascDefValues,
    String? ascStatValues,
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
      ascStatType: ascStatType ?? this.ascStatType,
      ascHpValues: ascHpValues ?? this.ascHpValues,
      ascAtkValues: ascAtkValues ?? this.ascAtkValues,
      ascDefValues: ascDefValues ?? this.ascDefValues,
      ascStatValues: ascStatValues ?? this.ascStatValues,
      talents: talents ?? this.talents,
      constellations: constellations ?? this.constellations,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
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
      'talents': talents.map((e) => e.toMap()).toList(),
      'constellations': constellations.map((e) => e.toMap()).toList(),
    };
  }
}

class GsCharTalent extends GsModel<GsCharTalent> {
  @override
  final String id;
  final String name;
  final GeCharTalentType type;
  final String icon;
  final String desc;

  /// Creates a new [GsCharTalent] instance.
  GsCharTalent({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.desc,
  });

  /// Creates a new [GsCharTalent] instance from the given map.
  GsCharTalent.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        type = GeCharTalentType.values.fromId(m['type']),
        icon = m['icon'] as String? ?? '',
        desc = m['desc'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsCharTalent copyWith({
    String? id,
    String? name,
    GeCharTalentType? type,
    String? icon,
    String? desc,
  }) {
    return GsCharTalent(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.id,
      'icon': icon,
      'desc': desc,
    };
  }
}

class GsCharConstellation extends GsModel<GsCharConstellation> {
  @override
  final String id;
  final String name;
  final String icon;
  final String desc;
  final GeCharConstellationType type;

  /// Creates a new [GsCharConstellation] instance.
  GsCharConstellation({
    required this.id,
    required this.name,
    required this.icon,
    required this.desc,
    required this.type,
  });

  /// Creates a new [GsCharConstellation] instance from the given map.
  GsCharConstellation.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        icon = m['icon'] as String? ?? '',
        desc = m['desc'] as String? ?? '',
        type = GeCharConstellationType.values.fromId(m['type']);

  /// Copies this model with the given parameters.
  @override
  GsCharConstellation copyWith({
    String? id,
    String? name,
    String? icon,
    String? desc,
    GeCharConstellationType? type,
  }) {
    return GsCharConstellation(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
      type: type ?? this.type,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'desc': desc,
      'type': type.id,
    };
  }
}
