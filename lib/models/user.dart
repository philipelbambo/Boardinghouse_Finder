class User {
  final String id;
  final String name;
  final String email;
  final List<String> favoriteBoardinghouseIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.favoriteBoardinghouseIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      favoriteBoardinghouseIds: List<String>.from(json['favoriteBoardinghouseIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'favoriteBoardinghouseIds': favoriteBoardinghouseIds,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    List<String>? favoriteBoardinghouseIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      favoriteBoardinghouseIds: favoriteBoardinghouseIds ?? this.favoriteBoardinghouseIds,
    );
  }
}