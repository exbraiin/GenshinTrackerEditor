import 'package:dartx/dartx.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsArtifactExt extends GsModelExt<GsArtifact> {
  const GsArtifactExt();

  @override
  List<DataField<GsArtifact>> getFields(String? editId) {
    final vd = ValidateModels<GsArtifact>();
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
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => vdVersion.filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdVersion.validate(item.version),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
      ),
      DataField.textField(
        'Piece 1',
        (item) => item.pc1,
        (item, value) => item.copyWith(pc1: value),
      ),
      DataField.textField(
        'Piece 2',
        (item) => item.pc2,
        (item, value) => item.copyWith(pc2: value),
      ),
      DataField.textField(
        'Piece 4',
        (item) => item.pc4,
        (item, value) => item.copyWith(pc4: value),
      ),
      DataField.textField(
        'Domain',
        (item) => item.domain,
        (item, value) => item.copyWith(domain: value),
      ),
      DataField.build<GsArtifact, GsArtifactPiece>(
        'Pieces',
        (item) => item.pieces,
        (item) => GeArtifactPieceType.values.toChipsId(),
        (item, child) => DataField.list(
          child.id,
          (item) => [
            DataField.textField(
              'Name',
              (item) => item.name,
              (item, value) => item.copyWith(name: value),
            ),
            DataField.textImage(
              'Icon',
              (item) => item.icon,
              (item, value) => item.copyWith(icon: value),
            ),
            DataField.textField(
              'Desc',
              (item) => item.desc,
              (item, value) => item.copyWith(desc: value),
            ),
          ],
        ),
        (item, value) {
          const pieces = GeArtifactPieceType.values;
          final list = value.map((id) {
            final old = item.pieces.firstOrNullWhere((i) => i.id == id);
            return old ?? GsArtifactPiece.fromJson({'id': id});
          }).sortedBy((e) => pieces.indexWhere((p) => e.id == p.id));
          return item.copyWith(pieces: list);
        },
        (item, field) {
          final list = item.pieces.toList();
          final idx = list.indexWhere((e) => e.id == field.id);
          if (idx != -1) list[idx] = field;
          return item.copyWith(pieces: list);
        },
      ),
    ];
  }
}
