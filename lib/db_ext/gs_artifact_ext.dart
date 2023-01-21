import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';

List<DataField<GsArtifact>> getArtifactDfs(GsArtifact? model) {
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      isValid: (item) => validateId(item, model, Database.i.artifacts),
      refresh: (item) => item.copyWith(id: item.name.toDbId()),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      isValid: (item) => validateText(item.name),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsSelectItems.versions,
      (item, value) => item.copyWith(version: value),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
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
      (item) => GsSelectItems.getFromList(GsConfigurations.artifactPieces),
      (item, child) => DataField.list(
        child.id,
        (item) => [
          DataField.textField(
            'Name',
            (item) => item.name,
            (item, value) => item.copyWith(name: value),
          ),
          DataField.textField(
            'Icon',
            (item) => item.icon,
            (item, value) => item.copyWith(icon: value),
            process: processImage,
          ),
          DataField.textField(
            'Desc',
            (item) => item.desc,
            (item, value) => item.copyWith(desc: value),
          ),
        ],
      ),
      (item, value) {
        final list = value.map((id) {
          final old = item.pieces.firstOrNullWhere((i) => i.id == id);
          return old ?? GsArtifactPiece(id: id);
        }).sortedBy((element) => element.id);
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
