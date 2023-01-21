import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

typedef JsonMap = Map<String, dynamic>;

extension BuildContextExt on BuildContext {
  Future<T?> pushWidget<T>(Widget Function() widget) {
    return Navigator.of(this)
        .push<T>(MaterialPageRoute(builder: (context) => widget()));
  }
}

extension StringExt on String {
  List<String> toStringList([String separator = ',']) =>
      split(separator).map((e) => e.trim()).toList();

  String toDbId() {
    return String.fromCharCodes(
      toLowerCase()
          .replaceAll(' ', '_')
          .runes
          .where((e) => e == 95 || e.between(48, 57) || e.between(97, 122))
          .skipWhile((v) => v == 95)
          .reversed
          .skipWhile((v) => v == 95)
          .reversed
          .chunkWhile((a, b) => a == 95 && b == 95)
          .map((element) => element.first),
    );
  }
}

extension IterableMapExt<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}

extension MapEntryExt on MapEntry<String, dynamic> {
  JsonMap toMapWithId() => {'id': key, ...(value as JsonMap? ?? {})};
}
