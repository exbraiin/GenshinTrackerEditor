import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_selector/gs_selector.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';

extension GeEnumListExt<T extends GeEnum> on List<T> {
  List<GsSelectItem<T>> toChips() {
    Color getColor(T value) {
      if (value is GeWeekdayType) {
        return GeElementType.values[value.index].color;
      }
      if (value is GeElementType) return value.color;
      if (value is GeBannerType) return value.color;
      if (value is GeSereniteaSetType) return value.color;

      return Colors.grey;
    }

    String getAsset(T value) {
      if (value is GeRecipeEffectType) {
        return GsGraphics.getRecipeEffectIcon(value.id);
      }
      return '';
    }

    return map((value) {
      return GsSelectItem(
        value,
        value.id.isEmpty ? 'None' : value.id.toTitle(),
        color: getColor(value),
        asset: getAsset(value),
      );
    }).toList();
  }
}

extension GeElementTypeExt on GeElementType {
  Color get color => switch (this) {
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
      };
}

extension GeSereniteaSetTypeExt on GeSereniteaSetType {
  Color get color => switch (this) {
        GeSereniteaSetType.indoor => const Color(0xFFA01F2E),
        GeSereniteaSetType.outdoor => const Color(0xFF303671),
      };
}
