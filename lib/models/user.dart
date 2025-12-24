import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String username;
  
  @HiveField(2)
  final String password;
  
  @HiveField(3)
  final String displayName;
  
  @HiveField(4)
  final String role; // admin or delegate
  
  @HiveField(5)
  final DateTime? subscriptionEnd;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final bool isActive;
  
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.displayName,
    required this.role,
    this.subscriptionEnd,
    required this.createdAt,
    this.isActive = true,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      subscriptionEnd: json['subscriptionEnd'] != null 
          ? DateTime.parse(json['subscriptionEnd'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'displayName': displayName,
      'role': role,
      'subscriptionEnd': subscriptionEnd?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
  
  User copyWith({
    String? id,
    String? username,
    String? password,
    String? displayName,
    String? role,
    DateTime? subscriptionEnd,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
