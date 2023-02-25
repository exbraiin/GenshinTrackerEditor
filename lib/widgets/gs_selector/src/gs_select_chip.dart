import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsSelectChip<T> extends StatelessWidget {
  final bool hide;
  final bool selected;
  final GsSelectItem<T> item;
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
          border: Border.all(
            width: 2,
            color: selected
                ? Colors.white
                : Color.lerp(item.color, Colors.white, 0.2)!,
          ),
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            colors: [
              item.color,
              Color.lerp(item.color, Colors.black, 0.2)!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _content(),
      ),
    );
    if (onTap == null) return child;
    return InkWell(
      onTap: () => onTap!(item.value),
      child: child,
    );
  }

  Widget _content() {
    final text = Text(
      item.label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(1, 1),
          )
        ],
      ),
    );

    if (item.icon.isEmpty) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Image.asset(
            item.icon,
            width: 20,
            height: 20,
          ),
        ),
        text,
      ],
    );
  }
}
