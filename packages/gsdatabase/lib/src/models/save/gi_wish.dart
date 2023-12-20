import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_wish.g.dart';

@BuilderGenerator()
abstract class IGiWish extends GsModel<IGiWish> {
  @BuilderWire('number')
  int get number;
  @BuilderWire('item')
  String get itemId;
  @BuilderWire('banner')
  String get bannerId;
  @BuilderWire('date')
  DateTime get date;
}

extension GiWishExt on GiWish {
  DateTime get bannerDate {
    final e = bannerId.split('_').toList();
    final date = '${e[e.length - 3]}-${e[e.length - 2]}-${e[e.length - 1]}';
    return DateTime.parse(date);
  }
}
