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

  factory UsersModels.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UsersModels(
      id: doc.id,
      name: data['name'] as String?,
      email: data['email'] as String?,
      photoUrl: data['photoUrl'] as String?,
      createdAt: data['createdAt'] as Timestamp,
      provider: data['provider'] as String,
      role: data['role'] as String? ?? 'user',
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
