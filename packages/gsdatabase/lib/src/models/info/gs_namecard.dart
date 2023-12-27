import 'package:gsdatabase/src/enums/ge_namecard_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_namecard.g.dart';

@BuilderGenerator()
abstract class _GsNamecard extends GsModel<GsNamecard> {
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

  @override
  Iterable<Comparable Function(GsNamecard e)> get sorters => [
        (e) => e.type.index,
        (e) => e.version,
      ];
}
