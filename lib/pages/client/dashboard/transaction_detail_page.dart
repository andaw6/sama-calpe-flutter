import 'package:flutter/material.dart';
import 'package:ehac_money/models/transaction.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${transaction.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Montant: ${transaction.amount}'),
            const SizedBox(height: 8),
            Text('Date: ${transaction.createdAt}'),
            // Ajoutez d'autres détails ici en fonction de la structure de votre objet TransactionItem
          ],
        ),
      ),
    );
  }
}
