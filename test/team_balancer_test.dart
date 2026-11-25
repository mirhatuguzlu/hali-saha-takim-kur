import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:halisaha_takim_kur/logic/team_balancer.dart';
import 'package:halisaha_takim_kur/models/player.dart';

List<Player> players(List<int> ratings) => [
  for (var i = 0; i < ratings.length; i++)
    Player(id: '$i', name: 'P$i', rating: ratings[i]),
];

List<Player> withKeepers(List<int> ratings, int keepers) => [
  for (var i = 0; i < ratings.length; i++)
    Player(
      id: '$i',
      name: 'P$i',
      rating: ratings[i],
      isGoalkeeper: i < keepers,
    ),
];

int keepers(List<Player> team) => team.where((p) => p.isGoalkeeper).length;

int power(List<Player> team) => team.fold(0, (s, p) => s + p.rating);

void main() {
  test('10 oyuncu 5-5 ayrılır, güç farkı en fazla 1', () {
    for (var seed = 0; seed < 20; seed++) {
      final (a, b) = balanceTeams(
        players([5, 5, 4, 4, 3, 3, 2, 2, 1, 1]),
        rng: Random(seed),
      );
      expect(a.length, 5);
      expect(b.length, 5);
      expect((power(a) - power(b)).abs(), lessThanOrEqualTo(1));
    }
  });

  test('7 oyuncu 4-3 ayrılır', () {
    final (a, b) = balanceTeams(players([5, 4, 3, 3, 2, 2, 1]));
    expect({a.length, b.length}, {4, 3});
  });

  test('herkes tam bir takımda, tekrar yok', () {
    final all = players([5, 4, 4, 3, 2, 1, 1, 3, 5]);
    final (a, b) = balanceTeams(all);
    final ids = [...a, ...b].map((p) => p.id).toList();
    expect(ids.length, all.length);
    expect(ids.toSet(), all.map((p) => p.id).toSet());
  });

  test('2 oyuncu 1-1 ayrılır', () {
    final (a, b) = balanceTeams(players([5, 1]));
    expect(a.length, 1);
    expect(b.length, 1);
  });

  test('aynı seed aynı sonucu verir', () {
    final all = players([5, 5, 4, 4, 3, 3, 2, 2, 1, 1]);
    final (a1, b1) = balanceTeams(all, rng: Random(42));
    final (a2, b2) = balanceTeams(all, rng: Random(42));
    expect(a1.map((p) => p.id), a2.map((p) => p.id));
    expect(b1.map((p) => p.id), b2.map((p) => p.id));
  });

  test('2 kaleci her takıma birer tane düşer', () {
    for (var seed = 0; seed < 20; seed++) {
      final (a, b) = balanceTeams(
        withKeepers([1, 1, 5, 5, 4, 3, 2, 2], 2),
        rng: Random(seed),
      );
      expect(keepers(a), 1);
      expect(keepers(b), 1);
      expect((a.length - b.length).abs(), lessThanOrEqualTo(1));
    }
  });

  test('3 kaleci varsa her takımda en az 1 kaleci olur', () {
    for (var seed = 0; seed < 20; seed++) {
      final (a, b) = balanceTeams(
        withKeepers([5, 2, 1, 4, 3, 3, 2], 3),
        rng: Random(seed),
      );
      expect(keepers(a), greaterThanOrEqualTo(1));
      expect(keepers(b), greaterThanOrEqualTo(1));
      expect((a.length - b.length).abs(), lessThanOrEqualTo(1));
    }
  });

  test('kaleci yoksa sonuç eskisiyle aynı', () {
    final (a1, b1) = balanceTeams(players([5, 4, 3, 2, 1, 1]), rng: Random(7));
    final (a2, b2) = balanceTeams(
      withKeepers([5, 4, 3, 2, 1, 1], 0),
      rng: Random(7),
    );
    expect(a1.map((p) => p.id), a2.map((p) => p.id));
    expect(b1.map((p) => p.id), b2.map((p) => p.id));
  });
}
