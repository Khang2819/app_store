import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModels {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final Timestamp? createdAt;
  final String? provider;
  final String role;

  UsersModels({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.provider,
    this.role = 'user',
  });

  factory UsersModels.fromMap(Map<String, dynamic> map) {
    return UsersModels(
      id: map['id'] as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] as Timestamp,
      provider: map['provider'] as String,
      role: map['role'] as String? ?? 'user',
    );
  }
  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'createdAt': createdAt,
    'provider': provider,
    'role': role,
  };
}
