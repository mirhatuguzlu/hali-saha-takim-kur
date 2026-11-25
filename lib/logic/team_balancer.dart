import 'dart:math';

import '../models/player.dart';

/// Shuffles, then greedily gives each player (goalkeepers first, then
/// strongest first) to the weaker team, capping team size at ceil(n/2).
/// Goalkeepers go first so two of them never end up on the same team.
/// Shuffle varies equal-rated players.
(List<Player>, List<Player>) balanceTeams(List<Player> players, {Random? rng}) {
  final sorted = [...players]..shuffle(rng);
  // List.sort is not stable; shuffle index breaks ties.
  final order = {for (var i = 0; i < sorted.length; i++) sorted[i]: i};
  sorted.sort((x, y) {
    if (x.isGoalkeeper != y.isGoalkeeper) return x.isGoalkeeper ? -1 : 1;
    final byRating = y.rating.compareTo(x.rating);
    return byRating != 0 ? byRating : order[x]!.compareTo(order[y]!);
  });

  final cap = (players.length + 1) ~/ 2;
  final a = <Player>[], b = <Player>[];
  var powerA = 0, powerB = 0;
  for (final p in sorted) {
    final toA = b.length >= cap || (a.length < cap && powerA <= powerB);
    if (toA) {
      a.add(p);
      powerA += p.rating;
    } else {
      b.add(p);
      powerB += p.rating;
    }
  }
  return (a, b);
}
