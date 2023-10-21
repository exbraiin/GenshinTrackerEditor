import 'package:flutter/widgets.dart';

class AutoSizeText extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const AutoSizeText(this.data, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        for (var size = style?.fontSize ?? 14; size > 0; size--) {
          final span = TextSpan(
            text: data,
            style: style?.copyWith(fontSize: size) ?? TextStyle(fontSize: size),
          );
          final text = TextPainter(
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            text: span,
          );
          text.layout(maxWidth: constraints.maxWidth);
          if (text.size.height <= constraints.maxHeight) {
            return Text.rich(
              span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
