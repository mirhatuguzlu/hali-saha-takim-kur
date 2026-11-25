import 'package:flutter_test/flutter_test.dart';
import 'package:halisaha_takim_kur/logic/team_text.dart';
import 'package:halisaha_takim_kur/models/player.dart';

Player p(String name, int rating) =>
    Player(id: name, name: name, rating: rating);

void main() {
  test('iki takımı güçleriyle satır satır yazar', () {
    final text = teamsToText(
      [p('Ali', 5), p('Veli', 2)],
      [p('Can', 4), p('Efe', 3)],
    );
    expect(text, 'Takım A (güç 7): Ali, Veli\nTakım B (güç 7): Can, Efe');
  });

  test('tek oyunculu takımlar', () {
    expect(
      teamsToText([p('Ali', 1)], [p('Veli', 5)]),
      'Takım A (güç 1): Ali\nTakım B (güç 5): Veli',
    );
  });
}
