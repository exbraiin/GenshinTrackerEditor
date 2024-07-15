import 'dart:io';

import 'package:dartx/dartx_io.dart';

void main() {
  _generateAssets();
}

Future<void> _generateAssets() async {
  final pub = File('pubspec.yaml');
  final lines = await pub.readAsLines();
  final paths = lines
      .skipWhile((l) => !l.trim().startsWith('assets:'))
      .skip(1)
      .takeWhile((l) => l.trim().startsWith('- '))
      .map((l) => l.trim().substring(2));

  final buffer = StringBuffer();
  buffer.writeln('// ############################################');
  buffer.writeln('// ## GENERATED CODE - DO NOT MODIFY BY HAND ##');
  buffer.writeln('// ############################################');
  buffer.writeln();

  buffer.writeln('abstract final class Assets{');

  var space = false;
  void writeField(File file) {
    final name = _toVarName(file.nameWithoutExtension).decapitalize();
    if (space) buffer.writeln();
    buffer.writeln('  /// ${file.name}');
    buffer.writeln('  static const $name = \'${file.path}\';');
    space = true;
  }

  for (final path in paths) {
    final file = File(path);
    if (await file.exists()) {
      writeField(file);
      continue;
    }

    final dir = Directory(path);
    if (await dir.exists()) {
      final files = (await dir.list().toList()).whereType<File>();
      for (final file in files) {
        writeField(file);
      }
      continue;
    }
  }

  buffer.writeln('}');
  await File('lib/style/assets.dart').writeAsString(buffer.toString());
}

String _toVarName(String word, [String prefix = 'asset_']) {
  bool isChar(int v) => v.between(65, 90) || v.between(97, 122);
  bool isNum(int v) => v.between(48, 57);
  final words = '${isChar(word.runes.first) ? '' : prefix}$word'
      .runes
      .map((e) => isChar(e) || isNum(e) ? String.fromCharCode(e) : '_')
      .join()
      .split('_')
      .where((e) => e.isNotEmpty);
  return '${words.first}${words.skip(1).map((w) => w.capitalize()).join()}';
}
