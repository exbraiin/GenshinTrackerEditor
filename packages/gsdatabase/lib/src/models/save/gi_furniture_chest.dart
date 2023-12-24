import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_furniture_chest.g.dart';

@BuilderGenerator()
abstract mixin class _GiFurnitureChest implements GsModel<GiFurnitureChest> {
  @BuilderWire('obtained')
  bool get obtained;
}
