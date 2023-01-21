import 'package:flutter/material.dart';

class GsSelectItem<T> {
  final T value;
  final Color color;
  final String label;

  GsSelectItem(
    this.value,
    this.label, {
    this.color = Colors.grey,
  });
}
