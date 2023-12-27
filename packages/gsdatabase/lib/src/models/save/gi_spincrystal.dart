import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_spincrystal.g.dart';

@BuilderGenerator()
abstract class _GiSpincrystal extends GsModel<GiSpincrystal> {
  @BuilderWire('obtained')
  bool get obtained;
}
