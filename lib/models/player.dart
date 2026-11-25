class Player {
  final String id;
  final String name;
  final int rating;
  final bool isGoalkeeper;

  const Player({
    required this.id,
    required this.name,
    required this.rating,
    this.isGoalkeeper = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rating': rating,
    'isGoalkeeper': isGoalkeeper,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'] as String,
    name: json['name'] as String,
    rating: json['rating'] as int? ?? 3,
    isGoalkeeper: json['isGoalkeeper'] as bool? ?? false,
  );
}
