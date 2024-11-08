import 'package:ehac_money/models/account.dart';
import 'package:ehac_money/models/bill.dart';
import 'package:ehac_money/models/contact.dart';
import 'package:ehac_money/models/transaction.dart';
import 'package:uuid/uuid.dart';

class User {
  String id;
  String name;
  String? email;
  String phoneNumber;
  bool isActive;
  String role;
  List<Transaction> transactions;
  List<Transaction> received;
  List<Bill> bills;
  Account? account;
  List<Contact> contacts;

  User({
    required this.id,
    required this.name,
     this.email,
    required this.phoneNumber,
    required this.isActive,
    required this.role,
    this.account,
    this.transactions = const [], // Initialisation par défaut
    this.received = const [],
    this.bills = const [],
    this.contacts = const [],
  });

  // Générer un UUID pour chaque nouvel utilisateur
  factory User.create(String name, String email, String password,
      String phoneNumber, bool isActive, String role) {
    return User(
      id: const Uuid().v4(), // Génération d'un UUID
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      isActive: isActive,
      role: role,
    );
  }

 // Ajouter une méthode 'fromJson' pour convertir le JSON en objet 'User'
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'],
      role: json['role'],
        account: json['account'] != null
            ? Account.fromJson(json["account"]):null,
        transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((transactionJson) => Transaction.fromJson(transactionJson as Map<String, dynamic>))
          .toList(),
      received: (json['received_transactions'] as List<dynamic>? ?? [])
          .map((transactionJson) => Transaction.fromJson(transactionJson as Map<String, dynamic>))
          .toList(),
      bills: (json['bills'] as List<dynamic>? ?? [])
          .map((billJson) => Bill.fromJson(billJson as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>? ?? [])
          .map((contactJson) => Contact.fromJson(contactJson as Map<String, dynamic>))
          .toList(),
    );
  }
}


class UserInfo{
  String id;
  String name;
  String? email;
  String phoneNumber;
  bool isActive;
  String role;

  UserInfo({
    required this.id,
    required this.name,
    this.email,
    required this.phoneNumber,
    required this.isActive,
    required this.role,
  });

  // Générer un UUID pour chaque nouvel utilisateur
  factory UserInfo.create(String name, String email, String password,
      String phoneNumber, bool isActive, String role) {
    return UserInfo(
      id: const Uuid().v4(), // Génération d'un UUID
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      isActive: isActive,
      role: role,
    );
  }
  // Ajouter une méthode 'fromJson' pour convertir le JSON en objet 'User'
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'],
      role: json['role'],
    );
  }
}