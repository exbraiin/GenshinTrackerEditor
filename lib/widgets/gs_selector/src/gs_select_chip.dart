import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsSelectChip<T> extends StatelessWidget {
  final GsSelectItem<T> item;
  final bool hide;
  final bool selected;
  final void Function(T item)? onTap;

  const GsSelectChip(
    this.item, {
    super.key,
    this.hide = false,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Opacity(
      opacity: hide ? 0.2 : 1,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration: BoxDecoration(
          color: item.color,
          border: Border.all(
            width: 2,
            color: selected ? Colors.white : item.color,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          item.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    if (onTap == null) return child;
    return InkWell(
      onTap: () => onTap!(item.value),
      child: child,
    );
  }
}
