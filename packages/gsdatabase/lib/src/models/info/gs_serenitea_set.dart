import 'package:gsdatabase/src/enums/ge_serenitea_set_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_serenitea_set.g.dart';

@BuilderGenerator()
abstract class _GsSereniteaSet extends GsModel<GsSereniteaSet> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('version')
  String get version;
  @BuilderWire('category')
  GeSereniteaSetType get category;
  @BuilderWire('image')
  String get image;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('energy')
  int get energy;
  @BuilderWire('chars')
  List<String> get chars;
  @BuilderWire('furnishing')
  List<_GsFurnishingAmount> get furnishing;

  @override
  Iterable<Comparable Function(GsSereniteaSet e)> get sorters => [
        (e) => e.category.index,
        (e) => e.version,
      ];
}

@BuilderGenerator()
abstract class _GsFurnishingAmount extends GsModel<GsFurnishingAmount> {
  @BuilderWire('amount')
  int get amount;
}
