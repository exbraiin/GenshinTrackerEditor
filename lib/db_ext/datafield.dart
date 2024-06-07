import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:data_editor/widgets/gs_text_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsdatabase/gsdatabase.dart';

typedef DEdit<T extends GsModel<T>> = void Function(T v);
typedef DValidator<T extends GsModel<T>> = GsValidLevel Function(T item);
typedef DUpdate<T extends GsModel<T>> = T Function(T item);
typedef DBuilder<T extends GsModel<T>> = Widget Function(
  BuildContext context,
  T item,
  DEdit<T> edit,
  GsValidLevel level,
);

class DataButton<T extends GsModel<T>> {
  final Widget? icon;
  final String tooltip;
  final FutureOr<T> Function(BuildContext context, T item) callback;
  DataButton(this.tooltip, this.callback, {this.icon});
}

class DataField<T extends GsModel<T>> {
  final String label;
  final DBuilder<T> builder;
  final DValidator<T> validator;

  DataField._(
    this.label,
    this.builder, {
    required this.validator,
  });

  DataField.text(
    this.label,
    String Function(T item) content, {
    DUpdate<T>? swap,
  })  : builder = ((context, item, edit, level) => Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    constraints: const BoxConstraints(minHeight: 36),
                    alignment: Alignment.centerLeft,
                    child: Text(content(item)),
                  ),
                ),
                if (swap != null)
                  IconButton(
                    onPressed: () => edit(swap(item)),
                    icon: const Icon(Icons.swap_horiz_rounded),
                  ),
              ],
            )),
        validator = ((item) => GsValidLevel.good);

  DataField.button(
    this.label,
    String Function(T item) content,
    VoidCallback? onPressed, {
    required this.validator,
  }) : builder = ((context, item, edit, level) {
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
    ModifyString? autoFormat,
    required this.validator,
  }) : builder = ((context, item, edit, level) {
          var text = content(item).split('\n').first;
          if (text.length > 40) text = text.substring(0, 40);
          if (text.isNotEmpty) text = '$text...';
          return Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) => InkWell(
                    onTap: () => GsTextEditorDialog(
                      autoFormat: autoFormat,
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
                icon: Icon(Icons.paste_rounded, color: level.color),
              ),
            ],
          );
        });

  DataField.textField(
    this.label,
    String Function(T item) content,
    T Function(T item, String value) update, {
    String Function(String value)? process,
    DataButton<T>? import,
    DataButton<T>? refresh,
    required this.validator,
  }) : builder = ((context, item, edit, level) {
          final theme = Theme.of(context);
          return SizedBox(
            height: 44,
            child: Theme(
              data: theme.copyWith(
                iconTheme: theme.iconTheme.copyWith(color: level.color),
              ),
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
                      tooltip: refresh.tooltip,
                      icon: refresh.icon ?? const Icon(Icons.upload_rounded),
                      onPressed: () async =>
                          edit(await refresh.callback(context, item)),
                    ),
                  if (import != null)
                    IconButton(
                      tooltip: import.tooltip,
                      icon: import.icon ?? const Icon(Icons.bolt_outlined),
                      onPressed: () async =>
                          edit(await import.callback(context, item)),
                    ),
                  IconButton(
                    onPressed: () => edit(update(item, '')),
                    icon: const Icon(Icons.clear_rounded),
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
            ),
          );
        });

  DataField.dateTime(
    this.label,
    DateTime Function(T item) content,
    T Function(T item, DateTime value) update, {
    bool isBirthday = false,
    required this.validator,
  }) : builder = ((context, item, edit, level) {
          late final DateTime srcDate;
          late final DateTime dstDate;
          if (isBirthday) {
            srcDate = DateTime(0, 1, 1);
            dstDate = DateTime(0, 12, 31);
          } else {
            srcDate = DateTime(2020, 09, 28);
            dstDate = DateTime(2199, 12, 31);
          }
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => showDatePicker(
                    context: context,
                    initialDate:
                        content(item).clamp(min: srcDate, max: dstDate),
                    firstDate: srcDate,
                    lastDate: dstDate,
                  ).then((value) {
                    if (value == null) return;
                    edit(update(item, value));
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    constraints: const BoxConstraints(minHeight: 36),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      content(item).toString().split(' ').first,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => edit(update(item, DateTime(0, 1, 1))),
                icon: const Icon(Icons.clear_rounded),
              ),
              IconButton(
                onPressed: () => edit(update(item, DateTime.now())),
                icon: const Icon(Icons.today_rounded),
              ),
            ],
          );
        });

  static DataField<T> textList<T extends GsModel<T>>(
    String label,
    String Function(T item) content,
    T Function(T item, String value) update, {
    required DValidator<T> validator,
    DataButton<T>? import,
  }) {
    return DataField.textField(
      label,
      content,
      update,
      import: import,
      validator: validator,
      process: (value) => value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotBlank)
          .join(', '),
    );
  }

  static DataField<T> textImage<T extends GsModel<T>>(
    String label,
    String Function(T item) content,
    T Function(T item, String value) update, {
    required DValidator<T> validator,
  }) {
    return DataField.textField(
      label,
      content,
      update,
      validator: validator,
      process: (value) {
        final idx = value.indexOf('/revision');
        if (idx != -1) return value.substring(0, idx);
        return value;
      },
    );
  }

  static DataField<T> multiSelect<T extends GsModel<T>, V>(
    String label,
    List<V> Function(T item) values,
    Iterable<GsSelectItem<V>> Function(T item) options,
    T Function(T item, List<V> value) update, {
    required DValidator<T> validator,
  }) {
    return DataField._(
      label,
      (context, item, edit, level) => GsMultiSelect<V>(
        items: options(item).toList(),
        selected: values(item).toSet(),
        onConfirm: (value) => edit(update(item, value.toList())),
      ),
      validator: validator,
    );
  }

  static DataField<T> multiEnum<T extends GsModel<T>, R extends GeEnum>(
    String label,
    List<R> Function(T item) values,
    Iterable<GsSelectItem<R>> Function(T item) options,
    T Function(T item, List<R> value) update, {
    required DValidator<T> validator,
  }) {
    return DataField._(
      label,
      (context, item, edit, level) => GsMultiSelect<R>(
        items: options(item).toList(),
        selected: values(item).toSet(),
        onConfirm: (value) => edit(update(item, value.toList())),
      ),
      validator: validator,
    );
  }

  DataField.singleSelect(
    this.label,
    String Function(T item) value,
    Iterable<GsSelectItem<String>> Function(T item) items,
    T Function(T item, String value) update, {
    required this.validator,
  }) : builder = ((context, item, edit, level) => GsSingleSelect(
              items: items(item),
              selected: value(item),
              onConfirm: (value) => edit(update(item, value ?? '')),
            ));

  static DataField<T> singleSelectOf<T extends GsModel<T>, R>(
    String label,
    List<GsSelectItem<R>> items,
    R Function(T item) value,
    T Function(T item, R? value) update, {
    required DValidator<T> validator,
  }) {
    return DataField._(
      label,
      (context, item, edit, level) {
        return GsSingleSelect(
          items: items,
          selected: value(item),
          onConfirm: (value) => edit(update(item, value)),
        );
      },
      validator: validator,
    );
  }

  static DataField<T> singleEnum<T extends GsModel<T>, R extends GeEnum>(
    String label,
    List<GsSelectItem<R>> items,
    R Function(T item) value,
    T Function(T item, R value) update, {
    required DValidator<T> validator,
  }) {
    return DataField._(
      label,
      (context, item, edit, level) {
        return GsSingleSelect(
          items: items,
          selected: value(item),
          onConfirm: (value) => edit(update(item, value ?? items.first.value)),
        );
      },
      validator: validator,
    );
  }

  DataField.selectRarity(
    this.label,
    int Function(T item) value,
    T Function(T item, int value) update, {
    int min = 1,
    required this.validator,
  }) : builder = ((context, item, edit, level) => GsSingleSelect(
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
            ));

  DataField.list(
    this.label,
    Iterable<DataField<T>> Function(T item) fields,
  )   : builder = ((context, item, edit, level) =>
            getTableForFields(context, item, fields(item), edit)),
        validator = ((item) {
          return fields(item)
                  .map((e) => e.validator(item))
                  .maxBy((e) => e.index) ??
              GsValidLevel.none;
        });

  static DataField<T> build<T extends GsModel<T>, C extends GsModel<C>>(
    String label,
    List<C> Function(T item) values,
    Iterable<GsSelectItem<String>> Function(T item) options,
    DataField<C> Function(T item, C child) build,
    T Function(T item, Set<String> value) onValuesUpdated,
    T Function(T item, C field) onFieldUpdated, {
    GsValidLevel emptyLevel = GsValidLevel.warn2,
  }) {
    return DataField<T>._(
      label,
      (context, item, edit, level) {
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
                  context,
                  child,
                  build(item, child),
                  (child) => edit(onFieldUpdated(item, child)),
                );
              }).toList(),
            ),
          ],
        );
      },
      validator: (item) {
        return values(item)
                .map((e) => build(item, e).validator(e))
                .maxBy((element) => element.index) ??
            emptyLevel;
      },
    );
  }

  static DataField<T> buildList<T extends GsModel<T>, C extends GsModel<C>>(
    String label,
    List<C> Function(T item) values,
    DataField<C> Function(int index, T item, C child) build,
    C Function() create,
    T Function(T item, List<C> list) update, {
    GsValidLevel emptyLevel = GsValidLevel.error,
  }) {
    return DataField<T>._(
      label,
      (context, item, edit, level) {
        final list = values(item).toList();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () =>
                      edit(update(item, list.toList()..removeLast())),
                  icon: const Icon(Icons.remove_rounded),
                ),
                IconButton(
                  onPressed: () =>
                      edit(update(item, list.toList()..add(create()))),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: const TableBorder(
                horizontalInside: BorderSide(color: Colors.grey),
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
              ),
              columnWidths: const {0: IntrinsicColumnWidth()},
              children: list.mapIndexed((index, child) {
                return _getFieldTableRow(
                  context,
                  child,
                  build(index, item, child),
                  (child) => edit(update(item, list.toList()..[index] = child)),
                );
              }).toList(),
            ),
          ],
        );
      },
      validator: (item) {
        return values(item)
                .mapIndexed((i, e) => build(i, item, e).validator(e))
                .maxBy((element) => element.index) ??
            emptyLevel;
      },
    );
  }
}

Widget getTableForFields<T extends GsModel<T>>(
  BuildContext context,
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
        .map((field) => _getFieldTableRow(context, value, field, updateItem))
        .toList(),
  );
}

TableRow _getFieldTableRow<T extends GsModel<T>>(
  BuildContext context,
  T value,
  DataField<T> field,
  void Function(T item) edit,
) {
  final level = field.validator.call(value);
  final color = level.color;
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
        child: field.builder(context, value, edit, level),
      ),
    ],
  );
}

class ExtendedTextField extends StatefulWidget {
  final bool autoFocus;
  final String hintText;
  final String initialValue;
  final void Function(String value) onEdit;
  final void Function(String value)? onSubmit;
  final String Function(String value)? process;

  const ExtendedTextField({
    super.key,
    this.process,
    this.hintText = '',
    this.autoFocus = false,
    required this.initialValue,
    required this.onEdit,
    this.onSubmit,
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
    return TextField(
      autofocus: widget.autoFocus,
      style: const TextStyle(fontSize: 16),
      focusNode: _node,
      controller: _controller,
      maxLines: 1,
      decoration: InputDecoration.collapsed(hintText: widget.hintText),
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
        widget.onSubmit?.call(value);
        _node.unfocus();
      },
    );
  }
}
