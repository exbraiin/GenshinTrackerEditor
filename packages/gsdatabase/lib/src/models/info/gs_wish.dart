import 'package:gsdatabase/src/models/gs_model.dart';
import 'package:gsdatabase/src/models/info/gs_character.dart';
import 'package:gsdatabase/src/models/info/gs_weapon.dart';

class GsWish extends GsModel<GsWish> {
  final GsWeapon? weapon;
  final GsCharacter? character;

  @override
  String get id => weapon?.id ?? character?.id ?? '';
  String get name => weapon?.name ?? character?.name ?? '';
  String get image => weapon?.image ?? character?.image ?? '';
  int get rarity => weapon?.rarity ?? character?.rarity ?? 1;

  bool get isWeapon => weapon != null;
  bool get isCharacter => character != null;

  GsWish.fromWeapon(this.weapon) : character = null;
  GsWish.fromCharacter(this.character) : weapon = null;

  @override
  JsonMap toMap() => weapon?.toMap() ?? character?.toMap() ?? {};

  @override
  GsWish copyWith() => this;
}
