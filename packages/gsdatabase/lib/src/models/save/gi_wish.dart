import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_wish.g.dart';

@BuilderGenerator()
abstract class _GiWish extends GsModel<GiWish> {
  @BuilderWire('number')
  int get number;
  @BuilderWire('item')
  String get itemId;
  @BuilderWire('banner')
  String get bannerId;
  @BuilderWire('date')
  DateTime get date;

  @override
  Iterable<Comparable Function(GiWish a)> get sorters => [
        (a) => a.date,
        (a) => a.number,
        (a) => a.bannerId,
        (a) => a.bannerDate,
      ];
}

extension GiWishExt on GiWish {
  DateTime get bannerDate {
    final e = bannerId.split('_').toList();
    final date = '${e[e.length - 3]}-${e[e.length - 2]}-${e[e.length - 1]}';
    return DateTime.parse(date);
  }
}
