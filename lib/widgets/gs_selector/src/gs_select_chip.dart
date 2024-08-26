import 'package:data_editor/style/utils.dart';
import 'package:flutter/material.dart';

class GsSelectItem<T> {
  final T value;
  final Color color;
  final String label;
  final String asset;
  final String? image;

  const GsSelectItem(
    this.value,
    this.label, {
    this.asset = '',
    this.image,
    this.color = Colors.grey,
  });
}

class GsSelectChip<T> extends StatelessWidget {
  final bool hide;
  final bool selected;
  final bool disableImage;
  final GsSelectItem<T> item;
  final void Function(T item)? onTap;

  const GsSelectChip(
    this.item, {
    super.key,
    this.hide = false,
    this.selected = false,
    this.disableImage = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Opacity(
      opacity: hide ? 0.2 : 1,
      child: item.image != null && !disableImage
          ? _selectBox(context)
          : _selectChip(context),
    );
    if (onTap == null) return child;
    return InkWell(
      onTap: () => onTap!(item.value),
      child: child,
    );
  }

  Widget _selectBox(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: selected
                    ? Colors.white
                    : Color.lerp(item.color, Colors.white, 0.2)!,
              ),
              gradient: LinearGradient(
                colors: [
                  item.color,
                  Color.lerp(item.color, Colors.black, 0.2)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: item.image!.isNotEmpty
                ? Image.network(item.image!.toFandom(46))
                : const Icon(Icons.question_mark_rounded),
          ),
          Text(
            item.label,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _selectChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.asset.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Image.asset(
                item.asset,
                width: 20,
                height: 20,
              ),
            ),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
