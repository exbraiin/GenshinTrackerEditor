import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_reputation.g.dart';

@BuilderGenerator()
abstract mixin class _GiReputation implements GsModel<GiReputation> {
  @BuilderWire('reputation')
  int get reputation;
}
