import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/player.dart';

/// Saves one group's players; group 0 keeps the original `players` key.
class PlayerStore {
  final int group;

  const PlayerStore([this.group = 0]);

  String get _key => group == 0 ? 'players' : 'players_$group';

  Future<List<Player>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Player.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> save(List<Player> players) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(players.map((p) => p.toJson()).toList()),
    );
  }
}

/// Group names (index = [PlayerStore.group]) and the selected group.
class GroupStore {
  static const _groupsKey = 'groups';
  static const _currentKey = 'currentGroup';

  const GroupStore();

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_groupsKey) ?? ['Ana grup'];
  }

  Future<void> save(List<String> groups) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_groupsKey, groups);
  }

  Future<int> loadCurrent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentKey) ?? 0;
  }

  Future<void> saveCurrent(int group) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentKey, group);
  }
}
