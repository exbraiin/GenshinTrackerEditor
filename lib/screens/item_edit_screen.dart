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
        widget.item ?? widget.duplicated ?? widget.collection.create({}));
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
                      child: FloatingActionButton(
                        heroTag: 'delete',
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
                        child: const Icon(Icons.save),
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
