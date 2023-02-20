import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:data_editor/widgets/text_style_parser.dart';
import 'package:flutter/material.dart';

class GsTextEditorDialog extends StatefulWidget {
  final String title;
  final String initialText;
  final void Function(String value) onConfirm;

  const GsTextEditorDialog({
    super.key,
    this.title = 'Edit Text',
    required this.initialText,
    required this.onConfirm,
  });

  void show(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => this,
      );

  @override
  State<GsTextEditorDialog> createState() => _GsTextEditorDialogState();
}

class _GsTextEditorDialogState<T> extends State<GsTextEditorDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.black12,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, value, child) {
                          return TextParserWidget(value.text);
                        },
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
                SizedBox(
                  height: 26,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _items(),
                  ),
                ),
                const Divider(color: Colors.grey),
                Expanded(
                  child: Container(
                    color: Colors.black12,
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration.collapsed(hintText: ''),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                        widget.onConfirm(_controller.text);
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

  List<Widget> _items() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          GsSelectItem('skill', 'Skill', color: Colors.orange),
          onTap: (item) => _insertText((s) => '<color=skill>$s</color>'),
        ),
      ),
      ...GsConfigurations.elements.map((value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: GsSelectChip(
            GsSelectItem(
              value,
              value.toTitle(),
              color: GsStyle.getElementColor(value),
            ),
            onTap: (item) => _insertText((s) => '<color=$item>$s</color>'),
          ),
        );
      }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          GsSelectItem('bold', 'Bold'),
          onTap: (item) => _insertText((s) => '<b>$s</b>'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          GsSelectItem('italic', 'Italic'),
          onTap: (item) => _insertText((s) => '<i>$s</i>'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          GsSelectItem('underline', 'Underline'),
          onTap: (item) => _insertText((s) => '<u>$s</u>'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          GsSelectItem('list', 'List'),
          onTap: (item) =>
              _insertText((s) => s.split('\n').map((e) => '● $e').join('\n')),
        ),
      ),
    ];
  }

  void _insertText(String Function(String selected) nText) {
    final text = _controller.text;
    final textSelection = _controller.selection;

    final nSrc = textSelection.start;
    final nDst = textSelection.end;
    if (nSrc == -1 || nDst == -1) return;
    final vText = nSrc != nDst && nSrc != -1 && nDst != -1
        ? text.substring(nSrc, nDst)
        : '';

    final myText = nText(vText);
    final newText = text.replaceRange(nSrc, nDst, myText);
    final myTextLength = myText.length;
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }
}
