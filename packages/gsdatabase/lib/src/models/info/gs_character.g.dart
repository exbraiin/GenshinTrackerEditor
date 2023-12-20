// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_character.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsCharacter extends GsModel<GsCharacter> {
  @override
  final String id;
  final String enkaId;
  final String name;
  final String title;
  final int rarity;
  final GeRegionType region;
  final GeWeaponType weapon;
  final GeElementType element;
  final String version;
  final GeItemSourceType source;
  final String description;
  final String constellation;
  final String affiliation;
  final String specialDish;
  final DateTime birthday;
  final DateTime releaseDate;
  final String image;
  final String sideImage;
  final String fullImage;
  final String constellationImage;

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
        constellationImage = m['constellation_image'] as String? ?? '';

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
      'birthday':
          '${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}',
      'release_date':
          '${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}',
      'image': image,
      'side_image': sideImage,
      'full_image': fullImage,
      'constellation_image': constellationImage,
    };
  }
}
