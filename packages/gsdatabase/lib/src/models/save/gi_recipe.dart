import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_recipe.g.dart';

@BuilderGenerator()
abstract class _GiRecipe extends GsModel<GiRecipe> {
  @BuilderWire('proficiency')
  int get proficiency;
}
