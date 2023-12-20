import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeAchievementType implements GeEnum {
  none(''),
  exploration('exploration'),
  quest('quest'),
  commission('commission'),
  boss('boss');

  @override
  final String id;
  const GeAchievementType(this.id);
}
