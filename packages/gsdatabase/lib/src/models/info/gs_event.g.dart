// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_event.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsEvent extends GsModel<GsEvent> {
  @override
  final String id;
  final String name;
  final String type;
  final String image;
  final String version;
  final DateTime dateStart;
  final DateTime dateEnd;

  /// Creates a new [GsEvent] instance.
  GsEvent({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.version,
    required this.dateStart,
    required this.dateEnd,
  });

  /// Creates a new [GsEvent] instance from the given map.
  GsEvent.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        type = m['type'] as String? ?? '',
        image = m['image'] as String? ?? '',
        version = m['version'] as String? ?? '',
        dateStart =
            DateTime.tryParse(m['date_start'].toString()) ?? DateTime(0),
        dateEnd = DateTime.tryParse(m['date_end'].toString()) ?? DateTime(0);

  /// Copies this model with the given parameters.
  @override
  GsEvent copyWith({
    String? id,
    String? name,
    String? type,
    String? image,
    String? version,
    DateTime? dateStart,
    DateTime? dateEnd,
  }) {
    return GsEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      image: image ?? this.image,
      version: version ?? this.version,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'version': version,
      'date_start': dateStart.toString(),
      'date_end': dateEnd.toString(),
    };
  }
}
