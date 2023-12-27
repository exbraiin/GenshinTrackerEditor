import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_spincrystal.g.dart';

@BuilderGenerator()
abstract class _GsSpincrystal extends GsModel<GsSpincrystal> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('number')
  int get number;
  @BuilderWire('source')
  String get source;
  @BuilderWire('region')
  GeRegionType get region;
  @BuilderWire('version')
  String get version;

  @override
  Iterable<Comparable Function(GsSpincrystal e)> get sorters => [
        (e) => e.number,
      ];
}

extension GsSpincrystalExt on GsSpincrystal {
  bool get fromChubby => source == 'Chubby';
}
