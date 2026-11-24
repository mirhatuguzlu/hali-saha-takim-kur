import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/player.dart';

class PlayerStore {
  static const _key = 'players';

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
