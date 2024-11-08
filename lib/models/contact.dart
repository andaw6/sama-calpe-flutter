// lib/models/contact.dart

import 'package:ehac_money/models/user.dart';
import 'package:uuid/uuid.dart';

class Contact {
  String id;
  String userId;
  String name;
  String phoneNumber;
  String? email; // Nullable
  bool favorite;
  DateTime createdAt;
  UserInfo? user;

  Contact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.favorite = false,
    required this.createdAt,
    this.user,
  });

  // Générer un UUID pour chaque nouveau contact
  factory Contact.create(String userId, String name, String phoneNumber,
      [String? email]) {
    DateTime now = DateTime.now();
    return Contact(
      id: const Uuid().v4(), // Génération d'un UUID
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      favorite: false,
      createdAt: now,
    );
  }

   // Méthode fromJson pour la désérialisation d'un JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      favorite: json['favorite'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null, // Si 'user' est présent dans le JSON, crée un objet User
    );
  }
}
