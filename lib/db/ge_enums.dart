import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

extension GeEnumListExt<T extends GeEnum> on List<T> {
  List<GsSelectItem<T>> toChips() => _toChips((i) => i);
  List<GsSelectItem<String>> toChipsId() => _toChips((i) => i.id);
  List<GsSelectItem<R>> _toChips<R>(R Function(T) selector) {
    return map((value) {
      final (Color color, String asset) = switch (value) {
        final GeWeekdayType item => (item.color, ''),
        final GeElementType item => (item.color, ''),
        final GeBannerType item => (item.color, ''),
        final GeSereniteaSetType item => (item.color, ''),
        final GeRegionType item => (item.color, ''),
        final GeRecipeEffectType item => (
            Colors.grey,
            GsGraphics.getRecipeEffectIcon(item),
          ),
        _ => (Colors.grey, ''),
      };
      return GsSelectItem(
        selector(value),
        value.id.isEmpty ? 'None' : value.id.toTitle(),
        color: color,
        asset: asset,
      );
    }).toList();
  }
}

extension on GeRegionType {
  Color get color => element.color;

  GeElementType get element => switch (this) {
        GeRegionType.none => GeElementType.none,
        GeRegionType.mondstadt => GeElementType.anemo,
        GeRegionType.liyue => GeElementType.geo,
        GeRegionType.inazuma => GeElementType.electro,
        GeRegionType.sumeru => GeElementType.dendro,
        GeRegionType.fontaine => GeElementType.hydro,
        GeRegionType.natlan => GeElementType.pyro,
        GeRegionType.snezhnaya => GeElementType.cryo,
        GeRegionType.khaenriah => GeElementType.none,
      };
}

extension on GeWeekdayType {
  Color get color => switch (this) {
        GeWeekdayType.sunday => const Color(0xFFf140aa),
        GeWeekdayType.monday => const Color(0xFFf1565a),
        GeWeekdayType.tuesday => const Color(0xFFf68d5a),
        GeWeekdayType.wednesday => const Color(0xFFfdc56f),
        GeWeekdayType.thursday => const Color(0xFF47ba7a),
        GeWeekdayType.friday => const Color(0xFF586fb2),
        GeWeekdayType.saturday => const Color(0xFFa06eb1),
      };
}

extension GeElementTypeExt on GeElementType {
  Color get color => switch (this) {
        GeElementType.none => Colors.grey,
        GeElementType.anemo => const Color(0xFF71c2a7),
        GeElementType.geo => const Color(0xFFf2b723),
        GeElementType.electro => const Color(0xFFb38dc1),
        GeElementType.dendro => const Color(0xFF9cc928),
        GeElementType.hydro => const Color(0xFF5fc1f1),
        GeElementType.pyro => const Color(0xFFea7838),
        GeElementType.cryo => const Color(0xFFa4d6e3),
      };
}

extension GeBannerTypeExt on GeBannerType {
  Color get color => switch (this) {
        GeBannerType.standard => Colors.purple,
        GeBannerType.beginner => Colors.yellow,
        GeBannerType.character => Colors.lightGreen,
        GeBannerType.weapon => Colors.lightBlue,
        GeBannerType.chronicled => const Color(0xFF5da8a8),
      };
}

extension GeSereniteaSetTypeExt on GeSereniteaSetType {
  Color get color => switch (this) {
        GeSereniteaSetType.none => Colors.grey,
        GeSereniteaSetType.indoor => const Color(0xFFA01F2E),
        GeSereniteaSetType.outdoor => const Color(0xFF303671),
      };
}
