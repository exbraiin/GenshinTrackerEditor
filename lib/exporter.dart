import 'dart:io';

import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:excel/excel.dart';

class Exporter {
  static Future<void> export() async {
    final excel = Excel.createExcel();
    final sheet = excel['weapons'];
    excel.delete('Sheet1');

    final row = [
      'Name',
      'Rarity',
      'Version',
      'Source',
      'Type',
      'Atk',
      'Stat Type',
      'Stat Value',
    ];
    sheet.appendRow(row);
    sheet.applyStyleToRow(
      sheet.maxRows - 1,
      CellStyle(fontFamily: 'Bahnschrift', bold: true),
    );

    for (var item in Database.i.weapons.data) {
      final row = [
        item.name,
        item.rarity,
        item.version,
        item.source,
        item.type,
        item.atk,
        item.statType,
        item.statValue,
      ];
      sheet.appendRow(row);
      sheet.applyStyleToRow(
        sheet.maxRows - 1,
        CellStyle(
          fontColorHex:
              GsStyle.getRarityColor(item.rarity).value.toRadixString(16),
          fontFamily: 'Bahnschrift',
        ),
      );
    }

    await File('out.xlsx').writeAsBytes(excel.encode()!);
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
