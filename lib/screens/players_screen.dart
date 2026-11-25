import 'package:material_ui/material_ui.dart';

import '../data/player_store.dart';
import '../logic/match_result.dart';
import '../models/player.dart';
import 'teams_screen.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final _groupStore = const GroupStore();
  List<String> _groups = ['Ana grup'];
  int _group = 0;
  List<Player> _players = [];

  PlayerStore get _store => PlayerStore(_group);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final groups = await _groupStore.load();
    final current = await _groupStore.loadCurrent();
    final group = current < groups.length ? current : 0;
    final players = await PlayerStore(group).load();
    if (!mounted) return;
    setState(() {
      _groups = groups;
      _group = group;
      _players = players;
    });
  }

  Future<void> _selectGroup(int group) async {
    if (group < 0) {
      final name = await showDialog<String>(
        context: context,
        builder: (_) => const _NewGroupDialog(),
      );
      if (name == null) return;
      group = _groups.length;
      await _groupStore.save([..._groups, name]);
    }
    await _groupStore.saveCurrent(group);
    await _load();
  }

  void _update(List<Player> players) {
    setState(() => _players = players);
    _store.save(players);
  }

  Future<void> _confirmRaise(Player p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Puanı artır'),
        content: Text(
          '${p.name} üst üste ${p.winStreak} maç kazandı. '
          'Puanı ${p.rating} → ${p.rating + 1} yapılsın mı?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Şimdi değil'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Artır'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    _update([for (final x in _players) x.id == p.id ? raiseRating(x) : x]);
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
    final coming = _players.where((p) => p.isComing).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halı Saha Takım Kur'),
        actions: [
          PopupMenuButton<int>(
            tooltip: 'Grup seç',
            onSelected: _selectGroup,
            itemBuilder: (_) => [
              for (var i = 0; i < _groups.length; i++)
                CheckedPopupMenuItem(
                  value: i,
                  checked: i == _group,
                  child: Text(_groups[i]),
                ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: -1,
                child: ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text('Yeni grup'),
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.groups),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      _groups[_group],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
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
                      leading: Checkbox(
                        value: p.isComing,
                        semanticLabel: 'Geliyor',
                        onChanged: (v) => _update([
                          for (final x in _players)
                            x.id == p.id ? x.copyWith(isComing: v) : x,
                        ]),
                      ),
                      title: Text(p.name),
                      subtitle: Row(
                        children: [
                          Text('★' * p.rating + '☆' * (5 - p.rating)),
                          const SizedBox(width: 12),
                          Text('G ${p.wins} · B ${p.draws} · M ${p.losses}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (suggestsRaise(p))
                            IconButton(
                              tooltip: 'Puanı artır',
                              color: Colors.green,
                              icon: const Icon(Icons.trending_up),
                              onPressed: () => _confirmRaise(p),
                            ),
                          if (p.isGoalkeeper)
                            const Icon(
                              Icons.sports_handball,
                              semanticLabel: 'Kaleci',
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: coming.length < 2
              ? null
              : () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamsScreen(
                        players: coming,
                        all: _players,
                        store: _store,
                      ),
                    ),
                  );
                  _load();
                },
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

class _NewGroupDialog extends StatefulWidget {
  const _NewGroupDialog();

  @override
  State<_NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<_NewGroupDialog> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni grup'),
      content: TextField(
        controller: _name,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Grup adı'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Oluştur')),
      ],
    );
  }
}
