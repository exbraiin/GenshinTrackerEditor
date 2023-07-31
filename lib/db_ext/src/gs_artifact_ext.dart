import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/db_ext/datafields_util.dart';

List<DataField<GsArtifact>> getArtifactDfs(GsArtifact? model) {
  final validator = DataValidator.i.getValidator<GsArtifact>();
  final pieces = DataValidator.i.getValidator<GsArtifactPiece>();
  return [
    DataField.textField(
      'ID',
      (item) => item.id,
      (item, value) => item.copyWith(id: value),
      validate: (item) => validator.validateEntry('id', item, model),
      refresh: (item) => item.copyWith(id: generateId(item)),
    ),
    DataField.textField(
      'Name',
      (item) => item.name,
      (item, value) => item.copyWith(name: value),
      validate: (item) => validator.validateEntry('name', item, model),
    ),
    DataField.singleSelect(
      'Version',
      (item) => item.version,
      (item) => GsItemFilter.versions().filters,
      (item, value) => item.copyWith(version: value),
      validate: (item) => validator.validateEntry('version', item, model),
    ),
    DataField.selectRarity(
      'Rarity',
      (item) => item.rarity,
      (item, value) => item.copyWith(rarity: value),
      validate: (item) => validator.validateEntry('rarity', item, model),
    ),
    DataField.singleSelect(
      'Region',
      (item) => item.region,
      (item) => GsItemFilter.regions().filters,
      (item, value) => item.copyWith(region: value),
      validate: (item) => validator.validateEntry('region', item, model),
    ),
    DataField.textField(
      'Piece 1',
      (item) => item.pc1,
      (item, value) => item.copyWith(pc1: value),
      validate: (item) => validator.validateEntry('1pc', item, model),
    ),
    DataField.textField(
      'Piece 2',
      (item) => item.pc2,
      (item, value) => item.copyWith(pc2: value),
      validate: (item) => validator.validateEntry('2pc', item, model),
    ),
    DataField.textField(
      'Piece 4',
      (item) => item.pc4,
      (item, value) => item.copyWith(pc4: value),
      validate: (item) => validator.validateEntry('4pc', item, model),
    ),
    DataField.textField(
      'Domain',
      (item) => item.domain,
      (item, value) => item.copyWith(domain: value),
      validate: (item) => validator.validateEntry('domain', item, model),
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
            validate: (item) => pieces.validateEntry('name', item, null),
          ),
          DataField.textImage(
            'Icon',
            (item) => item.icon,
            (item, value) => item.copyWith(icon: value),
            validate: (item) => pieces.validateEntry('icon', item, null),
          ),
          DataField.textField(
            'Desc',
            (item) => item.desc,
            (item, value) => item.copyWith(desc: value),
            validate: (item) => pieces.validateEntry('desc', item, null),
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
