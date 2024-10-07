import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsNamecardExt extends GsModelExt<GsNamecard> {
  const GsNamecardExt();

  @override
  List<DataField<GsNamecard>> getFields(String? editId) {
    final vd = ValidateModels<GsNamecard>();
    final vdVersion = ValidateModels.versions();

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vd.validateItemId(item, editId),
        refresh: DataButton(
          'Generate Id',
          (ctx, item) => item.copyWith(id: expectedId(item)),
        ),
      ),
      DataField.textField(
        'Name',
        (item) => item.name,
        (item, value) => item.copyWith(name: value),
      ),
      DataField.singleEnum(
        'Type',
        GeNamecardType.values.toChips(),
        (item) => item.type,
        (item, value) => item.copyWith(type: value),
        invalid: [GeNamecardType.none],
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        min: 4,
      ),
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.textImage(
        'Image',
        (item) => item.image,
        (item, value) => item.copyWith(image: value),
      ),
      DataField.textImage(
        'Background',
        (item) => item.fullImage,
        (item, value) => item.copyWith(fullImage: value),
      ),
      DataField.textField(
        'Desc',
        (item) => item.desc,
        (item, value) => item.copyWith(desc: value),
      ),      
    ];
  }
}
