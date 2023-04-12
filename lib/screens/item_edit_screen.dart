import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:flutter/material.dart';

class ItemEditScreen<T extends GsModel<T>> extends StatefulWidget {
  final String title;
  final T? item;
  final T? duplicated;
  final GsCollection<T> collection;
  final Iterable<DataField<T>> fields;

  const ItemEditScreen({
    super.key,
    this.duplicated,
    required this.item,
    required this.title,
    required this.fields,
    required this.collection,
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
      widget.item ?? widget.duplicated ?? widget.collection.create({}),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void edit(T value) => _notifier.value = value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.title}'),
        actions: [
          IconButton(
            onPressed: () => context.pushWidgetReplacement(
              () => ItemEditScreen<T>(
                item: null,
                duplicated: _notifier.value.copyWith(),
                title: widget.title,
                collection: widget.collection,
                fields: widget.collection.validator.getDataFields(null),
              ),
            ),
            icon: const Icon(Icons.control_point_duplicate_rounded),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.multiply,
            ),
            image: const AssetImage(GsGraphics.bgImg),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: _notifier,
                  builder: (context, value, child) {
                    return getTableForFields(value, widget.fields, edit);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: _notifier,
              builder: (context, value, child) {
                final valid = widget.fields
                        .map((e) => e.isValid?.call(value))
                        .whereNotNull()
                        .maxBy((element) => element.index) !=
                    GsValidLevel.error;

                void onSave() {
                  widget.collection.updateItem(widget.item?.id, value);
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
                      child: DeleteButton(
                        onPressed: widget.item != null ? onDelete : null,
                        child: const Icon(Icons.delete),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Opacity(
                      opacity: valid ? 1 : 0.2,
                      child: FloatingActionButton(
                        heroTag: 'save',
                        onPressed: valid ? onSave : null,
                        splashColor: Colors.black.withOpacity(0.4),
                        child: const Icon(Icons.save, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const DeleteButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton>
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
    const size = 55.0;
    return GestureDetector(
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            borderRadius: BorderRadius.circular(size),
            boxShadow: const [BoxShadow(blurRadius: 2)],
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: _controller.value,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(size),
                      ),
                    ),
                  ),
                  widget.child,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
