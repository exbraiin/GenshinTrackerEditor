import 'package:data_editor/db/database.dart';

class GsCharacter extends GsModel<GsCharacter> {
  @override
  final String id;
  final String enkaId;
  final String name;
  final String title;
  final int rarity;
  final String region;
  final String weapon;
  final String element;
  final String version;
  final String source;
  final String description;
  final String constellation;
  final String affiliation;
  final String modelType;
  final String specialDish;
  final String birthday;
  final String releaseDate;
  final String image;
  final String fullImage;
  final String constellationImage;

  GsCharacter({
    this.id = '',
    this.enkaId = '',
    this.name = '',
    this.rarity = 1,
    this.title = '',
    this.region = '',
    this.weapon = '',
    this.element = '',
    this.version = '',
    this.source = '',
    this.description = '',
    this.constellation = '',
    this.affiliation = '',
    this.modelType = '',
    this.specialDish = '',
    this.birthday = '',
    this.releaseDate = '',
    this.image = '',
    this.fullImage = '',
    this.constellationImage = '',
  });

  GsCharacter.fromMap(JsonMap m)
      : id = m.getString('id'),
        enkaId = m.getString('enka_id'),
        name = m.getString('name'),
        rarity = m.getInt('rarity', 1),
        title = m.getString('title'),
        region = m.getString('region'),
        weapon = m.getString('weapon'),
        element = m.getString('element'),
        version = m.getString('version'),
        source = m.getString('source'),
        description = m.getString('description'),
        constellation = m.getString('constellation'),
        affiliation = m.getString('affiliation'),
        modelType = m.getString('model_type'),
        specialDish = m.getString('special_dish'),
        birthday = m.getString('birthday'),
        releaseDate = m.getString('release_date'),
        image = m.getString('image'),
        fullImage = m.getString('full_image'),
        constellationImage = m.getString('constellation_image');

  @override
  GsCharacter copyWith({
    String? id,
    String? enkaId,
    String? name,
    String? title,
    int? rarity,
    String? region,
    String? weapon,
    String? element,
    String? version,
    String? source,
    String? description,
    String? constellation,
    String? modelType,
    String? affiliation,
    String? specialDish,
    String? birthday,
    String? releaseDate,
    String? image,
    String? fullImage,
    String? constellationImage,
  }) {
    return GsCharacter(
      id: id ?? this.id,
      enkaId: enkaId ?? this.enkaId,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      title: title ?? this.title,
      region: region ?? this.region,
      weapon: weapon ?? this.weapon,
      element: element ?? this.element,
      version: version ?? this.version,
      source: source ?? this.source,
      description: description ?? this.description,
      constellation: constellation ?? this.constellation,
      modelType: modelType ?? this.modelType,
      affiliation: affiliation ?? this.affiliation,
      specialDish: specialDish ?? this.specialDish,
      birthday: birthday ?? this.birthday,
      releaseDate: releaseDate ?? this.releaseDate,
      image: image ?? this.image,
      fullImage: fullImage ?? this.fullImage,
      constellationImage: constellationImage ?? this.constellationImage,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'enka_id': enkaId,
        'rarity': rarity,
        'title': title,
        'region': region,
        'weapon': weapon,
        'element': element,
        'version': version,
        'source': source,
        'description': description,
        'constellation': constellation,
        'model_type': modelType,
        'affiliation': affiliation,
        'special_dish': specialDish,
        'birthday': birthday,
        'release_date': releaseDate,
        'image': image,
        'full_image': fullImage,
        'constellation_image': constellationImage,
      };
}
