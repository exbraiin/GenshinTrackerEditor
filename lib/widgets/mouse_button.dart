// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/widgets.dart';

typedef HoverCallback = Widget Function(
  BuildContext context,
  bool hover,
  Widget? child,
);

class MouseButton extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final HoverCallback builder;

  const MouseButton({
    super.key,
    this.onTap,
    this.child,
    required this.builder,
  });

  @override
  State<MouseButton> createState() => _MouseButtonState();
}

class _MouseButtonState extends State<MouseButton> {
  var _hover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (e) => setState(() => _hover = true),
        onExit: (e) => setState(() => _hover = false),
        child: widget.builder(context, _hover, widget.child),
      ),
    );
  }
}
