import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/widgets.dart';
import 'package:flutter/material.dart';

class GsItemDecor {
  final Color color;
  final String label;
  final String version;
  GsItemDecor(this.label, this.version, this.color);
}

class TableGeneric<T extends GsModel> extends StatelessWidget {
  final String title;
  final List<T> Function() list;
  final DataValidator? validator;

  final GsItemDecor Function(T i) getDecor;
  final void Function(BuildContext context, T? i)? onTap;

  const TableGeneric({
    super.key,
    required this.title,
    required this.list,
    required this.getDecor,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => onTap?.call(context, null),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Database.i.modified,
        builder: (context, snapshot) {
          return GsGridView(
            children: list().map((item) {
              final level = validator?.getLevel(item.id) ?? GsValidLevel.good;
              final decor = getDecor(item);
              return GsGridItem(
                color: decor.color,
                label: decor.label,
                version: decor.version,
                validLevel: level,
                onTap: () => onTap?.call(context, item),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
