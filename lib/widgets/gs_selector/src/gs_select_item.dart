import 'package:flutter/material.dart';

class GsSelectItem<T> {
  final T value;
  final Color color;
  final String label;
  final String icon;

  GsSelectItem(
    this.value,
    this.label, {
    this.icon = '',
    this.color = Colors.grey,
  });
}
