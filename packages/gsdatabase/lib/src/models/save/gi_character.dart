import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_character.g.dart';


@BuilderGenerator()
abstract class IGiCharacter extends GsModel<IGiCharacter> {
  @BuilderWire('outfit')
  String get outfit;
  @BuilderWire('owned')
  int get owned;
  @BuilderWire('ascension')
  int get ascension;
  @BuilderWire('friendship')
  int get friendship;
}
