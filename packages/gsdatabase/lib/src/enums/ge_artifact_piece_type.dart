import 'package:gsdatabase/src/enums/ge_enum.dart';

enum GeArtifactPieceType implements GeEnum {
  flowerOfLife('flower_of_life'),
  plumeOfDeath('plume_of_death'),
  sandsOfEon('sands_of_eon'),
  gobletOfEonothem('goblet_of_eonothem'),
  circletOfLogos('circlet_of_logos');

  @override
  final String id;
  const GeArtifactPieceType(this.id);
}
