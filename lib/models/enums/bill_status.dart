enum BillStatus {
  pending,
  paid,
  overdue,
}

extension BillStatusExtension on BillStatus {
  String get name {
    switch (this) {
      case BillStatus.pending:
        return 'PENDING';
      case BillStatus.paid:
        return 'PAID';
      case BillStatus.overdue:
        return 'OVERDUE';
    }
  }

  static BillStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return BillStatus.pending;
      case 'PAID':
        return BillStatus.paid;
      case 'OVERDUE':
        return BillStatus.overdue;
      default:
        throw ArgumentError('Invalid BillStatus value: $status');
    }
  }
}
