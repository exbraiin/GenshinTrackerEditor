// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gi_serenitea_set.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GiSereniteaSet extends _GiSereniteaSet {
  @override
  final String id;
  @override
  final List<String> chars;

  /// Creates a new [GiSereniteaSet] instance.
  GiSereniteaSet({
    required this.id,
    required this.chars,
  });

  /// Creates a new [GiSereniteaSet] instance from the given map.
  GiSereniteaSet.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        chars = (m['chars'] as List? ?? const []).cast<String>();

  /// Copies this model with the given parameters.
  @override
  GiSereniteaSet copyWith({
    String? id,
    List<String>? chars,
  }) {
    return GiSereniteaSet(
      id: id ?? this.id,
      chars: chars ?? this.chars,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'chars': chars,
    };
  }
}
