import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_version.g.dart';

@BuilderGenerator()
abstract class IGsVersion extends GsModel<IGsVersion> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('release_date')
  DateTime get releaseDate;
}
