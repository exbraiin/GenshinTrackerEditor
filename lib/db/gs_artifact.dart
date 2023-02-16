import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsArtifact extends GsModel<GsArtifact> {
  @override
  final String id;
  final String name;
  final String version;
  final int rarity;
  final String pc1;
  final String pc2;
  final String pc4;
  final String domain;
  final List<GsArtifactPiece> pieces;

  GsArtifact._({
    this.id = '',
    this.name = '',
    this.version = '',
    this.rarity = 1,
    this.pc1 = '',
    this.pc2 = '',
    this.pc4 = '',
    this.domain = '',
    this.pieces = const [],
  });

  GsArtifact.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        version = m.getString('version'),
        rarity = m.getInt('rarity', 1),
        pc1 = m.getString('1pc'),
        pc2 = m.getString('2pc'),
        pc4 = m.getString('4pc'),
        domain = m.getString('domain'),
        pieces = m.getMapToList('pieces', GsArtifactPiece.fromMap);

  @override
  GsArtifact copyWith({
    String? id,
    String? name,
    String? version,
    int? rarity,
    String? pc1,
    String? pc2,
    String? pc4,
    String? domain,
    List<GsArtifactPiece>? pieces,
  }) {
    return GsArtifact._(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      rarity: rarity ?? this.rarity,
      pc1: pc1 ?? this.pc1,
      pc2: pc2 ?? this.pc2,
      pc4: pc4 ?? this.pc4,
      domain: domain ?? this.domain,
      pieces: pieces ?? this.pieces,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'version': version,
        'rarity': rarity,
        'domain': domain,
        if (pc1.isNotEmpty) '1pc': pc1,
        if (pc2.isNotEmpty) '2pc': pc2,
        if (pc4.isNotEmpty) '4pc': pc4,
        'pieces': pieces.map((e) => MapEntry(e.id, e.toJsonMap())).toMap(),
      };
}

class GsArtifactPiece extends GsModel<GsArtifactPiece> {
  @override
  final String id;
  final String name;
  final String icon;
  final String desc;

  GsArtifactPiece({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.desc = '',
  });

  GsArtifactPiece.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        icon = m.getString('icon'),
        desc = m.getString('desc');

  @override
  GsArtifactPiece copyWith({
    String? name,
    String? icon,
    String? desc,
  }) {
    return GsArtifactPiece(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'icon': icon,
        'desc': desc,
      };
}
