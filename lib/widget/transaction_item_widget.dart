import 'package:ehac_money/models/enums/transaction_status.dart';
import 'package:ehac_money/models/enums/transaction_type.dart';
import 'package:ehac_money/models/transaction.dart';
import 'package:ehac_money/services/color_service.dart';
import 'package:flutter/material.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionItem transaction;
  final ColorService colorService = ColorService();
  TransactionItemWidget({
    super.key,
    required this.transaction,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                transaction.user!.name[0], // Première lettre du nom de l'utilisateur
                style: const TextStyle(
                  color: Color(0xFF2962FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.user!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorService.getTransactionTypeColor(transaction.transactionType),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.transactionType.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.createdAt.toString(), // Convertir en chaîne
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}', // Affichage du montant avec 2 décimales
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorService.getStatusColor(transaction.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction.status.name,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
