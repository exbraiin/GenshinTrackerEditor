import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';

class GsCharacterInfo extends GsModel<GsCharacterInfo> {
  @override
  final String id;
  final String gemMaterial;
  final String bossMaterial;
  final String commonMaterial;
  final String regionMaterial;
  final String talentMaterial;
  final String weeklyMaterial;
  final String ascStatType;
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
    this.ascStatType = '',
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
        ascStatType = m.getString('asc_stat_type'),
        ascHpValues = m.getString('asc_hp_values'),
        ascAtkValues = m.getString('asc_atk_values'),
        ascDefValues = m.getString('asc_def_values'),
        ascStatValues = m.getString('asc_stat_values'),
        talents = _decodeTalents(m),
        constellations = _decodeConstellations(m);

  static List<GsCharTalent> _decodeTalents(JsonMap map) {
    final list = (map['talents'] as List? ?? [])
        .cast<JsonMap>()
        .map(GsCharTalent.fromMap)
        .toList();
    return GsConfigurations.talentTypes.map((e) {
      return list.firstWhere(
        (element) => element.type == e,
        orElse: () => GsCharTalent(type: e),
      );
    }).toList();
  }

  static List<GsCharConstellation> _decodeConstellations(JsonMap map) {
    final list = map['constellations'] as List?;
    if (list == null) {
      return List.generate(6, (idx) => GsCharConstellation());
    }
    return list.cast<JsonMap>().map(GsCharConstellation.fromMap).toList();
  }

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
    String? ascStatType,
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
        'asc_stat_type': ascStatType,
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
  String get id => type;
  final String name;
  final String type;
  final String icon;
  final String desc;

  GsCharTalent({
    this.name = '',
    this.type = '',
    this.icon = '',
    this.desc = '',
  });

  GsCharTalent.fromMap(JsonMap m)
      : name = m['name'] ?? '',
        type = m['type'] ?? '',
        icon = m['icon'] ?? '',
        desc = m['desc'] ?? '';

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'type': type,
        'icon': icon,
        'desc': desc,
      };

  @override
  GsCharTalent copyWith({
    String? name,
    String? type,
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
  final String id;
  final String name;
  final String icon;
  final String desc;

  GsCharConstellation({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.desc = '',
  });

  @override
  GsCharConstellation copyWith({
    String? id,
    String? name,
    String? icon,
    String? desc,
  }) {
    return GsCharConstellation(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
    );
  }

  GsCharConstellation.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        icon = m.getString('icon'),
        desc = m.getString('desc');

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'icon': icon,
        'desc': desc,
      };
}
