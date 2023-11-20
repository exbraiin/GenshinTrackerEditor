import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

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
  final GeEnemyFamily family;
  final List<String> drops;

  GsEnemy({
    this.id = '',
    this.name = '',
    this.title = '',
    this.image = '',
    this.fullImage = '',
    this.splashImage = '',
    this.version = '',
    this.order = 0,
    this.drops = const [],
    this.type = GeEnemyType.none,
    this.family = GeEnemyFamily.none,
  });

  GsEnemy.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        title = m.getString('title'),
        image = m.getString('image'),
        fullImage = m.getString('full_image'),
        splashImage = m.getString('splash_image'),
        version = m.getString('version'),
        order = m.getInt('order'),
        drops = m.getStringList('drops'),
        type = GeEnemyType.values.fromId(m.getString('type')),
        family = GeEnemyFamily.values.fromId(m.getString('family'));

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
    List<String>? drops,
    GeEnemyType? type,
    GeEnemyFamily? family,
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
      drops: drops ?? this.drops,
      family: family ?? this.family,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'id': id,
        'name': name,
        'title': title,
        'image': image,
        'full_image': fullImage,
        'splash_image': splashImage,
        'version': version,
        'order': order,
        'drops': drops,
        'type': type.id,
        'family': family.id,
      };
}
