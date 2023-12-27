// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_viewpoint.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsViewpoint extends _GsViewpoint {
  @override
  final String id;
  @override
  final String name;
  @override
  final String desc;
  @override
  final String image;
  @override
  final GeRegionType region;
  @override
  final String version;

  /// Creates a new [GsViewpoint] instance.
  GsViewpoint({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.region,
    required this.version,
  });

  /// Creates a new [GsViewpoint] instance from the given map.
  GsViewpoint.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        desc = m['desc'] as String? ?? '',
        image = m['image'] as String? ?? '',
        region = GeRegionType.values.fromId(m['region']),
        version = m['version'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsViewpoint copyWith({
    String? id,
    String? name,
    String? desc,
    String? image,
    GeRegionType? region,
    String? version,
  }) {
    return GsViewpoint(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      image: image ?? this.image,
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
      'desc': desc,
      'image': image,
      'region': region.id,
      'version': version,
    };
  }
}
