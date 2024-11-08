import 'package:ehac_money/models/credit_purchase_transaction.dart';
import 'package:ehac_money/models/enums/transaction_status.dart';
import 'package:ehac_money/models/enums/transaction_type.dart';
import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/utils/functions.dart';

// Classe de base pour les transactions
class TransactionBase {
  final String id;
  final double amount;
  final double feeAmount;
  final String currency;
  final TransactionType transactionType;
  final TransactionStatus status;
  final DateTime? createdAt;

  TransactionBase({
    required this.id,
    required this.amount,
    required this.feeAmount,
    required this.currency,
    required this.transactionType,
    required this.status,
    this.createdAt,
  });

  factory TransactionBase.fromJson(Map<String, dynamic> json) {
    return TransactionBase(
      id: json['id'],
      amount: json['amount'].toDouble(),
      feeAmount: json['feeAmount'].toDouble(),
      currency: json['currency'],
      transactionType: json['transactionType'],
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}

// Classe Transaction qui hérite de TransactionBase
class Transaction extends TransactionBase {
  final String senderId;
  final String? receiverId;
  final UserInfo? sender;
  final UserInfo? receiver;
  final CreditPurchaseTransaction? creditPurchase;

  Transaction({
    required String id,
    required double amount,
    required this.senderId,
    this.receiverId,
    required double feeAmount,
    required String currency,
    required TransactionType transactionType,
    required TransactionStatus status,
    required DateTime createdAt,
    this.sender,
    this.receiver,
    this.creditPurchase,
  }) : super(
          id: id,
          amount: amount,
          feeAmount: feeAmount,
          currency: currency,
          transactionType: transactionType,
          status: status,
          createdAt: createdAt,
        );

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount:  convertToDouble(json['amount']),
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      feeAmount:convertToDouble(json['feeAmount']),
      currency: json['currency'],
      transactionType: TransactionTypeExtension.fromString(json['transactionType']),
      status: TransactionStatusExtension.fromString(json['status']),
      createdAt: json["created_at"] != null ? DateTime.parse(json['created_at']).toUtc() : DateTime.now(),
      //createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      sender: json['sender'] != null ? UserInfo.fromJson(json['sender']) : null,

      receiver: json['receiver'] != null ? UserInfo.fromJson(json['receiver']) : null,
      creditPurchase: json['credit_purchase'] != null
          ? CreditPurchaseTransaction.fromJson(json['credit_purchase'])
          : null,
    );
  }
}

// Classe TransactionItem qui hérite de TransactionBase
class TransactionItem extends TransactionBase {
  final UserInfo? user;

  TransactionItem({
    required String id,
    required double amount,
    required double feeAmount,
    required String currency,
    required TransactionType transactionType,
    required TransactionStatus status,
    required DateTime createdAt,
    this.user,
  }) : super(
          id: id,
          amount: amount,
          feeAmount: feeAmount,
          currency: currency,
          transactionType: transactionType,
          status: status,
          createdAt: createdAt,
        );

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      amount: json['amount'].toDouble(),
      feeAmount: json['feeAmount'].toDouble(),
      currency: json['currency'],
      transactionType: TransactionTypeExtension.fromString(json['transactionType']),
      status: TransactionStatusExtension.fromString(json['status']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
    );
  }
}
