import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_furnishing.g.dart';

@BuilderGenerator()
abstract class _GsFurnishing extends GsModel<GsFurnishing> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('rarity')
  int get rarity;

  @override
  Iterable<Comparable Function(GsFurnishing e)> get sorters => [
        (e) => e.rarity,
      ];
}
