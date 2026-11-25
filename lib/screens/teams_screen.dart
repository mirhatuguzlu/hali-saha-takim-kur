import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../data/player_store.dart';
import '../logic/match_result.dart';
import '../logic/team_balancer.dart';
import '../logic/team_text.dart';
import '../models/player.dart';

class TeamsScreen extends StatefulWidget {
  /// Players to split into teams.
  final List<Player> players;

  /// Whole roster; results are saved into it so absent players are kept.
  final List<Player>? all;

  /// Where results are saved (the current group).
  final PlayerStore store;

  const TeamsScreen({
    super.key,
    required this.players,
    this.all,
    this.store = const PlayerStore(),
  });

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  late (List<Player>, List<Player>) _teams = balanceTeams(widget.players);
  late List<Player> _all = widget.all ?? widget.players;

  Future<void> _saveResult() async {
    final score = await showDialog<(int, int)>(
      context: context,
      builder: (_) => const _ResultDialog(),
    );
    if (score == null) return;
    final (a, b) = _teams;
    _all = applyResult(_all, a, b, score.$1, score.$2);
    await widget.store.save(_all);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sonuç kaydedildi: ${score.$1}–${score.$2}')),
    );
  }

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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    setState(() => _teams = balanceTeams(widget.players)),
                icon: const Icon(Icons.shuffle),
                label: const Text('Yeniden Karıştır'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: _saveResult,
                icon: const Icon(Icons.scoreboard),
                label: const Text('Sonucu Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultDialog extends StatefulWidget {
  const _ResultDialog();

  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog> {
  final _a = TextEditingController();
  final _b = TextEditingController();

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  Widget _goals(String label, TextEditingController c) => Expanded(
    child: TextField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(labelText: label),
    ),
  );

  void _submit() {
    final a = int.tryParse(_a.text);
    final b = int.tryParse(_b.text);
    if (a == null || b == null) return;
    Navigator.pop(context, (a, b));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Maç sonucu'),
      content: Row(
        children: [
          _goals('Takım A', _a),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('–'),
          ),
          _goals('Takım B', _b),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Kaydet')),
      ],
    );
  }
}
