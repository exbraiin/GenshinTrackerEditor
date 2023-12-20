import 'package:gsdatabase/src/enums/ge_region_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_artifact.g.dart';

@BuilderGenerator()
abstract class IGsArtifact extends GsModel<IGsArtifact> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('region')
  GeRegionType get region;
  @BuilderWire('version')
  String get version;
  @BuilderWire('rarity')
  int get rarity;
  @BuilderWire('1pc')
  String get pc1;
  @BuilderWire('2pc')
  String get pc2;
  @BuilderWire('4pc')
  String get pc4;
  @BuilderWire('domain')
  String get domain;
  @BuilderWire('list_pieces')
  List<IGsArtifactPiece> get pieces;
}

@BuilderGenerator()
abstract class IGsArtifactPiece extends GsModel<IGsArtifactPiece> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('icon')
  String get icon;
  @BuilderWire('desc')
  String get desc;
}
