import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsCharacterSkinExt extends GsModelExt<GsCharacterSkin> {
  const GsCharacterSkinExt();

  @override
  List<DataField<GsCharacterSkin>> getFields(GsCharacterSkin? model) {
    final ids = Database.i.of<GsCharacterSkin>().ids;
    final versions = GsItemFilter.versions().ids;
    final characters = GsItemFilter.chars().ids;

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, model, ids),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: generateId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
        validator: (item) => vdText(item.name),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.singleSelect(
        'Character',
        (item) => item.character,
        (item) => GsItemFilter.chars().filters,
        (item, value) => item.copyWith(character: value),
        validator: (item) => vdContains(item.character, characters),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
        validator: (item) => vdImage(item.image),
      ),
      DataField.textImage(
        'Side Image',
        (item) => item.sideImage,
        (item, value) => item.copyWith(sideImage: value),
        validator: (item) => vdImage(item.sideImage),
      ),
      DataField.textImage(
        'Full Image',
        (item) => item.fullImage,
        (item, value) => item.copyWith(fullImage: value),
        validator: (item) => vdImage(item.fullImage),
      ),
    ];
  }
}
