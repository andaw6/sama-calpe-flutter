import 'package:ehac_money/models/transaction.dart';
import 'package:uuid/uuid.dart';

class CreditPurchaseTransaction {
  String id;
  String transactionId;
  String receiverName;
  String receiverPhoneNumber;
  String? receiverEmail; // Nullable
  DateTime createdAt;

  CreditPurchaseTransaction({
    required this.id,
    required this.transactionId,
    required this.receiverName,
    required this.receiverPhoneNumber,
    this.receiverEmail,
    required this.createdAt,
  });

  // Générer un UUID pour chaque nouvelle transaction d'achat de crédit
  factory CreditPurchaseTransaction.create(
      String transactionId, String receiverName, String receiverPhoneNumber, String? receiverEmail) {
    DateTime now = DateTime.now();
    return CreditPurchaseTransaction(
      id: const Uuid().v4(), // Génération d'un UUID sans `const`
      transactionId: transactionId,
      receiverName: receiverName,
      receiverPhoneNumber: receiverPhoneNumber,
      receiverEmail: receiverEmail,
      createdAt: now,
    );
  }

  // Méthode fromJson pour la désérialisation d'un JSON
  factory CreditPurchaseTransaction.fromJson(Map<String, dynamic> json) {
    return CreditPurchaseTransaction(
      id: json['id'],
      transactionId: json['transactionId'],
      receiverName: json['receiverName'],
      receiverPhoneNumber: json['receiverPhoneNumber'],
      receiverEmail: json['receiverEmail'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']).toUtc() : DateTime.now(),
    );
  }
}
