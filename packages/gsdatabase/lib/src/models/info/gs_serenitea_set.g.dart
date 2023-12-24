// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_serenitea_set.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsSereniteaSet extends GsModel<GsSereniteaSet> with _GsSereniteaSet {
  @override
  final String id;
  @override
  final String name;
  @override
  final String version;
  @override
  final GeSereniteaSetType category;
  @override
  final String image;
  @override
  final int rarity;
  @override
  final int energy;
  @override
  final List<String> chars;
  @override
  final List<GsFurnishingAmount> furnishing;

  /// Creates a new [GsSereniteaSet] instance.
  GsSereniteaSet({
    required this.id,
    required this.name,
    required this.version,
    required this.category,
    required this.image,
    required this.rarity,
    required this.energy,
    required this.chars,
    required this.furnishing,
  });

  /// Creates a new [GsSereniteaSet] instance from the given map.
  GsSereniteaSet.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        version = m['version'] as String? ?? '',
        category = GeSereniteaSetType.values.fromId(m['category']),
        image = m['image'] as String? ?? '',
        rarity = m['rarity'] as int? ?? 0,
        energy = m['energy'] as int? ?? 0,
        chars = (m['chars'] as List? ?? const []).cast<String>(),
        furnishing = (m['furnishing'] as List? ?? const [])
            .map((e) => GsFurnishingAmount.fromJson(e))
            .toList();

  /// Copies this model with the given parameters.
  @override
  GsSereniteaSet copyWith({
    String? id,
    String? name,
    String? version,
    GeSereniteaSetType? category,
    String? image,
    int? rarity,
    int? energy,
    List<String>? chars,
    List<GsFurnishingAmount>? furnishing,
  }) {
    return GsSereniteaSet(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      category: category ?? this.category,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      energy: energy ?? this.energy,
      chars: chars ?? this.chars,
      furnishing: furnishing ?? this.furnishing,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'category': category.id,
      'image': image,
      'rarity': rarity,
      'energy': energy,
      'chars': chars,
      'furnishing': furnishing.map((e) => e.toMap()).toList(),
    };
  }
}

class GsFurnishingAmount extends GsModel<GsFurnishingAmount>
    with _GsFurnishingAmount {
  @override
  final String id;
  @override
  final int amount;

  /// Creates a new [GsFurnishingAmount] instance.
  GsFurnishingAmount({
    required this.id,
    required this.amount,
  });

  /// Creates a new [GsFurnishingAmount] instance from the given map.
  GsFurnishingAmount.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        amount = m['amount'] as int? ?? 0;

  /// Copies this model with the given parameters.
  @override
  GsFurnishingAmount copyWith({
    String? id,
    int? amount,
  }) {
    return GsFurnishingAmount(
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
