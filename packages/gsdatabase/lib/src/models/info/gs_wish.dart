import 'package:gsdatabase/src/models/gs_model.dart';
import 'package:gsdatabase/src/models/info/gs_character.dart';
import 'package:gsdatabase/src/models/info/gs_weapon.dart';

class GsWish extends GsModel<GsWish> {
  final bool featured;
  final GsWeapon? weapon;
  final GsCharacter? character;

  @override
  String get id => weapon?.id ?? character?.id ?? '';
  String get name => weapon?.name ?? character?.name ?? '';
  String get image => weapon?.image ?? character?.image ?? '';
  int get rarity => weapon?.rarity ?? character?.rarity ?? 1;

  bool get isWeapon => weapon != null;
  bool get isCharacter => character != null;

  GsWish._({
    this.weapon,
    this.character,
    this.featured = false,
  });

  GsWish.fromWeapon(this.weapon)
      : character = null,
        featured = false;

  GsWish.fromCharacter(this.character)
      : weapon = null,
        featured = false;

  @override
  JsonMap toMap() => weapon?.toMap() ?? character?.toMap() ?? {};

  @override
  GsWish copyWith({bool? featured}) => GsWish._(
        weapon: weapon,
        character: character,
        featured: featured ?? this.featured,
      );

  @override
  Iterable<Comparable Function(GsWish a)> get sorters => [
        (a) => a.rarity,
        (a) => a.isCharacter ? 0 : 1,
        (a) => a.featured ? 0 : 1,
        (a) => a.name,
      ];
}
