import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:data_editor/widgets/gs_text_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// The validator level.
enum GsValidLevel {
  none,
  good,
  warn1(color: Colors.lightBlue),
  warn2(color: Colors.orange, label: 'Missing'),
  error(color: Colors.red, label: 'Invalid');

  final Color? color;
  final String? label;

  bool get isErrorOrWarn2 =>
      this == GsValidLevel.error || this == GsValidLevel.warn2;

  const GsValidLevel({this.color, this.label});
}

typedef DEdit<T extends GsModel<T>> = void Function(T v);
typedef DValid<T extends GsModel<T>> = GsValidLevel Function(T item);
typedef DUpdate<T extends GsModel<T>> = T Function(T item);
typedef DBuilder<T extends GsModel<T>> = Widget Function(T item, DEdit<T> edit);

class DataField<T extends GsModel<T>> {
  final String label;
  final DValid<T>? isValid;
  final DBuilder<T> builder;

  DataField._(
    this.label,
    this.builder, {
    this.isValid,
  });

  DataField.text(
    this.label,
    String Function(T item) content, {
    this.isValid,
  }) : builder = ((item, edit) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              constraints: const BoxConstraints(minHeight: 36),
              alignment: Alignment.centerLeft,
              child: Text(content(item)),
            ));

  DataField.button(
    this.label,
    String Function(T item) content,
    VoidCallback? onPressed, {
    this.isValid,
  }) : builder = ((item, edit) {
          return InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              constraints: const BoxConstraints(minHeight: 36),
              alignment: Alignment.centerLeft,
              child: Text(content(item)),
            ),
          );
        });

  DataField.textEditor(
    this.label,
    String Function(T item) content,
    T Function(T item, String value) update, {
    this.isValid,
  }) : builder = ((item, edit) {
          var text = content(item).split('\n').first;
          if (text.length > 40) text = text.substring(0, 40);
          if (text.isNotEmpty) text = '$text...';
          return Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) => InkWell(
                    onTap: () => GsTextEditorDialog(
                      initialText: content(item),
                      onConfirm: (value) => edit(update(item, value)),
                    ).show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      constraints: const BoxConstraints(minHeight: 36),
                      alignment: Alignment.centerLeft,
                      child: Text(text),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  const type = Clipboard.kTextPlain;
                  final text = (await Clipboard.getData(type))?.text;
                  if (text == null) return;
                  edit(update(item, text));
                },
                icon: const Icon(Icons.paste_rounded),
              ),
            ],
          );
        });

  DataField.textField(
    this.label,
    String Function(T item) content,
    T Function(T item, String value) update, {
    String Function(String value)? process,
    Future<T> Function(T item)? import,
    DUpdate<T>? refresh,
    String? importTooltip,
    this.isValid,
  }) : builder = ((item, edit) => SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    child: ExtendedTextField(
                      initialValue: content(item),
                      process: process,
                      onEdit: (value) => edit(update(item, value)),
                    ),
                  ),
                  if (refresh != null)
                    IconButton(
                      onPressed: () => edit(refresh(item)),
                      icon: const Icon(Icons.upload_rounded),
                    ),
                  if (import != null)
                    IconButton(
                      onPressed: () async => edit(await import(item)),
                      icon: const Icon(Icons.bolt_outlined),
                      tooltip: importTooltip,
                    ),
                  IconButton(
                    onPressed: () async {
                      const type = Clipboard.kTextPlain;
                      final text = (await Clipboard.getData(type))?.text;
                      if (text == null) return;
                      final processed = process?.call(text) ?? text;
                      edit(update(item, processed));
                    },
                    icon: const Icon(Icons.paste_rounded),
                  ),
                ],
              ),
            ));

  static DataField<T> multiSelect<T extends GsModel<T>, V>(
    String label,
    List<V> Function(T item) values,
    Iterable<GsSelectItem<V>> Function(T item) options,
    T Function(T item, List<V> value) update, {
    DValid<T>? isValid,
  }) {
    return DataField._(
      label,
      (item, edit) => GsMultiSelect<V>(
        items: options(item).toList(),
        selected: values(item).toSet(),
        onConfirm: (value) => edit(update(item, value.toList())),
      ),
      isValid: isValid ??
          ((item) => options(item)
                  .map((element) => element.value)
                  .containsAll(values(item))
              ? GsValidLevel.good
              : GsValidLevel.error),
    );
  }

  DataField.singleSelect(
    this.label,
    String Function(T item) value,
    Iterable<GsSelectItem<String>> Function(T item) items,
    T Function(T item, String value) update, {
    DValid<T>? isValid,
  })  : builder = ((item, edit) => GsSingleSelect(
              items: items(item),
              selected: value(item),
              onConfirm: (value) => edit(update(item, value ?? '')),
            )),
        isValid = isValid ??
            ((item) {
              final v = value(item);
              return items(item).any((e) => e.value == v)
                  ? GsValidLevel.good
                  : GsValidLevel.error;
            });

  DataField.selectRarity(
    this.label,
    int Function(T item) value,
    T Function(T item, int value) update, {
    int min = 1,
  })  : builder = ((item, edit) => GsSingleSelect(
              items: List.generate(
                6 - min,
                (index) => GsSelectItem(
                  min + index,
                  (min + index).toString(),
                  color: GsStyle.getRarityColor(min + index),
                ),
              ),
              selected: value(item),
              onConfirm: (value) => edit(update(item, value ?? 1)),
            )),
        isValid = ((item) => value(item).between(min, 5)
            ? GsValidLevel.good
            : GsValidLevel.error);

  DataField.list(
    this.label,
    Iterable<DataField<T>> Function(T item) fields,
  )   : builder = ((item, edit) => getTableForFields(item, fields(item), edit)),
        isValid = ((item) =>
            fields(item)
                .map((e) => e.isValid?.call(item))
                .whereNotNull()
                .maxBy((e) => e.index) ??
            GsValidLevel.none);

  static DataField<T> build<T extends GsModel<T>, C extends GsModel<C>>(
    String label,
    List<C> Function(T item) values,
    Iterable<GsSelectItem<String>> Function(T item) options,
    DataField<C> Function(T item, C child) build,
    T Function(T item, Set<String> value) onValuesUpdated,
    T Function(T item, C field) onFieldUpdated,
  ) {
    return DataField<T>._(
      label,
      (item, edit) {
        final list = values(item).toList();
        return Column(
          children: [
            GsMultiSelect<String>(
              items: options(item).toList(),
              selected: values(item).map((e) => e.id).toSet(),
              onConfirm: (value) => edit(onValuesUpdated(item, value)),
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: const TableBorder(
                horizontalInside: BorderSide(color: Colors.grey),
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              ),
              columnWidths: const {0: IntrinsicColumnWidth()},
              children: list.map((child) {
                return _getFieldTableRow(
                  child,
                  build(item, child),
                  (child) => edit(onFieldUpdated(item, child)),
                );
              }).toList(),
            ),
          ],
        );
      },
      isValid: (item) =>
          values(item)
              .map((e) => build(item, e).isValid?.call(e))
              .whereNotNull()
              .maxBy((element) => element.index) ??
          GsValidLevel.none,
    );
  }
}

