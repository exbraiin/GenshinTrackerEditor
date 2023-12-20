import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_reputation.g.dart';

@BuilderGenerator()
abstract class IGiReputation extends GsModel<IGiReputation> {
  @BuilderWire('reputation')
  int get reputation;
}
