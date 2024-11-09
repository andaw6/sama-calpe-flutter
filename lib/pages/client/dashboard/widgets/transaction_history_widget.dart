import 'package:flutter/material.dart';
import 'package:ehac_money/models/transaction.dart';
import 'package:ehac_money/widget/transaction_item_widget.dart';
import 'package:ehac_money/pages/client/dashboard/transaction_detail_page.dart'; // Importer la page de détails

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
          const Divider(height: 1),
          // Transactions List - scrollable section with separators for all items
          ListView.separated(
            shrinkWrap: true,  // Permet à la ListView de s'ajuster automatiquement à la taille de son contenu
            physics: NeverScrollableScrollPhysics(),  // Empêche un défilement interne pour faire défiler toute la page
            itemCount: 3,
            separatorBuilder: (context, index) {
              // Ajoute un séparateur après chaque élément, y compris le dernier
              return const Divider(height: 1);
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Naviguer vers la page de détails de la transaction
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailPage(transaction: sortedTransactions[index]),
                    ),
                  );
                },
                child: TransactionItemWidget(transaction: sortedTransactions[index]),
              );
            },
          ),
          const Divider(height: 1),
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
