import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<T?> pushWidget<T>(Widget Function() widget) {
    return Navigator.of(this)
        .push<T>(MaterialPageRoute(builder: (context) => widget()));
  }

  Future pushWidgetReplacement(Widget Function() widget) {
    return Navigator.of(this)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget()));
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

  String toTitle() {
    final words = <String>[''];
    final chars = characters;
    for (var char in chars) {
      late final lastChar = words.last.characters.lastOrNull;
      late final isUpper = lastChar?.isCapitalized ?? false;
      if (char == '_' && !isUpper) {
        words.add('');
        continue;
      }
      if (char.isCapitalized && !isUpper) words.add('');
      words.last += char;
    }
    return words
        .where((e) => e.isNotEmpty)
        .map((e) => e.capitalize())
        .join(' ');
  }

  String toFandom(int size) {
    if (startsWith('https://static.wikia.nocookie.net/')) {
      return '$this/revision/latest/scale-to-width-down/$size';
    }
    return this;
  }
}

extension IterableMapExt<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}
