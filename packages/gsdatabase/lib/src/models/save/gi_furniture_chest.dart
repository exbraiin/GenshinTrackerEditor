import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_furniture_chest.g.dart';

@BuilderGenerator()
abstract class _GiFurnitureChest extends GsModel<GiFurnitureChest> {
  @BuilderWire('obtained')
  bool get obtained;
}
