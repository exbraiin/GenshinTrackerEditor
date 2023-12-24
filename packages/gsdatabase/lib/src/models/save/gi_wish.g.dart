// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_wish.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiWish extends GsModel<GiWish> with _GiWish {
  @override
  final String id;
  @override
  final int number;
  @override
  final String itemId;
  @override
  final String bannerId;
  @override
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
      'date': date.toString(),
    };
  }
}
