import 'package:dartx/dartx.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/style/utils.dart';

class GsRecipe extends GsModel<GsRecipe> {
  @override
  final String id;
  final String name;
  final String type;
  final int rarity;
  final String version;
  final String image;
  final String effect;
  final String desc;
  final String effectDesc;
  final String baseRecipe;
  final List<GsAmount> ingredients;

  GsRecipe({
    this.id = '',
    this.name = '',
    this.type = '',
    this.rarity = 1,
    this.version = '',
    this.image = '',
    this.effect = '',
    this.desc = '',
    this.effectDesc = '',
    this.baseRecipe = '',
    this.ingredients = const [],
  });

  GsRecipe.fromMap(JsonMap m)
      : id = m.getString('id'),
        name = m.getString('name'),
        type = m.getString('type'),
        rarity = m.getInt('rarity', 1),
        version = m.getString('version'),
        image = m.getString('image'),
        effect = m.getString('effect'),
        desc = m.getString('desc'),
        effectDesc = m.getString('effect_desc'),
        ingredients = (m['ingredients'] as Map? ?? {})
            .cast<String, int>()
            .mapEntries(GsAmount.fromMapEntry)
            .toList(),
        baseRecipe = m.getString('base_recipe');

  @override
  GsRecipe copyWith({
    String? id,
    String? name,
    String? type,
    int? rarity,
    String? version,
    String? image,
    String? effect,
    String? desc,
    String? effectDesc,
    String? baseRecipe,
    List<GsAmount>? ingredients,
  }) {
    return GsRecipe(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      version: version ?? this.version,
      image: image ?? this.image,
      effect: effect ?? this.effect,
      desc: desc ?? this.desc,
      effectDesc: effectDesc ?? this.effectDesc,
      baseRecipe: baseRecipe ?? this.baseRecipe,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  JsonMap toJsonMap() => {
        'name': name,
        'type': type,
        'version': version,
        'image': image,
        'effect': effect,
        'rarity': rarity,
        'desc': desc,
        'effect_desc': effectDesc,
        'ingredients': ingredients
            .map((entry) => MapEntry(entry.id, entry.amount))
            .toMap(),
        'base_recipe': baseRecipe,
      };
}

class GsAmount extends GsModel<GsAmount> {
  @override
  final String id;
  final int amount;

  GsAmount({
    this.id = '',
    this.amount = 0,
  });

  GsAmount.fromMapEntry(MapEntry<String, int> m)
      : id = m.key,
        amount = m.value;

  @override
  GsAmount copyWith({int? amount}) {
    return GsAmount(
      id: id,
      amount: amount ?? this.amount,
    );
  }

  @override
  JsonMap toJsonMap() => {id: amount};
}

class GsValue extends GsModel<GsValue> {
  @override
  final String id;
  final double value;

  GsValue({
    required this.id,
    required this.value,
  });

  GsValue.fromMapEntry(MapEntry<String, dynamic> m)
      : id = m.key,
        value = (m.value as num? ?? 0).toDouble();

  @override
  GsValue copyWith({double? value}) {
    return GsValue(
      id: id,
      value: value ?? this.value,
    );
  }

  @override
  JsonMap toJsonMap() => {id: value};
}
