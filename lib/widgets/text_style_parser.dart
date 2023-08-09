import 'package:dartx/dartx.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:flutter/material.dart';

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
    final bold = <FontWeight>[];
    final italic = <FontStyle>[];
    final underline = <TextDecoration>[];
    final colorQueue = <Color>[];

    final tags = {
      '<b>': () => bold.add(FontWeight.bold),
      '</b>': bold.pop,
      '<i>': () => italic.add(FontStyle.italic),
      '</i>': italic.pop,
      '<u>': () => underline.add(TextDecoration.underline),
      '</u>': underline.pop,
      '<color=skill>': () => colorQueue.add(Colors.teal),
      '<color=geo>': () => colorQueue.add(GeElements.geo.color),
      '<color=pyro>': () => colorQueue.add(GeElements.pyro.color),
      '<color=cryo>': () => colorQueue.add(GeElements.cryo.color),
      '<color=hydro>': () => colorQueue.add(GeElements.hydro.color),
      '<color=anemo>': () => colorQueue.add(GeElements.anemo.color),
      '<color=dendro>': () => colorQueue.add(GeElements.dendro.color),
      '<color=electro>': () => colorQueue.add(GeElements.electro.color),
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

extension<E> on List<E> {
  E? pop() => isEmpty ? null : removeLast();
}
