// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_spincrystal.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiSpincrystal extends GsModel<GiSpincrystal> with _GiSpincrystal {
  @override
  final String id;
  @override
  final bool obtained;

  /// Creates a new [GiSpincrystal] instance.
  GiSpincrystal({
    required this.id,
    required this.obtained,
  });

  /// Creates a new [GiSpincrystal] instance from the given map.
  GiSpincrystal.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        obtained = m['obtained'] as bool? ?? false;

  /// Copies this model with the given parameters.
  @override
  GiSpincrystal copyWith({
    String? id,
    bool? obtained,
  }) {
    return GiSpincrystal(
      id: id ?? this.id,
      obtained: obtained ?? this.obtained,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'obtained': obtained,
    };
  }
}
