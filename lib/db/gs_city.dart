import 'package:data_editor/db/database.dart';
import 'package:data_editor/db/ge_enums.dart';

class GsCity extends GsModel<GsCity> {
  @override
  final String id;
  final String name;
  final String image;
  final GeElements element;
  final List<int> reputation;

  GsCity({
    this.id = '',
    this.name = '',
    this.image = '',
    this.element = GeElements.anemo,
    this.reputation = const [],
  });

  GsCity.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        image = m.getString('image'),
        element = GeElements.fromId(m.getString('element')),
        reputation = m.getIntList('reputation');

  @override
  GsCity copyWith({
    String? id,
    String? name,
    String? image,
    GeElements? element,
    List<int>? reputation,
  }) {
    return GsCity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      element: element ?? this.element,
      reputation: reputation ?? this.reputation,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'image': image,
        'element': element.id,
        'reputation': reputation,
      };
}
