import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeWeekdayType implements GeEnum {
  sunday('Sunday'),
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday');

  @override
  final String id;
  const GeWeekdayType(this.id);
}
