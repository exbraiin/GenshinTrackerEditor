import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_furnishing.g.dart';

@BuilderGenerator()
abstract mixin class _GiFurnishing implements GsModel<GiFurnishing> {
  @BuilderWire('amount')
  int get amount;
}
