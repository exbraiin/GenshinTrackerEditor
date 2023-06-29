import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/exporter.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final ValueNotifier<String> _notifier;

  bool _isExpanded(String version) => version == _notifier.value;

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
      appBar: AppBar(
        title: const Text('Info Screen'),
        actions: const [
          IconButton(
            onPressed: Exporter.export,
            icon: Icon(Icons.download_for_offline_rounded),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Database.i.modified,
        builder: (context, snapshot) {
          return ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (context, value, child) {
              return ListView(
                padding: const EdgeInsets.all(8).copyWith(bottom: 0),
                children:
                    Database.i.versions.data.reversed.map(_getChild).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getChild(GsVersion version) {
    final expanded = _isExpanded(version.id);
    final vColor = GsStyle.getVersionColor(version.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: vColor.withOpacity(0.2),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: vColor.withOpacity(0.6),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(8),
                bottom: expanded ? Radius.zero : const Radius.circular(8),
              ),
            ),
            child: InkWell(
              onTap: () {
                _notifier.value =
                    _notifier.value != version.id ? version.id : '';
              },
              child: Center(
                child: Text(version.id),
              ),
            ),
          ),
          _getByVersion<GsAchievementCategory>(version.id),
          _getByVersion<GsAchievement>(version.id),
          _getByVersion<GsArtifact>(version.id),
          _getByVersion<GsBanner>(version.id),
          _getByVersion<GsCharacter>(version.id),
          _getByVersion<GsIngredient>(version.id),
          _getByVersion<GsMaterial>(version.id),
          _getByVersion<GsNamecard>(version.id),
          _getByVersion<GsRecipe>(version.id),
          _getByVersion<GsRemarkableChest>(version.id),
          _getByVersion<GsSerenitea>(version.id),
          _getByVersion<GsSpincrystal>(version.id),
          _getByVersion<GsViewpoint>(version.id),
          _getByVersion<GsWeapon>(version.id),
        ],
      ),
    );
  }

  Widget _getByVersion<T extends GsModel<T>>(String version) {
    if (!_isExpanded(version)) return const SizedBox();
    final config = GsConfigs.getConfig<T>();
    if (config == null) return const SizedBox();
    final versionItems = config.collection.data
        .where((e) => config.getDecor(e).version == version);
    if (versionItems.isEmpty) return const SizedBox();

    Widget badge(Color color) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Color.lerp(color, Colors.white, 0.2)!,
          ),
          gradient: LinearGradient(
            colors: [
              color,
              Color.lerp(color, Colors.black, 0.2)!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    final vColor = GsStyle.getVersionColor(version);
    return Column(
      children: [
        Container(
          height: 32,
          color: vColor.withOpacity(0.4),
          child: Center(
            child: Text('${config.title} (${versionItems.length})'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: versionItems.map<Widget>((item) {
              final decor = config.getDecor(item);
              final level = config.collection.validator.getLevel(item.id);
              Widget widget = GsSelectChip(
                GsSelectItem(
                  item,
                  decor.label,
                  color: decor.color,
                ),
                onTap: (item) => config.openEditScreen(context, item),
              );
              final levelColor = level.color;
              if (levelColor != null) {
                widget = Stack(
                  clipBehavior: Clip.none,
                  children: [
                    widget,
                    Positioned(
                      top: -4,
                      right: -4,
                      child: badge(levelColor),
                    ),
                  ],
                );
              }
              return widget;
            }).toList(),
          ),
        ),
      ],
    );
  }
}
