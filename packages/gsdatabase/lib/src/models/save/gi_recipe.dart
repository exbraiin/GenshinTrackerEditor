import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_recipe.g.dart';

@BuilderGenerator()
abstract mixin class _GiRecipe implements GsModel<GiRecipe> {
  @BuilderWire('proficiency')
  int get proficiency;
}
