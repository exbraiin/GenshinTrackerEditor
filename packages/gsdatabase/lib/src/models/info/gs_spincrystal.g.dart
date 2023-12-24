// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_spincrystal.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsSpincrystal extends GsModel<GsSpincrystal> with _GsSpincrystal {
  @override
  final String id;
  @override
  final String name;
  @override
  final int number;
  @override
  final String source;
  @override
  final GeRegionType region;
  @override
  final String version;

  /// Creates a new [GsSpincrystal] instance.
  GsSpincrystal({
    required this.id,
    required this.name,
    required this.number,
    required this.source,
    required this.region,
    required this.version,
  });

  /// Creates a new [GsSpincrystal] instance from the given map.
  GsSpincrystal.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        number = m['number'] as int? ?? 0,
        source = m['source'] as String? ?? '',
        region = GeRegionType.values.fromId(m['region']),
        version = m['version'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsSpincrystal copyWith({
    String? id,
    String? name,
    int? number,
    String? source,
    GeRegionType? region,
    String? version,
  }) {
    return GsSpincrystal(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      source: source ?? this.source,
      region: region ?? this.region,
      version: version ?? this.version,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'source': source,
      'region': region.id,
      'version': version,
    };
  }
}
