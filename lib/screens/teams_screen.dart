import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../logic/team_balancer.dart';
import '../logic/team_text.dart';
import '../models/player.dart';

class TeamsScreen extends StatefulWidget {
  final List<Player> players;

  const TeamsScreen({super.key, required this.players});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  late (List<Player>, List<Player>) _teams = balanceTeams(widget.players);

  int _power(List<Player> team) => team.fold(0, (s, p) => s + p.rating);

  Widget _team(String title, List<Player> team) => Card(
    child: Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text('Güç: ${_power(team)}'),
        ),
        for (final p in team)
          ListTile(
            dense: true,
            title: Text(p.name),
            trailing: Text('★' * p.rating),
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final (a, b) = _teams;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takımlar'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: teamsToText(a, b)));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Kopyalandı')));
            },
            icon: const Icon(Icons.copy),
            label: const Text('Kopyala'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _team('Takım A', a),
          _team('Takım B', b),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Güç farkı: ${(_power(a) - _power(b)).abs()}',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: () =>
              setState(() => _teams = balanceTeams(widget.players)),
          icon: const Icon(Icons.shuffle),
          label: const Text('Yeniden Karıştır'),
        ),
      ),
    );
  }
}
