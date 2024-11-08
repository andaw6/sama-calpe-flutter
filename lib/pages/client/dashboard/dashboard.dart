import 'package:ehac_money/models/transaction.dart';
import 'package:ehac_money/pages/client/dashboard/widgets/action_button_widget.dart';
import 'package:ehac_money/pages/client/dashboard/widgets/balance_card_widget.dart';
import 'package:ehac_money/pages/client/dashboard/widgets/qr_code_card_widget.dart';
import 'package:ehac_money/pages/client/dashboard/widgets/transaction_history_widget.dart';
import 'package:ehac_money/pages/client/layout/layout.dart';
import 'package:ehac_money/providers/user_provider.dart';
import 'package:ehac_money/services/transaction_service.dart';
import 'package:ehac_money/widget/transaction_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({super.key});

  @override
  ClientDashboardState createState() => ClientDashboardState();
}

class ClientDashboardState extends State<ClientDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBalanceVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClientLayout(
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        final currentUser = userProvider.user;

        if (currentUser == null) {
          return const Center(child: CircularProgressIndicator());
        }

        List<TransactionItem> transactions = TransactionService().getTransactionFromUser(currentUser);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BalanceCard(
                        isBalanceVisible: isBalanceVisible,
                        onToggleVisibility: () {
                          setState(() {
                            isBalanceVisible = !isBalanceVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const QrCodeCard(),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                            icon: Icons.send,
                            color: Color(0xFF2962FF),
                            label: "Transfert",
                          ),
                          ActionButton(
                            icon: Icons.receipt_long,
                            color: Color(0xFF3D5AFE),
                            label: "Paiement",
                          ),
                          ActionButton(
                            icon: Icons.account_balance_wallet,
                            color: Color(0xFF2962FF),
                            label: "Crédit",
                          ),
                          ActionButton(
                            icon: Icons.qr_code,
                            color: Color(0xFF3D5AFE),
                            label: "Scanner",
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TransactionHistoryWidget(transactions: transactions),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
