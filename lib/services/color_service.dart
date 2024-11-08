import 'package:ehac_money/models/enums/transaction_status.dart';
import 'package:ehac_money/models/enums/transaction_type.dart';
import 'package:flutter/material.dart';

class ColorService {
  // Fonction pour obtenir la couleur en fonction du statut
  Color getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return const Color(0xFFFFF9C4); // Jaune clair pour 'pending'
      case TransactionStatus.completed:
        return const Color(0xFFC8E6C9); // Vert clair pour 'completed'
      case TransactionStatus.failed:
        return const Color(0xFFFFCDD2); // Rouge clair pour 'failed'
      case TransactionStatus.cancelled:
        return const Color(0xFFEEEEEE); // Gris clair pour 'cancelled'
      default:
        return const Color(0xFFE8F5E9); // Défaut (vert clair)
    }
  }

  // Fonction pour obtenir la couleur de fond et du texte en fonction du type de transaction
  Color getTransactionTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return const Color(0xFFC8E6C9); // Vert clair pour 'deposit'
      case TransactionType.withdraw:
        return const Color(0xFFFFCDD2); // Rouge clair pour 'withdraw'
      case TransactionType.purchase:
        return const Color(0xFFFFF59D); // Jaune pour 'purchase'
      case TransactionType.transfer:
        return const Color.fromARGB(255, 75, 131, 177); // Bleu clair pour 'transfer'
        case TransactionType.send:
        return const Color(0xFFBBDEFB); // Bleu clair pour 'send'
      case TransactionType.receive:
        return const Color(0xFFF3E5F5); // Violet clair pour 'receive'
      default:
        return const Color(0xFFE3F2FD); // Bleu clair par défaut
    }
  }
}

