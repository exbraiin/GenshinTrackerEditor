export 'package:gsdatabase/src/enums/ge_enum.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class GsModel<T extends GsModel<T>> implements Comparable<T> {
  @BuilderWire('id')
  String get id;
  T copyWith({String? id});
  JsonMap toMap();

  @override
  int compareTo(T other) {
    return sorters
        .map((e) => e(this as T).compareTo(e(other)))
        .firstWhere((e) => e != 0, orElse: () => this.id.compareTo(other.id));
  }

  Iterable<Comparable Function(T a)> get sorters => [];
}

class BuilderGenerator {
  const BuilderGenerator();
}

class BuilderWire<T> {
  final String wire;
  final bool fullDate;
  final T? value;
  const BuilderWire(
    this.wire, {
    this.value,
    this.fullDate = false,
  });
}
