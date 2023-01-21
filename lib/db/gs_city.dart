import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsCity extends GsModel {
  @override
  final String id;
  final String name;
  final String image;
  final String element;
  final List<int> reputation;

  GsCity({
    this.id = '',
    this.name = '',
    this.image = '',
    this.element = '',
    this.reputation = const [],
  });

  GsCity.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        image = m.getString('image'),
        element = m.getString('element'),
        reputation = m.getIntList('reputation');

  GsCity copyWith({
    String? id,
    String? name,
    String? image,
    String? element,
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
        'element': element,
        'reputation': reputation,
      };
}
