import 'package:flutter_test/flutter_test.dart';
import 'package:halisaha_takim_kur/data/player_store.dart';
import 'package:halisaha_takim_kur/models/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('boş depoda liste boş döner', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await PlayerStore().load(), isEmpty);
  });

  test('kaydedilen liste aynı şekilde yüklenir', () async {
    SharedPreferences.setMockInitialValues({});
    final store = PlayerStore();
    await store.save(const [
      Player(id: '1', name: 'Ali', rating: 5),
      Player(id: '2', name: 'Veli', rating: 2, isGoalkeeper: true),
    ]);

    final loaded = await store.load();
    expect(loaded.map((p) => p.toJson()).toList(), [
      {
        'id': '1',
        'name': 'Ali',
        'rating': 5,
        'isGoalkeeper': false,
        'wins': 0,
        'draws': 0,
        'losses': 0,
      },
      {
        'id': '2',
        'name': 'Veli',
        'rating': 2,
        'isGoalkeeper': true,
        'wins': 0,
        'draws': 0,
        'losses': 0,
      },
    ]);
  });

  test('kaleci alanı olmayan eski kayıt bozulmaz', () {
    final p = Player.fromJson({'id': '1', 'name': 'Ali', 'rating': 4});
    expect(p.isGoalkeeper, isFalse);
    expect(p.rating, 4);
    expect([p.wins, p.draws, p.losses], [0, 0, 0]);
  });
}
