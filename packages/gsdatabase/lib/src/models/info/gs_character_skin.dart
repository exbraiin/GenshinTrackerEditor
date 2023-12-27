import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_character_skin.g.dart';

@BuilderGenerator()
abstract class _GsCharacterSkin extends GsModel<GsCharacterSkin> {
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('version')
  String get version;
  @BuilderWire('character')
  String get character;
  @BuilderWire('side_image')
  String get sideImage;
  @BuilderWire('full_image')
  String get fullImage;
}
