import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_reputation.g.dart';

@BuilderGenerator()
abstract class _GiReputation extends GsModel<GiReputation> {
  @BuilderWire('reputation')
  int get reputation;
}
