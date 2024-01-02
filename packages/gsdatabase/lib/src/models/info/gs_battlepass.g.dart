// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_battlepass.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsBattlepass extends _GsBattlepass {
  @override
  final String id;
  @override
  final String name;
  @override
  final String image;
  @override
  final String namecardId;
  @override
  final DateTime dateStart;
  @override
  final DateTime dateEnd;

  /// Creates a new [GsBattlepass] instance.
  GsBattlepass({
    required this.id,
    required this.name,
    required this.image,
    required this.namecardId,
    required this.dateStart,
    required this.dateEnd,
  });

  /// Creates a new [GsBattlepass] instance from the given map.
  GsBattlepass.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        image = m['image'] as String? ?? '',
        namecardId = m['namecard_id'] as String? ?? '',
        dateStart =
            DateTime.tryParse(m['date_start'].toString()) ?? DateTime(0),
        dateEnd = DateTime.tryParse(m['date_end'].toString()) ?? DateTime(0);

  /// Copies this model with the given parameters.
  @override
  GsBattlepass copyWith({
    String? id,
    String? name,
    String? image,
    String? namecardId,
    DateTime? dateStart,
    DateTime? dateEnd,
  }) {
    return GsBattlepass(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      namecardId: namecardId ?? this.namecardId,
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
      'image': image,
      'namecard_id': namecardId,
      'date_start': dateStart.toString(),
      'date_end': dateEnd.toString(),
    };
  }
}
