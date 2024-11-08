// lib/models/bill.dart

import 'package:ehac_money/models/company.dart';
import 'package:ehac_money/models/enums/bill_status.dart';
import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/utils/functions.dart';
import 'package:uuid/uuid.dart';

class Bill {
  String id;
  String userId;
  String companyId;
  double amount;
  String currency;
  BillStatus status;
  Company? company;
  UserInfo? user;
  DateTime createdAt;

  Bill({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.company,
    this.user
  });

  // Générer un UUID pour chaque nouvel objet Bill
  factory Bill.create(String userId, String companyId, double amount,
      String currency, BillStatus status) {
    return Bill(
      id: const Uuid().v4(),
      userId: userId,
      companyId: companyId,
      amount: amount,
      currency: currency,
      status: status,
      createdAt: DateTime.now()
    );
  }

   // Méthode fromJson pour la désérialisation d'un JSON
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      userId: json['userId'],
      companyId: json['companyId'],
      amount: convertToDouble(json['amount']),
      currency: json['currency'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']).toUtc() : DateTime.now(),
      status: BillStatusExtension.fromString(json['status']),
      company: json['company'] != null ? Company.fromJson(json['company']) : null, // Si la société est incluse
      user: json["user"] != null ? UserInfo.fromJson(json["user"]) : null,
    );
  }
}
