import 'package:dartx/dartx.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class TextParserWidget extends StatelessWidget {
  final String text;
  final TextStyle style;

  const TextParserWidget(
    this.text, {
    super.key,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: getChildren().toList(),
      ),
    );
  }

  Iterable<TextSpan> getChildren() sync* {
    final bold = Queue<FontWeight>();
    final italic = Queue<FontStyle>();
    final underline = Queue<TextDecoration>();
    final colorQueue = Queue<Color>();

    final tags = {
      '<b>': () => bold.add(FontWeight.bold),
      '</b>': bold.pop,
      '<i>': () => italic.add(FontStyle.italic),
      '</i>': italic.pop,
      '<u>': () => underline.add(TextDecoration.underline),
      '</u>': underline.pop,
      '<color=skill>': () => colorQueue.add(Colors.teal),
      '<color=geo>': () => colorQueue.add(GeElementType.geo.color),
      '<color=pyro>': () => colorQueue.add(GeElementType.pyro.color),
      '<color=cryo>': () => colorQueue.add(GeElementType.cryo.color),
      '<color=hydro>': () => colorQueue.add(GeElementType.hydro.color),
      '<color=anemo>': () => colorQueue.add(GeElementType.anemo.color),
      '<color=dendro>': () => colorQueue.add(GeElementType.dendro.color),
      '<color=electro>': () => colorQueue.add(GeElementType.electro.color),
      '</color>': colorQueue.pop,
    };
    for (var p = 0;;) {
      final idxs = tags.keys
          .map((t) => MapEntry(t, text.indexOf(t, p)))
          .where((t) => t.value != -1);

      late final tempStyle = style.copyWith(
        color: colorQueue.lastOrNull ?? style.color,
        fontWeight: bold.lastOrNull ?? style.fontWeight,
        fontStyle: italic.lastOrNull ?? style.fontStyle,
        decoration: underline.lastOrNull ?? style.decoration,
      );

      final tag = idxs.minBy((e) => e.value);
      if (tag == null) {
        final subText = text.substring(p, text.length);
        if (subText.isNotEmpty) yield TextSpan(text: subText, style: tempStyle);
        break;
      }
      final subTex = text.substring(p, tag.value);
      if (subTex.isNotEmpty) yield TextSpan(text: subTex, style: tempStyle);
      tags[tag.key]?.call();
      p = tag.value + tag.key.length;
    }
  }
}

class Queue<E> extends Iterable<E> {
  final _list = <E>[];

  void add(E element) => _list.add(element);
  E? pop() => _list.isEmpty ? null : _list.removeLast();

  @override
  Iterator<E> get iterator => _list.iterator;
}
