import 'package:dartx/dartx.dart';
import 'package:data_editor/style/style.dart';
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
      '</b>': () => bold.pop(),
      '<i>': () => italic.add(FontStyle.italic),
      '</i>': () => italic.pop(),
      '<u>': () => underline.add(TextDecoration.underline),
      '</u>': () => underline.pop(),
      '<color=skill>': () => colorQueue.add(Colors.orange),
      '<color=geo>': () => colorQueue.add(GsStyle.getElementColor('geo')),
      '<color=pyro>': () => colorQueue.add(GsStyle.getElementColor('pyro')),
      '<color=cryo>': () => colorQueue.add(GsStyle.getElementColor('cryo')),
      '<color=hydro>': () => colorQueue.add(GsStyle.getElementColor('hydro')),
      '<color=anemo>': () => colorQueue.add(GsStyle.getElementColor('anemo')),
      '<color=dendro>': () => colorQueue.add(GsStyle.getElementColor('dendro')),
      '<color=electro>': () =>
          colorQueue.add(GsStyle.getElementColor('electro')),
      '</color>': () => colorQueue.pop(),
    };
    for (var p = 0;;) {
      final idxs = tags.keys
          .map((t) => MapEntry(t, text.indexOf(t, p)))
          .where((t) => t.value != -1);

      late final tempStyle = style.copyWith(
        color: colorQueue.peek ?? style.color,
        fontWeight: bold.peek ?? style.fontWeight,
        fontStyle: italic.peek ?? style.fontStyle,
        decoration: underline.peek ?? style.decoration,
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
  E? get peek => lastOrNull;
  E? pop() => isEmpty ? null : removeLast();
}
