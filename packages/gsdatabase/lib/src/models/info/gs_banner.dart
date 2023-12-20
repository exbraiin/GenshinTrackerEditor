import 'package:gsdatabase/src/enums/ge_banner_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_banner.g.dart';

@BuilderGenerator()
abstract class IGsBanner extends GsModel<IGsBanner> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('date_start')
  DateTime get dateStart;
  @BuilderWire('date_end')
  DateTime get dateEnd;
  @BuilderWire('version')
  String get version;
  @BuilderWire('type')
  GeBannerType get type;
  @BuilderWire('feature_4')
  List<String> get feature4;
  @BuilderWire('feature_5')
  List<String> get feature5;
}
