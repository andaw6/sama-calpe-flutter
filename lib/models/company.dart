// lib/models/company.dart

import 'package:uuid/uuid.dart';

class Company {
  String id;
  String name;
  String type;
  String? icon; // Nullable

  Company({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
  });

  // Générer un UUID pour chaque nouvelle entreprise
  factory Company.create(String name, String type, [String? icon]) {
    return Company(
      id: const Uuid().v4(), // Génération d'un UUID
      name: name,
      type: type,
      icon: icon,
    );
  }

   // Méthode fromJson pour la désérialisation d'un JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'], // Si l'icône est présente, elle sera affectée, sinon elle sera null
    );
  }
}