import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeSereniteaSetType implements GeEnum {
  indoor('indoor'),
  outdoor('outdoor');

  @override
  final String id;
  const GeSereniteaSetType(this.id);
}
