import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:halisaha_takim_kur/main.dart';

Future<void> addPlayer(WidgetTester tester, String name, int rating) async {
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), name);
  await tester.tap(find.byTooltip('$rating puan'));
  await tester.tap(find.text('Ekle'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('uygulama başlığı görünür', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Halı Saha Takım Kur'), findsOneWidget);
  });

  testWidgets('oyuncu eklenir ve puanı görünür', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await addPlayer(tester, 'Ali', 4);

    expect(find.text('Ali'), findsOneWidget);
    expect(find.text('★★★★☆'), findsOneWidget);
  });

  testWidgets('boş isimle oyuncu eklenmez', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await addPlayer(tester, '   ', 3);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('Takımları Kur iki takımı ve güç farkını gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await addPlayer(tester, 'Ali', 5);
    await addPlayer(tester, 'Veli', 3);

    await tester.tap(find.text('Takımları Kur'));
    await tester.pumpAndSettle();
    expect(find.text('Takım A'), findsOneWidget);
    expect(find.text('Takım B'), findsOneWidget);
    expect(find.text('Güç farkı: 2'), findsOneWidget);

    await tester.tap(find.text('Yeniden Karıştır'));
    await tester.pumpAndSettle();
    expect(find.text('Güç farkı: 2'), findsOneWidget);
  });

  testWidgets('kaydırınca oyuncu silinir', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await addPlayer(tester, 'Veli', 2);

    await tester.drag(find.text('Veli'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Veli'), findsNothing);
  });
}
