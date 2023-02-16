import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsSingleSelect<T> extends StatelessWidget {
  final String title;
  final T? selected;
  final Iterable<GsSelectItem<T>> items;
  final void Function(T? value) onConfirm;

  const GsSingleSelect({
    super.key,
    this.title = 'Select',
    required this.items,
    required this.selected,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _SelectDialog<T>(
        title: title,
        items: items,
        selected: selected,
        onConfirm: onConfirm,
      ).show(context),
      child: Container(
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        child: !items.any((e) => e.value == selected)
            ? Text(selected?.toString() ?? title)
            : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: items
                    .where((e) => e.value == selected)
                    .map(GsSelectChip.new)
                    .toList(),
              ),
      ),
    );
  }
}

class _SelectDialog<T> extends StatefulWidget {
  final String title;
  final T? selected;
  final Iterable<GsSelectItem<T>> items;
  final void Function(T? value) onConfirm;

  const _SelectDialog({
    required this.title,
    required this.items,
    required this.selected,
    required this.onConfirm,
  });

  void show(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => this,
      );

  @override
  State<_SelectDialog<T>> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<_SelectDialog<T>> {
  late final TextEditingController _searching;

  @override
  void initState() {
    super.initState();
    _searching = TextEditingController();
  }

  @override
  void dispose() {
    _searching.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.longestSide / 8;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: pad),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searching,
                    decoration: const InputDecoration(hintText: 'Search'),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: _searching,
                    builder: (context, controller, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.items.map((item) {
                            final hide = controller.text.isNotEmpty &&
                                !item.label
                                    .toLowerCase()
                                    .contains(controller.text.toLowerCase());
                            return GsSelectChip(
                              item,
                              hide: hide,
                              selected: widget.selected == item.value,
                              onTap: (id) {
                                final v = widget.selected == id ? null : id;
                                widget.onConfirm(v);
                                Navigator.of(context).maybePop();
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
