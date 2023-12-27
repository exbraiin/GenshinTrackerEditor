import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_furnishing.g.dart';

@BuilderGenerator()
abstract class _GiFurnishing extends GsModel<GiFurnishing> {
  @BuilderWire('amount')
  int get amount;
}
