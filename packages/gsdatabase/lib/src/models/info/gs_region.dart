import 'package:gsdatabase/src/enums/ge_element_type.dart';
import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_region.g.dart';

@BuilderGenerator()
abstract class _GsRegion extends GsModel<GsRegion> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('image_ingame')
  String get imageInGame;
  @BuilderWire('archon')
  String get archon;
  @BuilderWire('ideal')
  String get ideal;
  @BuilderWire('element')
  GeElementType get element;
  @BuilderWire('reputation')
  List<int> get reputation;

  @override
  Iterable<Comparable Function(GsRegion e)> get sorters => [
        (e) => GeRegionType.values.fromId(e.id).index,
      ];
}
