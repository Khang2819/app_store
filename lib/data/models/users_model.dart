import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModels {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final Timestamp? createdAt;
  final String? provider;

  UsersModels({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    this.createdAt,
    this.provider,
  });

  factory UsersModels.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UsersModels(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt'] as Timestamp?,
      provider: data['provider'],
    );
  }
  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'createdAt': createdAt,
    'provider': provider,
  };
}
