import 'package:flutter/widgets.dart';

class GsNotifierProvider<T> extends StatefulWidget {
  final T value;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    ValueNotifier<T> notifier,
    Widget? child,
  ) builder;

  const GsNotifierProvider({
    super.key,
    this.child,
    required this.value,
    required this.builder,
  });

  @override
  State<GsNotifierProvider<T>> createState() => _GsNotifierProviderState<T>();
}

class _GsNotifierProviderState<T> extends State<GsNotifierProvider<T>> {
  late final ValueNotifier<T> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.value);
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) =>
          widget.builder(context, notifier, child),
      child: widget.child,
    );
  }
}
