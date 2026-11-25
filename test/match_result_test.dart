import 'package:flutter_test/flutter_test.dart';
import 'package:halisaha_takim_kur/logic/match_result.dart';
import 'package:halisaha_takim_kur/models/player.dart';

const ali = Player(id: '1', name: 'Ali', rating: 5);
const veli = Player(id: '2', name: 'Veli', rating: 3, wins: 2);
const can = Player(id: '3', name: 'Can', rating: 4);
const ece = Player(id: '4', name: 'Ece', rating: 2, losses: 1);
const all = [ali, veli, can, ece];

String stats(Player p) => '${p.wins}-${p.draws}-${p.losses}';

void main() {
  test('A kazanırsa A galibiyet, B mağlubiyet alır', () {
    final r = applyResult(all, [ali], [veli], 3, 1);
    expect(r.map(stats), ['1-0-0', '2-0-1', '0-0-0', '0-0-1']);
  });

  test('B kazanırsa B galibiyet, A mağlubiyet alır', () {
    final r = applyResult(all, [ali], [veli], 0, 2);
    expect(r.map(stats), ['0-0-1', '3-0-0', '0-0-0', '0-0-1']);
  });

  test('beraberlikte iki takım da beraberlik alır', () {
    final r = applyResult(all, [ali, can], [veli], 2, 2);
    expect(r.map(stats), ['0-1-0', '2-1-0', '0-1-0', '0-0-1']);
  });

  test('takım dışı oyuncu değişmez, diğer alanlar korunur', () {
    final r = applyResult(all, [ali], [veli], 1, 0);
    expect(r[3].toJson(), ece.toJson());
    expect(r[0].name, 'Ali');
    expect(r[0].rating, 5);
  });
}
