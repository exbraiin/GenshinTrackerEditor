import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_spincrystal.g.dart';

@BuilderGenerator()
abstract mixin class _GiSpincrystal implements GsModel<GiSpincrystal> {
  @BuilderWire('obtained')
  bool get obtained;
}
