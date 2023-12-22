export 'package:gsdatabase/src/enums/ge_enum.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class GsModel<T extends GsModel<T>> {
  @BuilderWire('id')
  String get id;
  T copyWith();
  JsonMap toMap();
}

class BuilderGenerator {
  const BuilderGenerator();
}

class BuilderWire {
  final String wire;
  final bool fullDate;
  const BuilderWire(this.wire, {this.fullDate = false});
}
