import 'package:gsdatabase/src/enums/ge_namecard_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_namecard.g.dart';

@BuilderGenerator()
abstract class IGsNamecard extends GsModel<IGsNamecard> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('type')
  GeNamecardType get type;
  @BuilderWire('version')
  String get version;
  @BuilderWire('image')
  String get image;
  @BuilderWire('full_image')
  String get fullImage;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('obtain')
  String get obtain;
}
