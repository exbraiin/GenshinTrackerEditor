import 'package:dartx/dartx.dart';

export 'package:gsdatabase/src/enums/ge_enum.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class GsModel<T extends GsModel<T>> {
  @BuilderWire('id')
  String get id;
  T copyWith();
  JsonMap toMap();
  Iterable<Comparable Function(T e)> get sorters => [(e) => e.id];
}

class BuilderGenerator {
  const BuilderGenerator();
}

class BuilderWire {
  final String wire;
  final bool fullDate;
  const BuilderWire(this.wire, {this.fullDate = false});
}

extension GsModelSorter<E extends GsModel<E>> on Iterable<E> {
  SortedList<E> sortedModels() => SortedList<E>(
        this,
        (a, b) {
          return a.sorters
              .map((e) => e.call(a).compareTo(e.call(b)))
              .firstWhere((e) => e != 0, orElse: () => a.id.compareTo(b.id));
        },
      );
}
