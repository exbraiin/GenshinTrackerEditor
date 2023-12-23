import 'package:gsdatabase/gsdatabase.dart';

void main(List<String> arguments) async {
  final db = GsDatabase.info(
    loadJson: 'data.json',
  );
  await db.load();

  final char = db.of<GsCharacter>().items.firstOrNull;
  if (char != null) {
    print(char.id);
    print(char.name);
    print(char.constellations.length);
  }

  final weap = db.of<GsWeapon>().items.lastOrNull;
  if(weap != null){
    print(weap.id);
    print(weap.name);
    print(weap.ascAtkValues);
  }

  /*
  final version = db.of<GsVersion>().items.firstOrNull;
  if (version != null) {
    print(version.releaseDate);
    print(version.toMap()['release_date']);
  }
  */
}
