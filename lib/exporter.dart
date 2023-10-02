import 'dart:io';

import 'package:csv/csv.dart';
import 'package:data_editor/db/database.dart';

abstract final class GsExporter {
  static Future<void> exportAll() async {
    await exportCharacters();
  }

  static Future<void> exportCharacters() async {
    const converter = ListToCsvConverter();
    final header = Database.i.characters.data.firstOrNull?.toJsonMap().keys;
    if (header == null) return;

    final data = <List<dynamic>>[];

    data.add(['id', ...header]);
    for (final model in Database.i.characters.data) {
      data.add([model.id, ...model.toJsonMap().values]);
    }

    final csv = converter.convert(data);
    await File('out.csv').writeAsString(csv);
  }
}
