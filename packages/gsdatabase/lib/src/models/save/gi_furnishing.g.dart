// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_furnishing.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiFurnishing extends _GiFurnishing {
  @override
  final String id;
  @override
  final int amount;

  /// Creates a new [GiFurnishing] instance.
  GiFurnishing({
    required this.id,
    required this.amount,
  });

  /// Creates a new [GiFurnishing] instance from the given map.
  GiFurnishing.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        amount = m['amount'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GiFurnishing copyWith({
    String? id,
    int? amount,
  }) {
    return GiFurnishing(
      id: id ?? this.id,
      amount: amount ?? this.amount,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'amount': amount,
    };
  }
}
