import 'package:gsdatabase/src/models/gs_model.dart';

part 'gs_version.g.dart';

@BuilderGenerator()
abstract mixin class _GsVersion implements GsModel<GsVersion> {
  @BuilderWire('name')
  String get name;
  @BuilderWire('image')
  String get image;
  @BuilderWire('release_date')
  DateTime get releaseDate;

  @override
  Iterable<Comparable Function(GsVersion e)> get sorters => [
        (e) => e.releaseDate,
      ];
}
