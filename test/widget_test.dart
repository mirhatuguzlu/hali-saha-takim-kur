import 'package:flutter_test/flutter_test.dart';

import 'package:halisaha_takim_kur/main.dart';

void main() {
  testWidgets('uygulama başlığı görünür', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Halı Saha Takım Kur'), findsOneWidget);
  });
}
