import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;
  final double amount;
  final String currency;

  const BalanceCard({
    super.key,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
    required this.amount,
    this.currency = "XOR"
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2962FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SOLDE DU PORTEFEUILLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(
                  isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: onToggleVisibility,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isBalanceVisible ? '$amount $currency' : '• • • • • •',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
