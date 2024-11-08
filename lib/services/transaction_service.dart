// transaction_service.dart
import 'package:ehac_money/models/enums/transaction_type.dart';
import 'package:ehac_money/models/transaction.dart';
import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/services/api_service.dart';

class TransactionService extends ApiService {
  TransactionService() : super("/transactions");

  // Mapping des transactions pour les transformer en TransactionItem
  TransactionItem mapToTransactionItem(Transaction transaction, bool isSender) {
    TransactionType transactionType = (transaction.transactionType.toString() ==
        TransactionType.transfer.toString())
        ? (isSender
        ? TransactionType.send
        : TransactionType.receive)
        : transaction.transactionType;

    final baseTransaction = TransactionItem(
      id: transaction.id,
      amount: transaction.amount,
      feeAmount: transaction.feeAmount,
      currency: transaction.currency,
      transactionType: transactionType,
      status: transaction.status,
      createdAt: transaction.createdAt!,
      user: transaction.creditPurchase != null
          ? UserInfo(
        id: transaction.creditPurchase!.id,
        name: transaction.creditPurchase!.receiverName,
        email: transaction.creditPurchase!.receiverEmail,
        phoneNumber: transaction.creditPurchase!.receiverPhoneNumber,
        isActive: true,
        role: transaction.sender?.role ?? '',
      )
          : (isSender ? transaction.receiver : transaction.sender),
    );

    return baseTransaction;
  }

  // Récupère toutes les transactions pour un utilisateur donné
  List<TransactionItem> getTransactionFromUser(User user) {
    List<TransactionItem> transactionItems = [];

    if (user.transactions != null) {
      for (var transaction in user.transactions!) {
        transactionItems.add(mapToTransactionItem(transaction, true));
      }
    }

    if (user.received != null) {
      for (var transaction in user.received!) {
        transactionItems.add(mapToTransactionItem(transaction, false));
      }
    }

    return transactionItems;
  }
}
