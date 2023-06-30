import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsAchievementGroup extends GsModel<GsAchievementGroup> {
  @override
  final String id;
  final String name;
  final String icon;
  final String version;
  final String namecard;

  GsAchievementGroup._({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.version = '',
    this.namecard = '',
  });

  GsAchievementGroup.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        icon = m.getString('icon'),
        version = m.getString('version'),
        namecard = m.getString('namecard');

  @override
  GsAchievementGroup copyWith({
    String? id,
    String? name,
    String? icon,
    String? version,
    String? namecard,
  }) {
    return GsAchievementGroup._(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      version: version ?? this.version,
      namecard: namecard ?? this.namecard,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'icon': icon,
        'version': version,
        'namecard': namecard,
      };
}
