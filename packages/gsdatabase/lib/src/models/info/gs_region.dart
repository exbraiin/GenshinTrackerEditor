import 'package:gsdatabase/src/enums/ge_element_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_region.g.dart';

@BuilderGenerator()
abstract class IGsRegion extends GsModel<IGsRegion> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('element')
  GeElementType get element;
  @BuilderWire('reputation')
  List<int> get reputation;
}
