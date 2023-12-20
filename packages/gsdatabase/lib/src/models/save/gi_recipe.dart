import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_recipe.g.dart';

@BuilderGenerator()
abstract class IGiRecipe extends GsModel<IGiRecipe> {
  @BuilderWire('proficiency')
  int get proficiency;
}
