import 'package:flutter/widgets.dart';

class AutoSizeText extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const AutoSizeText(this.data, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = this.style ?? const TextStyle(fontSize: 14);
        for (var fs = style.fontSize ?? 14; fs > 0; --fs) {
          final text = TextPainter(
            text: TextSpan(text: data, style: style.copyWith(fontSize: fs)),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );

          text.layout(maxWidth: constraints.maxWidth);
          if (text.size.height <= constraints.maxHeight) {
            return Text.rich(
              text.text!,
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
