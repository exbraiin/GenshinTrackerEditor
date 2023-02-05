import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/gs_remarkable_chest.dart';
import 'package:data_editor/db_ext/gs_weapon_info_ext.dart';

class DataValidator<T extends GsModel<T>> {
  static final artifacts = DataValidator._(getArtifactDfs);
  static final banners = DataValidator._(getBannerDfs);
  static final characters = DataValidator._(getCharacterDfs);
  static final charactersInfo = DataValidator._(getCharacterInfoDfs);
  static final charactersOutfit = DataValidator._(getCharacterOutfitDfs);
  static final cities = DataValidator._(getCityDfs);
  static final ingredients = DataValidator._(getIngredientDfs);
  static final materials = DataValidator._(getMaterialDfs);
  static final namecards = DataValidator._(getNamecardDfs);
  static final recipes = DataValidator._(getRecipeDfs);
  static final remarkableChests = DataValidator._(getRemarkableChestDfs);
  static final sereniteas = DataValidator._(getSereniteaDfs);
  static final spincrystals = DataValidator._(getSpincrystalDfs);
  static final versions = DataValidator._(getVersionDfs);
  static final weapons = DataValidator._(getWeaponDfs);
  static final weaponsInfo = DataValidator._(getWeaponInfoDfs);

  final _levels = <String, GsValidLevel>{};
  final List<DataField<T>> Function(T? item) getDataFields;

  DataValidator._(this.getDataFields);

  GsValidLevel getLevel(String id) => _levels[id] ?? GsValidLevel.good;
  GsValidLevel getMaxLevel() =>
      _levels.values.maxBy((e) => e.index) ?? GsValidLevel.good;
  GsValidLevel checkLevel(String id, T? model) {
    late final fields = getDataFields(model);
    if (model == null) {
      _levels.remove(id);
    } else if (fields.isNotEmpty) {
      final level = fields
          .map((e) => e.isValid?.call(model))
          .whereNotNull()
          .maxBy((e) => e.index);
      _levels[model.id] = level ?? GsValidLevel.good;
    }
    return getLevel(id);
  }
}
