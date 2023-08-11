import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class GsMultiSelect<T> extends StatelessWidget {
  final String? text;
  final String title;
  final Set<T> selected;
  final List<GsSelectItem<T>> items;
  final void Function(Set<T> value) onConfirm;

  const GsMultiSelect({
    super.key,
    this.text,
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
        child: selected.isEmpty || text != null
            ? Text(text ?? title)
            : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: selected
                    .map((item) => items.firstWhere((e) => e.value == item))
                    .map((e) => GsSelectChip(e, disableImage: true))
                    .toList(),
              ),
      ),
    );
  }
}

class _SelectDialog<T> extends StatefulWidget {
  final String title;
  final Set<T> selected;
  final List<GsSelectItem<T>> items;
  final void Function(Set<T> value) onConfirm;

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
  late final ValueNotifier<Set<T>> _notifier;
  late final TextEditingController _searching;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(widget.selected);
    _searching = TextEditingController();
  }

  @override
  void dispose() {
    _notifier.dispose();
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
                      return ValueListenableBuilder(
                        valueListenable: _notifier,
                        builder: (context, selected, child) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: widget.items.map((item) {
                                final hide = controller.text.isNotEmpty &&
                                    !item.label.toLowerCase().contains(
                                          controller.text.toLowerCase(),
                                        );
                                return GsSelectChip(
                                  item,
                                  hide: hide,
                                  selected: selected.contains(item.value),
                                  onTap: (id) {
                                    final newSet = selected.toSet();
                                    if (newSet.contains(id)) {
                                      newSet.remove(id);
                                    } else {
                                      newSet.add(id);
                                    }
                                    _notifier.value = newSet;
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        widget.onConfirm(_notifier.value);
                        Navigator.of(context).maybePop();
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
