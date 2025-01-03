import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsEnvisagedEchoExt extends GsModelExt<GsEnvisagedEcho> {
  const GsEnvisagedEchoExt();

  @override
  List<DataField<GsEnvisagedEcho>> getFields(String? editId) {
    final vd = ValidateModels<GsEnvisagedEcho>();
    final vdVersion = ValidateModels.versions();
    final vdCharacters = ValidateModels<GsCharacter>();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vd.validateItemId(item, editId),
        refresh: DataButton(
          'Generate Id',
          (context, item) => item.copyWith(id: expectedId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.textField(
        'Description',
        (item) => item.description,
        (item, value) => item.copyWith(description: value),
      ),
      DataField.textImage(
        'Icon',
        (item) => item.icon,
        (item, value) => item.copyWith(icon: value),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
      ),
      DataField.singleSelect(
        'Character',
        (item) => item.character,
        (item) => vdCharacters.filters,
        (item, value) => item.copyWith(character: value),
        validator: (item) => vdCharacters.validate(item.character),
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
    ];
  }
}
