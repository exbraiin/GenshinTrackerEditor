import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:data_editor/widgets/text_style_parser.dart';
import 'package:flutter/material.dart';

class GsTextEditorDialog extends StatefulWidget {
  final String title;
  final String initialText;
  final GsCharacterInfo? info;
  final void Function(String value) onConfirm;

  const GsTextEditorDialog({
    super.key,
    this.title = 'Edit Text',
    this.info,
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
                ),
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
          const GsSelectItem('skill', 'Skill', color: Colors.orange),
          onTap: (item) => _insertText((s) => '<color=skill>$s</color>'),
        ),
      ),
      ...GeElements.values.map((value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: GsSelectChip(
            GsSelectItem(
              value,
              value.id.toTitle(),
              color: value.color,
            ),
            onTap: (item) => _insertText((s) => '<color=$item>$s</color>'),
          ),
        );
      }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          const GsSelectItem('auto', 'Auto'),
          onTap: (item) => _autoFormatText(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          const GsSelectItem('bold', 'Bold'),
          onTap: (item) => _insertText((s) => '<b>$s</b>'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          const GsSelectItem('italic', 'Italic'),
          onTap: (item) => _insertText((s) => '<i>$s</i>'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          const GsSelectItem('underline', 'Underline'),
          onTap: (item) => _insertText((s) => '<u>$s</u>'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GsSelectChip(
          const GsSelectItem('list', 'List'),
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

  void _autoFormatText() {
    final matches = {
      'AoE Anemo DMG': 'anemo',
      'Anemo DMG Bonus': 'anemo',
      'Anemo DMG': 'anemo',
      'Anemo RES': 'anemo',
      'Anemo': 'anemo',
      'AoE Cryo DMG': 'cryo',
      'Cryo DMG Bonus': 'cryo',
      'Cryo DMG': 'cryo',
      'Cryo RES': 'cryo',
      'Cryo': 'cryo',
      'AoE Dendro DMG': 'dendro',
      'Dendro DMG Bonus': 'dendro',
      'Dendro DMG': 'dendro',
      'Dendro RES': 'dendro',
      'Dendro': 'dendro',
      'AoE Electro DMG': 'electro',
      'Electro DMG Bonus': 'electro',
      'Electro DMG': 'electro',
      'Electro RES': 'electro',
      'Electro Infusion': 'electro',
      'Electro-Charged DMG': 'electro',
      'Electro-Charged reaction DMG': 'electro',
      'Electro-related Elemental Reaction': 'electro',
      'Electro': 'electro',
      'AoE Geo DMG': 'geo',
      'Geo Construct': 'geo',
      'Geo DMG Bonus': 'geo',
      'Geo DMG': 'geo',
      'Geo': 'geo',
      'AoE Hydro DMG': 'hydro',
      'Hydro DMG Bonus': 'hydro',
      'Hydro DMG': 'hydro',
      'Hydro RES': 'hydro',
      'Hydro Infusion': 'hydro',
      'Hydro-related Elemental Reactions': 'hydro',
      'Hydro': 'hydro',
      'Wet': 'hydro',
      'AoE Pyro DMG': 'pyro',
      'Pyro DMG Bonus': 'pyro',
      'Pyro DMG': 'pyro',
      'Pyro RES': 'pyro',
      'Pyro': 'pyro',
    };

    if (widget.info != null) {
      matches.addEntries([
        ...widget.info!.talents
            .map((e) => MapEntry(e.name, 'skill'))
            .where((e) => e.key.isNotEmpty),
        ...widget.info!.constellations
            .map((e) => MapEntry(e.name, 'skill'))
            .where((e) => e.key.isNotEmpty),
      ]);
    }

    var finalText = '';
    final text = _controller.text.toLowerCase();
    for (var i = 0;; i < text.length) {
      var min = -1;
      MapEntry<String, String>? tEntry;
      for (final entry in matches.entries) {
        final t = text.indexOf(entry.key.toLowerCase(), i);
        if (t == -1) continue;
        if (t < min || min == -1) {
          min = t;
          tEntry = entry;
        }
      }

      if (tEntry != null) {
        finalText += _controller.text.substring(i, min);
        finalText += '<color=${tEntry.value}>${tEntry.key}</color>';
        i = min + tEntry.key.length;
      } else {
        finalText += _controller.text.substring(i);
        break;
      }
    }
    _controller.text = finalText;
  }
}
