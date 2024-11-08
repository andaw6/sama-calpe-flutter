import 'package:flutter/material.dart';
import 'package:ehac_money/models/transaction.dart';
import 'package:ehac_money/widget/transaction_item_widget.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final List<TransactionItem> transactions;

  const TransactionHistoryWidget({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {

    List<TransactionItem> sortedTransactions = List.from(transactions); // Crée une copie de la liste
    sortedTransactions.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))); // Tri décroissant par date

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Historique des transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Transactions List - scrollable section with fixed height
          SizedBox(
            height: 200, // Adjust the height if necessary
            child: ListView.separated(
              itemCount: 1,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return TransactionItemWidget(transaction: transactions[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Afficher tous les transactions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
