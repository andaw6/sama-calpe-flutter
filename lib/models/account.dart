import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/utils/functions.dart';
import 'package:uuid/uuid.dart';

class Account {
  String id;
  String userId;
  double balance;
  String currency;
  String qrCode;
  bool isActive;
  double plafond;
  UserInfo? user;

  Account({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.qrCode,
    required this.isActive,
    required this.plafond,
    this.user
  });

  // Générer un UUID pour chaque nouvel utilisateur
  factory Account.create(String userId, double balance, String currency,
      String qrCode, bool isActive, double plafond) {
    return Account(
      id: const Uuid().v4(), // Génération d'un UUID
      userId: userId,
      balance: balance,
      currency: currency,
      qrCode: qrCode,
      isActive: isActive,
      plafond: plafond,
    );
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['userId'],
      balance: convertToDouble(json['balance']),
      currency: json['currency'],
      qrCode: json['qrCode'],
      isActive: json['isActive'],
      plafond: convertToDouble(json["plafond"]),
      user: json["user"] != null ? UserInfo.fromJson(json["user"]) : null,
    );
  }
}
