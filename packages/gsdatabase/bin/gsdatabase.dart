import 'package:gsdatabase/gsdatabase.dart';

void main(List<String> arguments) async {
  final db = GsDatabase.info(
    loadJson: 'data.json',
  );
  await db.load();

  final char = db.of<GsCharacterInfo>().items.firstOrNull;
  if (char != null) {
    print(char.talents.map((e) => '${e.id} - ${e.type}'));
    print(char.constellations.map((e) => '${e.id} - ${e.type}'));
  }

  final version = db.of<GsVersion>().items.firstOrNull;
  if (version != null) {
    print(version.releaseDate);
    print(version.toMap()['release_date']);
  }
}
