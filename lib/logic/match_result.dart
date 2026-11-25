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
  winStreak: diff > 0 ? p.winStreak + 1 : 0,
);

/// Üst üste 3 galibiyet alan ve puanı 5'in altında olan oyuncuya artış önerilir.
bool suggestsRaise(Player p) => p.winStreak >= 3 && p.rating < 5;

/// Puanı 1 artırır (en fazla 5) ve seriyi sıfırlar ki öneri hemen tekrar çıkmasın.
Player raiseRating(Player p) =>
    p.copyWith(rating: p.rating < 5 ? p.rating + 1 : 5, winStreak: 0);
