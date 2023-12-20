import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_event.g.dart';

@BuilderGenerator()
abstract class IGsEvent extends GsModel<IGsEvent> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('type')
  String get type;
  @BuilderWire('image')
  String get image;
  @BuilderWire('version')
  String get version;
  @BuilderWire('date_start')
  DateTime get dateStart;
  @BuilderWire('date_end')
  DateTime get dateEnd;
}
