import 'package:gsdatabase/src/enums/ge_serenitea_set_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_serenitea_set.g.dart';

@BuilderGenerator()
abstract class IGsSereniteaSet extends GsModel<IGsSereniteaSet> {
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
  List<IGsFurnishingAmount> get furnishing;
}

@BuilderGenerator()
abstract class IGsFurnishingAmount extends GsModel<IGsFurnishingAmount> {
  @BuilderWire('amount')
  int get amount;
}