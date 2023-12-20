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
  const BuilderWire(this.wire);
}
