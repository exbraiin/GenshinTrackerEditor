import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_spincrystal.g.dart';

@BuilderGenerator()
abstract class IGiSpincrystal extends GsModel<IGiSpincrystal> {
  @BuilderWire('obtained')
  bool get obtained;
}
