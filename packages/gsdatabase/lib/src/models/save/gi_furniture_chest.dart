import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_furniture_chest.g.dart';

@BuilderGenerator()
abstract class IGiFurnitureChest extends GsModel<IGiFurnitureChest> {
  @BuilderWire('obtained')
  bool get obtained;
}
