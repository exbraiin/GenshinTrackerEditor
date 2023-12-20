// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_wish.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiWish extends GsModel<GiWish> {
  @override
  final String id;
  final int number;
  final String itemId;
  final String bannerId;
  final DateTime date;

  /// Creates a new [GiWish] instance.
  GiWish({
    required this.id,
    required this.number,
    required this.itemId,
    required this.bannerId,
    required this.date,
  });

  /// Creates a new [GiWish] instance from the given map.
  GiWish.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        number = m['number'] as int? ?? 0,
        itemId = m['item'] as String? ?? '',
        bannerId = m['banner'] as String? ?? '',
        date = DateTime.tryParse(m['date'].toString()) ?? DateTime(0);

  /// Copies this model with the given parameters.
  @override
  GiWish copyWith({
    String? id,
    int? number,
    String? itemId,
    String? bannerId,
    DateTime? date,
  }) {
    return GiWish(
      id: id ?? this.id,
      number: number ?? this.number,
      itemId: itemId ?? this.itemId,
      bannerId: bannerId ?? this.bannerId,
      date: date ?? this.date,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'number': number,
      'item': itemId,
      'banner': bannerId,
      'date':
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    };
  }
}
