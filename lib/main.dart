import 'package:material_ui/material_ui.dart';

import 'screens/players_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halı Saha Takım Kur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const PlayersScreen(),
    );
  }
}
