import 'dart:io';

import 'package:csv/csv.dart';
import 'package:data_editor/db/database.dart';
import 'package:gsdatabase/gsdatabase.dart';

const _converter = ListToCsvConverter();

abstract final class GsExporter {
  static Future<void> exportAll() {
    return Future.wait([
      _genericExport(
        collection: Database.i.of<GsAchievementGroup>(),
        filename: 'achievement_groups',
      ),
      _genericExport(
        collection: Database.i.of<GsCharacter>(),
        filename: 'characters',
      ),
    ]);
  }

  static Future<void> _genericExport<T extends GsModel<T>>({
    required Items<GsModel<T>> collection,
    required String filename,
  }) async {
    final header = collection.items.firstOrNull?.toMap().keys;
    if (header == null) return;

    final data = <List<dynamic>>[];

    data.add(['id', ...header]);
    for (final model in collection.items) {
      data.add([model.id, ...model.toMap().values]);
    }

    final csv = _converter.convert(data);
    final dir = Directory('export');
    if (!await dir.exists()) await dir.create();
    await File('export/$filename.csv').writeAsString(csv);
  }
}
