import 'package:data_editor/db/database.dart';

class GsWish extends GsModel<GsWish> {
  final GsWeapon? weapon;
  final GsCharacter? character;

  @override
  String get id => weapon?.id ?? character?.id ?? '';
  String get name => weapon?.name ?? character?.name ?? '';
  int get rarity => weapon?.rarity ?? character?.rarity ?? 1;

  GsWish.fromWeapon(this.weapon) : character = null;
  GsWish.fromCharacter(this.character) : weapon = null;

  @override
  JsonMap toJsonMap() => weapon?.toJsonMap() ?? character?.toJsonMap() ?? {};

  @override
  GsWish copyWith() => this;
}
