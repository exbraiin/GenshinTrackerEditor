import 'package:gsdatabase/src/enums/ge_event_type.dart';
import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_event.g.dart';

@BuilderGenerator()
abstract mixin class _GsEvent implements GsModel<GsEvent> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('type')
  GeEventType get type;
  @BuilderWire('image')
  String get image;
  @BuilderWire('version')
  String get version;
  @BuilderWire('date_start')
  DateTime get dateStart;
  @BuilderWire('date_end')
  DateTime get dateEnd;

  @override
  Iterable<Comparable Function(GsEvent e)> get sorters => [
        (e) => e.type.index,
        (e) => e.dateStart,
      ];
}
