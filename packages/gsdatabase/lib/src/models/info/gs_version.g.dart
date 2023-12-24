// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_version.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsVersion extends GsModel<GsVersion> with _GsVersion {
  @override
  final String id;
  @override
  final String name;
  @override
  final String image;
  @override
  final DateTime releaseDate;

  /// Creates a new [GsVersion] instance.
  GsVersion({
    required this.id,
    required this.name,
    required this.image,
    required this.releaseDate,
  });

  /// Creates a new [GsVersion] instance from the given map.
  GsVersion.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        image = m['image'] as String? ?? '',
        releaseDate =
            DateTime.tryParse(m['release_date'].toString()) ?? DateTime(0);

  /// Copies this model with the given parameters.
  @override
  GsVersion copyWith({
    String? id,
    String? name,
    String? image,
    DateTime? releaseDate,
  }) {
    return GsVersion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'release_date': releaseDate.toString(),
    };
  }
}
