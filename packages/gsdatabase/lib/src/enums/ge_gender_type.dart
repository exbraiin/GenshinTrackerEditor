import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeGenderType implements GeEnum {
  none('none'),
  male('male'),
  female('female');

  @override
  final String id;
  const GeGenderType(this.id);
}
