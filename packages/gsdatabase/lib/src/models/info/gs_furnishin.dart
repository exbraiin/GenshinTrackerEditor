import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_furnishin.g.dart';

@BuilderGenerator()
abstract class IGsFurnishing extends GsModel<IGsFurnishing> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('rarity')
  int get rarity;
}