Widget getTableForFields<T extends GsModel<T>>(
  T value,
  Iterable<DataField<T>> fields,
  void Function(T item) updateItem,
) {
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    border: const TableBorder(
      verticalInside: BorderSide(color: Colors.white24),
      horizontalInside: BorderSide(color: Colors.grey),
      top: BorderSide(color: Colors.grey),
      bottom: BorderSide(color: Colors.grey),
    ),
    columnWidths: const {0: IntrinsicColumnWidth()},
    children: fields
        .map((field) => _getFieldTableRow(value, field, updateItem))
        .toList(),
  );
}

TableRow _getFieldTableRow<T extends GsModel<T>>(
  T value,
  DataField<T> field,
  void Function(T item) edit,
) {
  final color = field.isValid?.call(value).color;
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
        child: Row(
          children: [
            Text(
              field.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            Opacity(
              opacity: color != null ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.info_outline_rounded, color: color),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: field.builder(value, edit),
      ),
    ],
  );
}

class ExtendedTextField extends StatefulWidget {
  final String initialValue;
  final void Function(String value) onEdit;
  final String Function(String value)? process;

  const ExtendedTextField({
    super.key,
    this.process,
    required this.initialValue,
    required this.onEdit,
  });

  @override
  State<ExtendedTextField> createState() => _ExtendedTextFieldState();
}

class _ExtendedTextFieldState extends State<ExtendedTextField> {
  late final FocusNode _node;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExtendedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_node.hasFocus && oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (_controller.text.isNotEmpty) {
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        }
      },
      child: TextField(
        style: const TextStyle(fontSize: 14),
        focusNode: _node,
        controller: _controller,
        decoration: const InputDecoration.collapsed(hintText: ''),
        onChanged: (value) {
          value = widget.process?.call(value) ?? value;
          widget.onEdit(value);
        },
        onEditingComplete: () {
          var value = _controller.text;
          value = value.trim();
          value = widget.process?.call(value) ?? value;
          _controller.text = value;

          widget.onEdit(value);
          _node.unfocus();
        },
      ),
    );
  }
}
