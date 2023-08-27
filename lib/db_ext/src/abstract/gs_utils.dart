import 'package:data_editor/db/database.dart';

sealed class GsUtils {
  GsUtils._();

  static GsCollection<R>? getCollectionOf<R extends GsModel<R>>() {
    return switch (R) {
      GsAchievement => Database.i.achievements,
      GsAchievementGroup => Database.i.achievementGroups,
      GsArtifact => Database.i.artifacts,
      GsBanner => Database.i.banners,
      GsCharacter => Database.i.characters,
      GsCharacterInfo => Database.i.characterInfo,
      GsCharacterOutfit => Database.i.characterOutfit,
      _ => null,
    } as GsCollection<R>?;
  }
}
