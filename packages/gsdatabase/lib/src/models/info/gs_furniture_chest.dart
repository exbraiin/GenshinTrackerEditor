import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/enums/ge_serenitea_set_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_furniture_chest.g.dart';

@BuilderGenerator()
abstract class _GsFurnitureChest extends GsModel<GsFurnitureChest> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('type')
  GeSereniteaSetType get type;
  @BuilderWire('image')
  String get image;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('energy')
  int get energy;
  @BuilderWire('region')
  GeRegionType get region;
  @BuilderWire('version')
  String get version;

  @override
  Iterable<Comparable Function(GsFurnitureChest e)> get sorters => [
        (e) => e.region.index,
        (e) => e.rarity,
      ];
}
