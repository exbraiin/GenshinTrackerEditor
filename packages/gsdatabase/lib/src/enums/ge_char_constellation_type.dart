import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeCharConstellationType implements GeEnum {
  c1('C1'),
  c2('C2'),
  c3('C3'),
  c4('C4'),
  c5('C5'),
  c6('C6');

  @override
  final String id;
  const GeCharConstellationType(this.id);
}
