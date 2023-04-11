import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

typedef _Exporter<T> = Map<String, String Function(T i)>;

class Exporter {
  static void keys() {
    final keys = Database.i.collections
        .expand((e) => e.create.call({}).toJsonMap().entries)
        .groupBy((element) => element.key)
        .entries
        .sortedByDescending((e) => e.value.length);
    if (kDebugMode) {
      for (var e in keys) {
        print('${e.key}: ${e.value.length}');
      }
    }
  }

  static Future<void> export() async {
    final excel = Excel.createExcel();

    _defaultExporter<GsArtifact>(
      excel['Artifacts'],
      Database.i.artifacts,
      {
        'Name': (i) => i.name,
        'Rarity': (i) => i.rarity.toString(),
        'Version': (i) => i.version,
        'Region': (i) => i.region,
        'Domain': (i) => i.domain,
      },
      rarity: (i) => i.rarity,
    );

    _defaultExporter<GsBanner>(
      excel['Banners'],
      Database.i.banners,
      {
        'Name': (i) => i.name,
        'Type': (i) => i.type,
        'Version': (i) => i.version,
        'Release Date': (i) => i.dateStart,
      },
    );

    _defaultExporter<GsWeapon>(
      excel['Weapons'],
      Database.i.weapons,
      {
        'Name': (i) => i.name,
        'Rarity': (i) => i.rarity.toString(),
        'Version': (i) => i.version,
        'Source': (i) => i.source,
        'Type': (i) => i.type,
        'Atk': (i) => i.atk.toString(),
        'Stat Type': (i) => i.statType,
        'Stat Value': (i) => i.statValue.toString(),
      },
      rarity: (i) => i.rarity,
    );

    final defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) excel.delete(defaultSheet);
    await File('out.xlsx').writeAsBytes(excel.encode()!);
  }

  static void _defaultExporter<T extends GsModel<T>>(
    Sheet sheet,
    GsCollection<T> collection,
    _Exporter<T> exporter, {
    int Function(T i)? rarity,
  }) {
    const family = 'Bahnschrift';
    final style = CellStyle(fontFamily: family, bold: true);
    sheet.appendRow(exporter.keys.toList());
    sheet.applyStyleToRow(sheet.maxRows - 1, style);

    for (final item in collection.data) {
      final row = exporter.values.map((e) => e.call(item)).toList();
      final t = rarity?.call(item) ?? 0;
      late final color = GsStyle.getRarityColor(t);
      final colorHex = t != 0 ? color.value.toRadixString(16) : 'FF000000';
      final style = CellStyle(fontColorHex: colorHex, fontFamily: family);
      sheet.appendRow(row);
      sheet.applyStyleToRow(sheet.maxRows - 1, style);
    }
  }
}

extension on Sheet {
  void applyStyleToRow(int index, CellStyle style) {
    final row = this.row(index);
    for (var i = 0; i < row.length; ++i) {
      final idx = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: index);
      cell(idx).cellStyle = style;
    }
  }
}
