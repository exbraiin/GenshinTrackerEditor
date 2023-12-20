// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_serenitea_set.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsSereniteaSet extends GsModel<GsSereniteaSet> {
  @override
  final String id;
  final String name;
  final GeSereniteaSetType category;
  final String image;
  final int rarity;
  final int energy;
  final List<String> chars;
  final String version;

  /// Creates a new [GsSereniteaSet] instance.
  GsSereniteaSet({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.rarity,
    required this.energy,
    required this.chars,
    required this.version,
  });

  /// Creates a new [GsSereniteaSet] instance from the given map.
  GsSereniteaSet.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        category = GeSereniteaSetType.values.fromId(m['category']),
        image = m['image'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        energy = m['energy'] as int? ?? 0,
        chars = (m['chars'] as List? ?? const []).cast<String>(),
        version = m['version'] as String? ?? '';

  /// Copies this model with the given parameters.
  @override
  GsSereniteaSet copyWith({
    String? id,
    String? name,
    GeSereniteaSetType? category,
    String? image,
    int? rarity,
    int? energy,
    List<String>? chars,
    String? version,
  }) {
    return GsSereniteaSet(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      energy: energy ?? this.energy,
      chars: chars ?? this.chars,
      version: version ?? this.version,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'category': category.id,
      'image': image,
      'rarity': rarity,
      'energy': energy,
      'chars': chars,
      'version': version,
    };
  }
}
