import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeElementType implements GeEnum {
  anemo('anemo'),
  geo('geo'),
  electro('electro'),
  dendro('dendro'),
  hydro('hydro'),
  pyro('pyro'),
  cryo('cryo');

  @override
  final String id;
  const GeElementType(this.id);
}
