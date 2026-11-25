class Player {
  final String id;
  final String name;
  final int rating;
  final bool isGoalkeeper;
  final int wins;
  final int draws;
  final int losses;

  const Player({
    required this.id,
    required this.name,
    required this.rating,
    this.isGoalkeeper = false,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rating': rating,
    'isGoalkeeper': isGoalkeeper,
    'wins': wins,
    'draws': draws,
    'losses': losses,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'] as String,
    name: json['name'] as String,
    rating: json['rating'] as int? ?? 3,
    isGoalkeeper: json['isGoalkeeper'] as bool? ?? false,
    wins: json['wins'] as int? ?? 0,
    draws: json['draws'] as int? ?? 0,
    losses: json['losses'] as int? ?? 0,
  );
}
