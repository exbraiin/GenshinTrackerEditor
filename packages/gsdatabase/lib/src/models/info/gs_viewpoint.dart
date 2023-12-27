import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_viewpoint.g.dart';

@BuilderGenerator()
abstract class _GsViewpoint extends GsModel<GsViewpoint> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('desc')
  String get desc;
  @BuilderWire('image')
  String get image;
  @BuilderWire('region')
  GeRegionType get region;
  @BuilderWire('version')
  String get version;

  @override
  Iterable<Comparable Function(GsViewpoint e)> get sorters => [
        (e) => e.region.index,
      ];
}
