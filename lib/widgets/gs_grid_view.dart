import 'package:data_editor/style/style.dart';
import 'package:flutter/material.dart';

class GsGridView extends StatelessWidget {
  final List<Widget> children;

  const GsGridView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GsStyle.kMainDecoration,
      child: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 1,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          maxCrossAxisExtent: 120,
        ),
        children: children,
      ),
    );
  }
}
