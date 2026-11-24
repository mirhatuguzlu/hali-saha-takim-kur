class Player {
  final String id;
  final String name;
  final int rating;

  const Player({required this.id, required this.name, required this.rating});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'rating': rating};

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'] as String,
    name: json['name'] as String,
    rating: json['rating'] as int? ?? 3,
  );
}
