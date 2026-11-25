import 'package:material_ui/material_ui.dart';

import '../data/player_store.dart';
import '../models/player.dart';
import 'teams_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final _store = PlayerStore();
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final players = await _store.load();
    if (mounted) setState(() => _players = players);
  }

  void _update(List<Player> players) {
    setState(() => _players = players);
    _store.save(players);
  }

  Future<void> _addPlayer() async {
    final player = await showDialog<Player>(
      context: context,
      builder: (_) => const _AddPlayerDialog(),
    );
    if (player != null) _update([..._players, player]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halı Saha Takım Kur')),
      body: _players.isEmpty
          ? const Center(child: Text('Henüz oyuncu yok. + ile ekle.'))
          : ListView(
              children: [
                for (final p in _players)
                  Dismissible(
                    key: ValueKey(p.id),
                    background: Container(color: Colors.red),
                    onDismissed: (_) =>
                        _update(_players.where((x) => x.id != p.id).toList()),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text('★' * p.rating + '☆' * (5 - p.rating)),
                      trailing: p.isGoalkeeper
                          ? const Icon(
                              Icons.sports_handball,
                              semanticLabel: 'Kaleci',
                            )
                          : null,
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _players.length < 2
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeamsScreen(players: _players),
                  ),
                ),
          child: const Text('Takımları Kur'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayer,
        tooltip: 'Oyuncu ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddPlayerDialog extends StatefulWidget {
  const _AddPlayerDialog();

  @override
  State<_AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<_AddPlayerDialog> {
  final _name = TextEditingController();
  int _rating = 3;
  bool _isGoalkeeper = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(
      context,
      Player(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        rating: _rating,
        isGoalkeeper: _isGoalkeeper,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Oyuncu ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'İsim'),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: '$i puan',
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(i <= _rating ? Icons.star : Icons.star_border),
                ),
            ],
          ),
          CheckboxListTile(
            title: const Text('Kaleci'),
            value: _isGoalkeeper,
            onChanged: (v) => setState(() => _isGoalkeeper = v ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Ekle')),
      ],
    );
  }
}
