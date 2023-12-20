import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeEventType implements GeEnum {
  event('event'),
  login('login'),
  flagship('flagship'),
  battlepass('battlepass');

  @override
  final String id;
  const GeEventType(this.id);
}
