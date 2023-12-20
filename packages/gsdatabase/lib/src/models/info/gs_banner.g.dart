// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_banner.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsBanner extends GsModel<GsBanner> {
  @override
  final String id;
  final String name;
  final String image;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String version;
  final GeBannerType type;
  final List<String> feature4;
  final List<String> feature5;

  /// Creates a new [GsBanner] instance.
  GsBanner({
    required this.id,
    required this.name,
    required this.image,
    required this.dateStart,
    required this.dateEnd,
    required this.version,
    required this.type,
    required this.feature4,
    required this.feature5,
  });

  /// Creates a new [GsBanner] instance from the given map.
  GsBanner.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        image = m['image'] as String? ?? '',
        dateStart =
            DateTime.tryParse(m['date_start'].toString()) ?? DateTime(0),
        dateEnd = DateTime.tryParse(m['date_end'].toString()) ?? DateTime(0),
        version = m['version'] as String? ?? '',
        type = GeBannerType.values.fromId(m['type']),
        feature4 = (m['feature_4'] as List? ?? const []).cast<String>(),
        feature5 = (m['feature_5'] as List? ?? const []).cast<String>();

  /// Copies this model with the given parameters.
  @override
  GsBanner copyWith({
    String? id,
    String? name,
    String? image,
    DateTime? dateStart,
    DateTime? dateEnd,
    String? version,
    GeBannerType? type,
    List<String>? feature4,
    List<String>? feature5,
  }) {
    return GsBanner(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      version: version ?? this.version,
      type: type ?? this.type,
      feature4: feature4 ?? this.feature4,
      feature5: feature5 ?? this.feature5,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'date_start':
          '${dateStart.year.toString().padLeft(4, '0')}-${dateStart.month.toString().padLeft(2, '0')}-${dateStart.day.toString().padLeft(2, '0')}',
      'date_end':
          '${dateEnd.year.toString().padLeft(4, '0')}-${dateEnd.month.toString().padLeft(2, '0')}-${dateEnd.day.toString().padLeft(2, '0')}',
      'version': version,
      'type': type.id,
      'feature_4': feature4,
      'feature_5': feature5,
    };
  }
}
