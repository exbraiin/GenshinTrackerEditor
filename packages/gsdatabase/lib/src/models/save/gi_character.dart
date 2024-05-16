import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_character.g.dart';

@BuilderGenerator()
abstract class _GiCharacter extends GsModel<GiCharacter> {
  @BuilderWire('outfit', value: '')
  String get outfit;
  @BuilderWire('owned', value: 0)
  int get owned;
  @BuilderWire('ascension', value: 0)
  int get ascension;
  @BuilderWire('friendship', value: 1)
  int get friendship;
  @BuilderWire('talent1', value: 1)
  int get talent1;
  @BuilderWire('talent2', value: 1)
  int get talent2;
  @BuilderWire('talent3', value: 1)
  int get talent3;
}
