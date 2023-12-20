import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeEnemyType implements GeEnum {
  none('none'),
  common('common'),
  elite('elite'),
  normalBoss('normal_boss'),
  weeklyBoss('weekly_boss');

  @override
  final String id;
  const GeEnemyType(this.id);
}
