class User {
  final int id;
  final String username;
  final int realmBit;
  final bool lock;

  User({required this.id, required this.username, required this.realmBit, required this.lock});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], username: json['username'], realmBit: json['realmBit'], lock: json['lock']);
  }
}
