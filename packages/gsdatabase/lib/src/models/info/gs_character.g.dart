// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_character.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsCharacter extends GsModel<GsCharacter> with _GsCharacter {
  @override
  final String id;
  @override
  final String enkaId;
  @override
  final String name;
  @override
  final String title;
  @override
  final int rarity;
  @override
  final GeRegionType region;
  @override
  final GeWeaponType weapon;
  @override
  final GeElementType element;
  @override
  final String version;
  @override
  final GeItemSourceType source;
  @override
  final String description;
  @override
  final String constellation;
  @override
  final String affiliation;
  @override
  final String specialDish;
  @override
  final DateTime birthday;
  @override
  final DateTime releaseDate;
  @override
  final String image;
  @override
  final String sideImage;
  @override
  final String fullImage;
  @override
  final String constellationImage;
  @override
  final String gemMaterial;
  @override
  final String bossMaterial;
  @override
  final String commonMaterial;
  @override
  final String regionMaterial;
  @override
  final String talentMaterial;
  @override
  final String weeklyMaterial;
  @override
  final GeCharacterAscStatType ascStatType;
  @override
  final String ascHpValues;
  @override
  final String ascAtkValues;
  @override
  final String ascDefValues;
  @override
  final String ascStatValues;
  @override
  final List<GsCharTalent> talents;
  @override
  final List<GsCharConstellation> constellations;

  /// Creates a new [GsCharacter] instance.
  GsCharacter({
    required this.id,
    required this.enkaId,
    required this.name,
    required this.title,
    required this.rarity,
    required this.region,
    required this.weapon,
    required this.element,
    required this.version,
    required this.source,
    required this.description,
    required this.constellation,
    required this.affiliation,
    required this.specialDish,
    required this.birthday,
    required this.releaseDate,
    required this.image,
    required this.sideImage,
    required this.fullImage,
    required this.constellationImage,
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

  /// Creates a new [GsCharacter] instance from the given map.
  GsCharacter.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        enkaId = m['enka_id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        title = m['title'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        region = GeRegionType.values.fromId(m['region']),
        weapon = GeWeaponType.values.fromId(m['weapon']),
        element = GeElementType.values.fromId(m['element']),
        version = m['version'] as String? ?? '',
        source = GeItemSourceType.values.fromId(m['source']),
        description = m['description'] as String? ?? '',
        constellation = m['constellation'] as String? ?? '',
        affiliation = m['affiliation'] as String? ?? '',
        specialDish = m['special_dish'] as String? ?? '',
        birthday = DateTime.tryParse(m['birthday'].toString()) ?? DateTime(0),
        releaseDate =
            DateTime.tryParse(m['release_date'].toString()) ?? DateTime(0),
        image = m['image'] as String? ?? '',
        sideImage = m['side_image'] as String? ?? '',
        fullImage = m['full_image'] as String? ?? '',
        constellationImage = m['constellation_image'] as String? ?? '',
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
  GsCharacter copyWith({
    String? id,
    String? enkaId,
    String? name,
    String? title,
    int? rarity,
    GeRegionType? region,
    GeWeaponType? weapon,
    GeElementType? element,
    String? version,
    GeItemSourceType? source,
    String? description,
    String? constellation,
    String? affiliation,
    String? specialDish,
    DateTime? birthday,
    DateTime? releaseDate,
    String? image,
    String? sideImage,
    String? fullImage,
    String? constellationImage,
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
    return GsCharacter(
      id: id ?? this.id,
      enkaId: enkaId ?? this.enkaId,
      name: name ?? this.name,
      title: title ?? this.title,
      rarity: rarity ?? this.rarity,
      region: region ?? this.region,
      weapon: weapon ?? this.weapon,
      element: element ?? this.element,
      version: version ?? this.version,
      source: source ?? this.source,
      description: description ?? this.description,
      constellation: constellation ?? this.constellation,
      affiliation: affiliation ?? this.affiliation,
      specialDish: specialDish ?? this.specialDish,
      birthday: birthday ?? this.birthday,
      releaseDate: releaseDate ?? this.releaseDate,
      image: image ?? this.image,
      sideImage: sideImage ?? this.sideImage,
      fullImage: fullImage ?? this.fullImage,
      constellationImage: constellationImage ?? this.constellationImage,
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
      'enka_id': enkaId,
      'name': name,
      'title': title,
      'rarity': rarity,
      'region': region.id,
      'weapon': weapon.id,
      'element': element.id,
      'version': version,
      'source': source.id,
      'description': description,
      'constellation': constellation,
      'affiliation': affiliation,
      'special_dish': specialDish,
      'birthday': birthday.toString(),
      'release_date': releaseDate.toString(),
      'image': image,
      'side_image': sideImage,
      'full_image': fullImage,
      'constellation_image': constellationImage,
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

class GsCharTalent extends GsModel<GsCharTalent> with _GsCharTalent {
  @override
  final String id;
  @override
  final String name;
  @override
  final GeCharTalentType type;
  @override
  final String icon;
  @override
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

class GsCharConstellation extends GsModel<GsCharConstellation>
    with _GsCharConstellation {
  @override
  final String id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final String desc;
  @override
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
