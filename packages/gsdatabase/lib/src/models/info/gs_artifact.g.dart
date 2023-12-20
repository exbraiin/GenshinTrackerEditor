// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_artifact.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsArtifact extends GsModel<GsArtifact> {
  @override
  final String id;
  final String name;
  final GeRegionType region;
  final String version;
  final int rarity;
  final String pc1;
  final String pc2;
  final String pc4;
  final String domain;
  final List<GsArtifactPiece> pieces;

  /// Creates a new [GsArtifact] instance.
  GsArtifact({
    required this.id,
    required this.name,
    required this.region,
    required this.version,
    required this.rarity,
    required this.pc1,
    required this.pc2,
    required this.pc4,
    required this.domain,
    required this.pieces,
  });

  /// Creates a new [GsArtifact] instance from the given map.
  GsArtifact.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        region = GeRegionType.values.fromId(m['region']),
        version = m['version'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        pc1 = m['1pc'] as String? ?? '',
        pc2 = m['2pc'] as String? ?? '',
        pc4 = m['4pc'] as String? ?? '',
        domain = m['domain'] as String? ?? '',
        pieces = (m['list_pieces'] as List? ?? const [])
            .map((e) => GsArtifactPiece.fromJson(e))
            .toList();

  /// Copies this model with the given parameters.
  @override
  GsArtifact copyWith({
    String? id,
    String? name,
    GeRegionType? region,
    String? version,
    int? rarity,
    String? pc1,
    String? pc2,
    String? pc4,
    String? domain,
    List<GsArtifactPiece>? pieces,
  }) {
    return GsArtifact(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      version: version ?? this.version,
      rarity: rarity ?? this.rarity,
      pc1: pc1 ?? this.pc1,
      pc2: pc2 ?? this.pc2,
      pc4: pc4 ?? this.pc4,
      domain: domain ?? this.domain,
      pieces: pieces ?? this.pieces,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'region': region.id,
      'version': version,
      'rarity': rarity,
      '1pc': pc1,
      '2pc': pc2,
      '4pc': pc4,
      'domain': domain,
      'list_pieces': pieces.map((e) => e.toMap()).toList(),
    };
  }
}

class GsArtifactPiece extends GsModel<GsArtifactPiece> {
  @override
  final String id;
  final String name;
  final String icon;
  final String desc;

  /// Creates a new [GsArtifactPiece] instance.
  GsArtifactPiece({
    required this.id,
    required this.name,
    required this.icon,
    required this.desc,
  });

  /// Creates a new [GsArtifactPiece] instance from the given map.
  GsArtifactPiece.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        icon = m['icon'] as String? ?? '',
        desc = m['desc'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsArtifactPiece copyWith({
    String? id,
    String? name,
    String? icon,
    String? desc,
  }) {
    return GsArtifactPiece(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      desc: desc ?? this.desc,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'desc': desc,
    };
  }
}
