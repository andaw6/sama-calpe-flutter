enum TransactionType {
  deposit,
  withdraw,
  transfer,
  purchase,
  send,
  receive
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.deposit:
        return 'DEPOSIT';
      case TransactionType.withdraw:
        return 'WITHDRAW';
      case TransactionType.purchase:
        return 'PURCHASE';
      case TransactionType.transfer:
        return 'TRANSFER';
      case TransactionType.receive:
        return 'RECEIVE';
      case TransactionType.send:
        return 'SEND';
    }
  }

  // Méthode pour transformer un String en enum TransactionType
  static TransactionType fromString(String type) {
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        return TransactionType.deposit;
      case 'WITHDRAW':
        return TransactionType.withdraw;
      case 'TRANSFER':
        return TransactionType.transfer;
      case 'PURCHASE':
        return TransactionType.purchase;
      case 'RECEIVE':
        return TransactionType.receive;
      case 'SEND':
        return TransactionType.send;
      default:
        throw ArgumentError('Invalid TransactionType value: $type');
    }
  }
}
