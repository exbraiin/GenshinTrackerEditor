import 'package:gsdatabase/src/models/gs_model.dart';

part 'gi_player_info.g.dart';

@BuilderGenerator()
abstract class IGiPlayerInfo extends GsModel<IGiPlayerInfo> {
  @BuilderWire('uid')
  String get uid;
  @BuilderWire('avatar_id')
  String get avatarId;
  @BuilderWire('nickname')
  String get nickname;
  @BuilderWire('signature')
  String get signature;
  @BuilderWire('level')
  int get level;
  @BuilderWire('world_level')
  int get worldLevel;
  @BuilderWire('namecard')
  int get namecardId;
  @BuilderWire('achievements')
  int get achievements;
  @BuilderWire('tower_floor')
  int get towerFloor;
  @BuilderWire('tower_chamber')
  int get towerChamber;
  @BuilderWire('avatars')
  Map<String, int> get avatars;
}
