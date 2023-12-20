abstract class GeEnum {
  String get id;
}

extension ListGsEnumExt<T extends GeEnum> on List<T> {
  T fromId(String? id) => firstWhere((e) => e.id == id, orElse: () => first);
  List<T> fromIds(Iterable<String> ids) => ids.map((e) => fromId(e)).toList();
}
