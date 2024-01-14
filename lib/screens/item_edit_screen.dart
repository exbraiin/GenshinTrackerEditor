import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class ItemEditScreen<T extends GsModel<T>> extends StatefulWidget {
  final String title;
  final T? item;
  final T? duplicated;
  final Items<T> collection;
  final GsModelExt<T> modelExt;
  final Iterable<DataButton<T>> import;

  const ItemEditScreen({
    super.key,
    this.duplicated,
    required this.item,
    required this.title,
    required this.modelExt,
    required this.collection,
    this.import = const [],
  });

  @override
  State<ItemEditScreen<T>> createState() => _ItemEditScreenState<T>();
}

class _ItemEditScreenState<T extends GsModel<T>>
    extends State<ItemEditScreen<T>> {
  late final ValueNotifier<T> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(
      widget.item ?? widget.duplicated ?? widget.collection.parser({}),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.modelExt.getFields(widget.item?.id);
    void edit(T value) => _notifier.value = value;
    final iconSize = IconTheme.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.title}'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (context, value, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: widget.import
                    .map(
                      (e) => IconButton(
                        tooltip: e.tooltip,
                        icon: e.icon != null
                            ? SizedBox(
                                width: iconSize,
                                height: iconSize,
                                child: e.icon,
                              )
                            : const Icon(Icons.bolt_outlined),
                        onPressed: () async =>
                            edit(await e.callback(context, value)),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          if (widget.duplicated == null && widget.item != null)
            IconButton(
              onPressed: () => context.pushWidgetReplacement(
                ItemEditScreen<T>(
                  item: null,
                  duplicated: _notifier.value.copyWith(),
                  title: widget.title,
                  collection: widget.collection,
                  modelExt: widget.modelExt,
                ),
              ),
              icon: const Icon(Icons.control_point_duplicate_rounded),
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: GsStyle.kMainDecoration,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 56 + 16),
                child: ValueListenableBuilder(
                  valueListenable: _notifier,
                  builder: (context, value, child) {
                    return getTableForFields(context, value, fields, edit);
                  },
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (context, value, child) {
                  final valid = fields
                          .map((e) => e.validator(value))
                          .whereNotNull()
                          .maxBy((element) => element.index) !=
                      GsValidLevel.error;

                  void onSave() {
                    widget.collection.delete(widget.item?.id);
                    widget.collection.updateItem(value);
                    Navigator.of(context).maybePop();
                  }

                  void onDelete() {
                    widget.collection.delete(_notifier.value.id);
                    Navigator.of(context).maybePop();
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: widget.item != null ? 1 : 0.2,
                        child: FloatingDeleteButton(
                          onPressed: widget.item != null ? onDelete : null,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Opacity(
                        opacity: valid ? 1 : 0.2,
                        child: FloatingActionButton(
                          heroTag: 'save',
                          onPressed: valid ? onSave : null,
                          child: const Icon(Icons.save, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingDeleteButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const FloatingDeleteButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  @override
  State<FloatingDeleteButton> createState() => _FloatingDeleteButtonState();
}

class _FloatingDeleteButtonState extends State<FloatingDeleteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails d) {
    _controller.animateTo(1, curve: Curves.easeOut);
  }

  void _onTapUp(TapUpDetails d) {
    _onTapCancel();
    if (_controller.value >= 1) widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(16));
    const size = BoxConstraints.tightFor(width: 56, height: 56);
    const shape = RoundedRectangleBorder(borderRadius: radius);
    final theme = Theme.of(context).floatingActionButtonTheme;

    return GestureDetector(
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: Container(
        constraints: size,
        decoration: ShapeDecoration(shape: shape, color: theme.backgroundColor),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: _controller.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: ShapeDecoration(
                      shape: shape.copyWith(
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
                IconTheme.merge(
                  data: IconThemeData(size: theme.iconSize),
                  child: widget.child,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
