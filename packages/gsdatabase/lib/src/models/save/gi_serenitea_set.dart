import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_serenitea_set.g.dart';

@BuilderGenerator()
abstract class IGiSereniteaSet extends GsModel<IGiSereniteaSet> {
  @BuilderWire('chars')
  List<String> get chars;
}
