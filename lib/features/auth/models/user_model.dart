class UserModel {
  final int id;
  final String username;
  final String email;
  final bool isActive;
  final DateTime createdAt;
  final String? accessToken;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isActive,
    required this.createdAt,
    this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    String? accessToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
