import 'package:dartx/dartx.dart';
import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/widgets/gs_notifier_provider.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final ValueNotifier<bool> _invalid;
  late final ValueNotifier<String> _notifier;

  bool _isExpanded(String version) => version == _notifier.value;

  @override
  void initState() {
    super.initState();
    _invalid = ValueNotifier(false);
    _notifier = ValueNotifier('');
  }

  @override
  void dispose() {
    _invalid.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Screen'),
        actions: [
          IconButton(
            onPressed: () => _invalid.value = !_invalid.value,
            icon: const Icon(Icons.swap_horiz_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: GsStyle.kMainDecoration,
        child: StreamBuilder(
          stream: Database.i.modified,
          builder: (context, snapshot) {
            return ValueListenableBuilder(
              valueListenable: _invalid,
              builder: (context, value, child) {
                if (value) {
                  return _getInvalidList();
                }
                return _getInfoList();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _getInvalidList() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: _validateList(context).expand((record) {
        final color0 = GsStyle.getVersionColor(record.version);
        final color1 = Color.lerp(color0, Colors.black, 0.6)!;
        return [
          Container(
            height: 44,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color0, color1],
                stops: const [0, 0.25],
              ),
              border: Border.all(width: 2, color: color1),
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8),
            child: Text('Version ${record.version}'),
          ),
          ...record.items.map((record) {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x66FFFFFF)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(record.label),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 6,
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: record.items.toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
        ];
      }).toList(),
    );
  }

  Widget _getInfoList() {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, value, child) {
        return ListView(
          padding: const EdgeInsets.all(8).copyWith(bottom: 0),
          children: Database.i
              .of<GsVersion>()
              .items
              .sortedByDescending((e) => e.releaseDate)
              .map(_getChild)
              .toList(),
        );
      },
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
          _getByVersion<GsAchievementGroup>(version.id),
          _getByVersion<GsAchievement>(version.id),
          _getByVersion<GsArtifact>(version.id),
          _getByVersion<GsBanner>(version.id),
          _getByVersion<GsCharacter>(version.id),
          _getByVersion<GsCharacterSkin>(version.id),
          _getByVersion<GsEnemy>(version.id),
          _getByVersion<GsMaterial>(version.id),
          _getByVersion<GsNamecard>(version.id),
          _getByVersion<GsRecipe>(version.id),
          _getByVersion<GsFurnitureChest>(version.id),
          _getByVersion<GsSereniteaSet>(version.id),
          _getByVersion<GsFurnishing>(version.id),
          _getByVersion<GsSpincrystal>(version.id),
          _getByVersion<GsViewpoint>(version.id),
          _getByVersion<GsEvent>(version.id),
          _getByVersion<GsWeapon>(version.id),
          _getByVersion<GsBattlepass>(version.id),
        ],
      ),
    );
  }

  Widget _getByVersion<T extends GsModel<T>>(String version) {
    if (!_isExpanded(version)) return const SizedBox();
    final config = GsConfigs.of<T>();
    if (config == null) return const SizedBox();
    final versionItems = config.collection.items
        .where((e) => config.itemDecoration(e).version == version);
    if (versionItems.isEmpty) return const SizedBox();

    Widget badge(Color color) {
      return Container(
        width: 12,
        height: 12,
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
    return GsNotifierProvider(
      value: false,
      builder: (context, notifier, child) {
        return Column(
          children: [
            InkWell(
              onTap: () => notifier.value = !notifier.value,
              child: Container(
                height: 32,
                color: vColor.withOpacity(0.4),
                child: Center(
                  child: Text('${config.title} (${versionItems.length})'),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, value, child) {
                if (!value) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: versionItems.map<Widget>((item) {
                      final decor = config.itemDecoration(item);
                      final level = DataValidator.i.getLevel<T>(item.id);
                      Widget widget = GsSelectChip(
                        GsSelectItem(
                          item,
                          decor.label,
                          color: decor.color ?? GsStyle.getRarityColor(1),
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
                              top: -2,
                              right: -2,
                              child: badge(levelColor),
                            ),
                          ],
                        );
                      }
                      return widget;
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

typedef _InvalidLine = ({Iterable<GsSelectChip> items, String label});
typedef _VersionLine = ({String version, List<_InvalidLine> items});

Iterable<_VersionLine> _validateList(BuildContext context) sync* {
  Iterable<T> items<T extends GsModel<T>>() => Database.i.of<T>().items;

  GsVersion? next;
  final versions = items<GsVersion>().sortedDescending();
  for (final version in versions) {
    final buffer = <_InvalidLine>[];

    void addItems<T extends GsModel<T>>(
      String label, [
      Iterable<T?> values = const [],
    ]) {
      if (T == GsVersion) {
        return buffer.add((items: [], label: label));
      }
      final config = GsConfigs.of<T>();
      final items = values.map((value) {
        final decor = value != null ? config?.itemDecoration(value) : null;
        return GsSelectChip(
          GsSelectItem(
            value,
            decor?.label ?? T.toString(),
            color: value != null && config != null
                ? config.itemDecoration(value).color ??
                    GsStyle.getRarityColor(1)
                : Colors.grey,
          ),
          onTap: (item) => config?.openEditScreen(context, item),
        );
      }).toList();
      buffer.add((items: items, label: label));
    }

    final battlepass =
        items<GsBattlepass>().firstOrNullWhere((e) => e.version == version.id);
    if (battlepass == null) {
      addItems<GsBattlepass>('Missing battlepass!', [null]);
    }

    const minEvents = 5;
    final events = items<GsEvent>().count((e) => e.version == version.id);
    if (events < minEvents) {
      final missing = minEvents - events;
      addItems<GsEvent>('Missing $missing events!', [null]);
    }

    final banners = items<GsBanner>().where((e) => e.version == version.id);
    final weapons = items<GsWeapon>().where((e) => e.version == version.id);
    final chars = items<GsCharacter>().where((e) => e.version == version.id);
    final weaponWrongSource = weapons.where((e) => !e.hasValidSource);
    if (weaponWrongSource.isNotEmpty) {
      addItems('Wrong source:', weaponWrongSource);
    }

    final charWrongSource = chars.where((e) => !e.hasValidSource);
    if (charWrongSource.isNotEmpty) {
      addItems('Wrong source:', charWrongSource);
    }

    // Ignore version 1.0
    final charMissingBanner = chars.where(
      (e) =>
          e.version != '1.0' &&
          e.isWishable &&
          !banners.any((b) => b.containsCharacter(e)),
    );
    if (charMissingBanner.isNotEmpty) {
      addItems('Missing banner:', charMissingBanner);
    }

    final lists = banners
        .where((e) => e.type == GeBannerType.character)
        .groupBy((e) => e.dateStart)
        .values
        .where((e) => e.distinctBy((b) => b.subtype).length == 1)
        .where((e) => e.length != 1);

    for (final list in lists) {
      addItems('${list.length} as character type for the same date!', list);
    }

    final charWrongReleaseDate = chars.where(
      (char) =>
          char.releaseDate.isBefore(version.releaseDate) ||
          next != null && char.releaseDate.isAfter(next.releaseDate),
    );
    if (charWrongReleaseDate.isNotEmpty) {
      addItems('Wrong version or release date', charWrongReleaseDate);
    }

    final sets = items<GsSereniteaSet>();
    final charMissingGift =
        chars.where((e) => sets.count((s) => s.chars.contains(e.id)) != 2);
    if (charMissingGift.isNotEmpty) {
      addItems('Missing Serenitea Gift', charMissingGift);
    }

    final recipes = items<GsRecipe>();
    final versionRecipes = recipes.where((e) => e.version == version.id);
    final charRecipes = versionRecipes.where((e) => e.baseRecipe.isNotEmpty);

    final isNotPermanent =
        charRecipes.where((e) => e.type != GeRecipeType.permanent);
    if (isNotPermanent.isNotEmpty) {
      addItems('Recipes are not permanent:', isNotPermanent);
    }
    final notSameEffect = charRecipes.where(
      (e) =>
          e.effect !=
          recipes.firstOrNullWhere((r) => r.id == e.baseRecipe)?.effect,
    );
    if (notSameEffect.isNotEmpty) {
      addItems('Recipes dont have same effect:', notSameEffect);
    }

    next = version;
    if (buffer.isNotEmpty) {
      yield (version: version.id, items: buffer);
    }
  }
}

extension on GsCharacter {
  bool get isWishable =>
      source == GeItemSourceType.wishesStandard ||
      source == GeItemSourceType.wishesCharacterBanner;

  bool get hasValidSource {
    const valid = [
      GeItemSourceType.event,
      GeItemSourceType.wishesStandard,
      GeItemSourceType.wishesCharacterBanner,
    ];
    return valid.contains(source);
  }
}

extension on GsWeapon {
  bool get hasValidSource {
    if (rarity != 5) return source != GeItemSourceType.wishesCharacterBanner;
    return source == GeItemSourceType.wishesWeaponBanner ||
        source == GeItemSourceType.wishesStandard;
  }
}

extension on GsBanner {
  bool containsCharacter(GsCharacter char) {
    if (type != GeBannerType.character) return false;
    if (char.rarity == 4) return feature4.contains(char.id);
    if (char.rarity == 5) return feature5.contains(char.id);
    return false;
  }
}
