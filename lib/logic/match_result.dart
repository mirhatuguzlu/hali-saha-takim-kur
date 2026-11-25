import '../models/player.dart';

/// Takım A/B oyuncularına skora göre galibiyet, beraberlik veya mağlubiyet ekler.
List<Player> applyResult(
  List<Player> all,
  List<Player> a,
  List<Player> b,
  int goalsA,
  int goalsB,
) {
  final aIds = a.map((p) => p.id).toSet();
  final bIds = b.map((p) => p.id).toSet();
  return [
    for (final p in all)
      if (!aIds.contains(p.id) && !bIds.contains(p.id))
        p
      else
        _withResult(p, (goalsA - goalsB) * (aIds.contains(p.id) ? 1 : -1)),
  ];
}

Player _withResult(Player p, int diff) => p.copyWith(
  wins: p.wins + (diff > 0 ? 1 : 0),
  draws: p.draws + (diff == 0 ? 1 : 0),
  losses: p.losses + (diff < 0 ? 1 : 0),
);
