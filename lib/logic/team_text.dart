import '../models/player.dart';

String teamsToText(List<Player> a, List<Player> b) {
  String line(String title, List<Player> team) =>
      '$title (güç ${team.fold(0, (s, p) => s + p.rating)}): '
      '${team.map((p) => p.name).join(', ')}';
  return '${line('Takım A', a)}\n${line('Takım B', b)}';
}
