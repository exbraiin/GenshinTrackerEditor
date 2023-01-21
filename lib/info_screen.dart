import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/style.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final ValueNotifier<String> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier('');
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info Screen')),
      body: ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, value, child) {
          return ListView(
            padding: const EdgeInsets.all(8).copyWith(bottom: 0),
            children: Database.i.versions.data.reversed
                .map((version) => _getChild(version, value == version.id))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _getChild(GsVersion version, bool expanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(8),
                bottom: expanded ? Radius.zero : const Radius.circular(8),
              ),
            ),
            child: InkWell(
              onTap: () => _notifier.value = version.id,
              child: Center(
                child: Text(version.id),
              ),
            ),
          ),
          _getByVersion(
            'Artifacts',
            version.id,
            expanded,
            Database.i.artifacts,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
          _getByVersion(
            'Banners',
            version.id,
            expanded,
            Database.i.banners,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getBannerColor(i.type),
          ),
          _getByVersion(
            'Characters',
            version.id,
            expanded,
            Database.i.characters,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
          _getByVersion(
            'Ingredients',
            version.id,
            expanded,
            Database.i.ingredients,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
          _getByVersion(
            'Materials',
            version.id,
            expanded,
            Database.i.materials,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
          _getByVersion(
            'Namecards',
            version.id,
            expanded,
            Database.i.namecards,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getNamecardColor(i.type),
          ),
          _getByVersion(
            'Recipes',
            version.id,
            expanded,
            Database.i.recipes,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
          _getByVersion(
            'Remarkable Chests',
            version.id,
            expanded,
            Database.i.remarkableChests,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
          _getByVersion(
            'Sereniteas',
            version.id,
            expanded,
            Database.i.sereniteas,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getSereniteaColor(i.category),
          ),
          _getByVersion(
            'Spincrystal',
            version.id,
            expanded,
            Database.i.spincrystal,
            (i) => i.version,
            (i) => i.number.toString(),
            (i) => GsStyle.getRarityColor(5),
          ),
          _getByVersion(
            'Weapons',
            version.id,
            expanded,
            Database.i.weapons,
            (i) => i.version,
            (i) => i.name,
            (i) => GsStyle.getRarityColor(i.rarity),
          ),
        ],
      ),
    );
  }

  Widget _getByVersion<T extends GsModel>(
    String title,
    String version,
    bool expanded,
    GsCollection<T> collection,
    String Function(T i) gVersion,
    String Function(T i) label,
    Color Function(T i) color,
  ) {
    if (!expanded) return const SizedBox();
    final versionItems = collection.data.where((e) => gVersion(e) == version);
    if (versionItems.isEmpty) return const SizedBox();

    return Column(
      children: [
        Container(
          height: 32,
          color: Colors.black.withOpacity(0.4),
          child: Center(child: Text('$title (${versionItems.length})')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: versionItems
                .map((e) => Container(
                      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                      decoration: BoxDecoration(
                        color: color(e).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: color(e).withOpacity(0.8)),
                      ),
                      child: Text(label(e)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
