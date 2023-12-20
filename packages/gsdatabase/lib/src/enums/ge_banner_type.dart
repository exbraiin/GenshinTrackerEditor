import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeBannerType implements GeEnum {
  standard('standard'),
  beginner('beginner'),
  character('character'),
  weapon('weapon');

  bool get isPermanent =>
      this == GeBannerType.standard || this == GeBannerType.beginner;

  @override
  final String id;
  const GeBannerType(this.id);
}
