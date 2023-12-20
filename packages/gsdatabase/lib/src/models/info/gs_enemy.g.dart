// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gs_enemy.dart';

// **************************************************************************
// Generator: BuilderGeneratorGen
// **************************************************************************

class GsEnemy extends GsModel<GsEnemy> {
  @override
  final String id;
  final String name;
  final String title;
  final String image;
  final String fullImage;
  final String splashImage;
  final String version;
  final int order;
  final GeEnemyType type;
  final GeEnemyFamilyType family;
  final List<String> drops;

  /// Creates a new [GsEnemy] instance.
  GsEnemy({
    required this.id,
    required this.name,
    required this.title,
    required this.image,
    required this.fullImage,
    required this.splashImage,
    required this.version,
    required this.order,
    required this.type,
    required this.family,
    required this.drops,
  });

  /// Creates a new [GsEnemy] instance from the given map.
  GsEnemy.fromJson(JsonMap m)
      : id = m['id'] as String? ?? '',
        name = m['name'] as String? ?? '',
        title = m['title'] as String? ?? '',
        image = m['image'] as String? ?? '',
        fullImage = m['full_image'] as String? ?? '',
        splashImage = m['splash_image'] as String? ?? '',
        version = m['version'] as String? ?? '',
        order = m['order'] as int? ?? 0,
        type = GeEnemyType.values.fromId(m['type']),
        family = GeEnemyFamilyType.values.fromId(m['family']),
        drops = (m['drops'] as List? ?? const []).cast<String>();

  /// Copies this model with the given parameters.
  @override
  GsEnemy copyWith({
    String? id,
    String? name,
    String? title,
    String? image,
    String? fullImage,
    String? splashImage,
    String? version,
    int? order,
    GeEnemyType? type,
    GeEnemyFamilyType? family,
    List<String>? drops,
  }) {
    return GsEnemy(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      image: image ?? this.image,
      fullImage: fullImage ?? this.fullImage,
      splashImage: splashImage ?? this.splashImage,
      version: version ?? this.version,
      order: order ?? this.order,
      type: type ?? this.type,
      family: family ?? this.family,
      drops: drops ?? this.drops,
    );
  }

  /// Creates a [JsonMap] from this model.
  @override
  JsonMap toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'image': image,
      'full_image': fullImage,
      'splash_image': splashImage,
      'version': version,
      'order': order,
      'type': type.id,
      'family': family.id,
      'drops': drops,
    };
  }
}
