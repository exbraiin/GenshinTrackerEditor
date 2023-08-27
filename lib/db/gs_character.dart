import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsCharacter extends GsModel<GsCharacter> {
  @override
  final String id;
  final String enkaId;
  final String name;
  final String title;
  final int rarity;
  final String region;
  final GeWeaponType weapon;
  final GeElements element;
  final String version;
  final GeItemSource source;
  final String description;
  final String constellation;
  final String affiliation;
  final GeCharacterModelType modelType;
  final String specialDish;
  final String birthday;
  final String releaseDate;
  final String image;
  final String sideImage;
  final String fullImage;
  final String constellationImage;

  GsCharacter({
    this.id = '',
    this.enkaId = '',
    this.name = '',
    this.rarity = 1,
    this.title = '',
    this.region = '',
    this.weapon = GeWeaponType.bow,
    this.element = GeElements.anemo,
    this.version = '',
    this.source = GeItemSource.event,
    this.description = '',
    this.constellation = '',
    this.affiliation = '',
    this.modelType = GeCharacterModelType.shortFemale,
    this.specialDish = '',
    this.birthday = '',
    this.releaseDate = '',
    this.image = '',
    this.sideImage = '',
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
        weapon = GeWeaponType.values.fromId(m.getString('weapon')),
        element = GeElements.values.fromId(m.getString('element')),
        version = m.getString('version'),
        source = GeItemSource.values.fromId(m.getString('source')),
        description = m.getString('description'),
        constellation = m.getString('constellation'),
        affiliation = m.getString('affiliation'),
        modelType =
            GeCharacterModelType.values.fromId(m.getString('model_type')),
        specialDish = m.getString('special_dish'),
        birthday = m.getString('birthday'),
        releaseDate = m.getString('release_date'),
        image = m.getString('image'),
        sideImage = m.getString('side_image'),
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
    GeWeaponType? weapon,
    GeElements? element,
    String? version,
    GeItemSource? source,
    String? description,
    String? constellation,
    GeCharacterModelType? modelType,
    String? affiliation,
    String? specialDish,
    String? birthday,
    String? releaseDate,
    String? image,
    String? sideImage,
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
      sideImage: sideImage ?? this.sideImage,
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
        'weapon': weapon.id,
        'element': element.id,
        'version': version,
        'source': source.id,
        'description': description,
        'constellation': constellation,
        'model_type': modelType.id,
        'affiliation': affiliation,
        'special_dish': specialDish,
        'birthday': birthday,
        'release_date': releaseDate,
        'image': image,
        'side_image': sideImage,
        'full_image': fullImage,
        'constellation_image': constellationImage,
      };
}
