import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/db_ext/src/abstract/gs_model_ext.dart';
import 'package:gsdatabase/gsdatabase.dart';

class GsArtifactExt extends GsModelExt<GsArtifact> {
  const GsArtifactExt();

  @override
  List<DataField<GsArtifact>> getFields(String? editId) {
    final ids = Database.i.of<GsArtifact>().ids;
    final regions = GsItemFilter.regions().ids;
    final versions = GsItemFilter.versions().ids;

    return [
      DataField.textField(
        'ID',
        (item) => item.id,
        (item, value) => item.copyWith(id: value),
        validator: (item) => vdId(item, editId, ids),
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
      DataField.singleSelect(
        'Version',
        (item) => item.version,
        (item) => GsItemFilter.versions().filters,
        (item, value) => item.copyWith(version: value),
        validator: (item) => vdContains(item.version, versions),
      ),
      DataField.selectRarity(
        'Rarity',
        (item) => item.rarity,
        (item, value) => item.copyWith(rarity: value),
        validator: (item) => vdRarity(item.rarity),
      ),
      DataField.singleEnum(
        'Region',
        GeRegionType.values.toChips(),
        (item) => item.region,
        (item, value) => item.copyWith(region: value),
        validator: (item) => vdContains(item.region.id, regions),
      ),
      DataField.textField(
        'Piece 1',
        (item) => item.pc1,
        (item, value) => item.copyWith(pc1: value),
        validator: (item) => vdText(item.pc1),
      ),
      DataField.textField(
        'Piece 2',
        (item) => item.pc2,
        (item, value) => item.copyWith(pc2: value),
        validator: (item) => vdText(item.pc2),
      ),
      DataField.textField(
        'Piece 4',
        (item) => item.pc4,
        (item, value) => item.copyWith(pc4: value),
        validator: (item) => vdText(item.pc4),
      ),
      DataField.textField(
        'Domain',
        (item) => item.domain,
        (item, value) => item.copyWith(domain: value),
        validator: (item) => vdText(item.domain),
      ),
      DataField.build<GsArtifact, GsArtifactPiece>(
        'Pieces',
        (item) => item.pieces,
        (item) => GsItemFilter.artifactPieces().filters,
        (item, child) => DataField.list(
          child.id,
          (item) => [
            DataField.textField(
              'Name',
              (item) => item.name,
              (item, value) => item.copyWith(name: value),
              validator: (item) => vdText(item.name),
            ),
            DataField.textImage(
              'Icon',
              (item) => item.icon,
              (item, value) => item.copyWith(icon: value),
              validator: (item) => vdImage(item.icon),
            ),
            DataField.textField(
              'Desc',
              (item) => item.desc,
              (item, value) => item.copyWith(desc: value),
              validator: (item) => vdText(item.desc),
            ),
          ],
        ),
        (item, value) {
          final order = GsItemFilter.artifactPieces().ids.toList();
          final list = value.map((id) {
            final old = item.pieces.firstOrNullWhere((i) => i.id == id);
            return old ?? GsArtifactPiece.fromJson({'id': id});
          }).sortedBy((element) => order.indexOf(element.id));
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
