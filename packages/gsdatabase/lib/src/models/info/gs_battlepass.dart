import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_battlepass.g.dart';

@BuilderGenerator()
abstract class _GsBattlepass extends GsModel<GsBattlepass> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('version')
  String get version;
  @BuilderWire('namecard_id')
  String get namecardId;
  @BuilderWire('date_start')
  DateTime get dateStart;
  @BuilderWire('date_end')
  DateTime get dateEnd;

  @override
  Iterable<Comparable Function(GsBattlepass e)> get sorters => [
        (e) => e.dateStart,
      ];
}
