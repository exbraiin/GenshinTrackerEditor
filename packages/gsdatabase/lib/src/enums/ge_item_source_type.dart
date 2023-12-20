import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeItemSourceType implements GeEnum {
  shop('shop'),
  event('event'),
  fishing('fishing'),
  forging('forging'),
  battlepass('battlepass'),
  exploration('exploration'),
  wishesStandard('wishes_standard'),
  wishesWeaponBanner('wishes_weapon_banner'),
  wishesCharacterBanner('wishes_character_banner');

  @override
  final String id;
  const GeItemSourceType(this.id);
}
