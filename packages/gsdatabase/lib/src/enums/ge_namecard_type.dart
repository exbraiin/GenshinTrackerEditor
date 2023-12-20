import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeNamecardType implements GeEnum {
  achievement('achievement'),
  battlepass('battlepass'),
  character('character'),
  defaults('default'),
  event('event'),
  offering('offering'),
  reputation('reputation');

  @override
  final String id;
  const GeNamecardType(this.id);
}
