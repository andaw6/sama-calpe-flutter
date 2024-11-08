import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ClientDashboardPage extends StatelessWidget {
  const ClientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2962FF),
        title: const Text('Wave Money', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF448AFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Section
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('SOLDE DU PORTEFEUILLE'),
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const Text('• • • • • •',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ),

                  // QR Code Section
                  Card(
                    margin: const EdgeInsets.only(top: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Code QR'),
                          const SizedBox(height: 16),
                          QrImageView(
                            data: 'https://wavemoney.com/payment',
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Account Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.add, 'Transfert', Colors.blue),
                      _buildActionButton(Icons.payment, 'Paiements', Colors.indigo),
                      _buildActionButton(Icons.credit_card, 'Crédit', Colors.purple),
                      _buildActionButton(Icons.account_balance, 'Banque', Colors.teal),
                      _buildActionButton(Icons.card_giftcard, 'Cadeaux', Colors.pink),
                    ],
                  ),

                  // Transaction History
                  const SizedBox(height: 24),
                  const Text('Historique des transactions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  _buildTransactionItem(
                      'KD', 'Khady Diop', 'SEND', '95 FCFA', '07/11/2024', 'COMPLETED'
                  ),
                  _buildTransactionItem(
                      'DLV', 'Diary La vielle', 'SEND', '95 FCFA', '07/11/2024', 'COMPLETED'
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionItem(String avatar, String name, String type,
      String amount, String date, String status) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(avatar),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(name),
      subtitle: Text(type),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(amount),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(status, style: const TextStyle(fontSize: 12, color: Colors.green)),
        ],
      ),
    );
  }
}