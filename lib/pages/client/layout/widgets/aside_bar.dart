import 'package:ehac_money/pages/client/dashboard/dashboard.dart';
import 'package:ehac_money/services/auth_service.dart';
import 'package:ehac_money/providers/user_provider.dart'; // Assurez-vous d'importer le UserProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsideBar extends StatelessWidget {
  AsideBar({super.key});
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2962FF),
            ),
            child: Consumer<UserProvider>(  // Utiliser Consumer pour écouter le UserProvider
              builder: (context, userProvider, child) {
                // Récupérer le nom et le rôle de l'utilisateur
                String userName = userProvider.user?.name ?? 'Utilisateur'; // Nom de l'utilisateur
                String userRole = userProvider.user?.role ?? 'Rôle'; // Rôle de l'utilisateur

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF2962FF), size: 40),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName, // Afficher le nom de l'utilisateur
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userRole.toUpperCase(), // Afficher le rôle de l'utilisateur
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tableau de bord'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ClientDashboardPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Transactions'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Factures'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Banque'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Cadeaux'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Color.fromARGB(255, 214, 60, 60)),
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Color.fromARGB(255, 214, 60, 60)),
            ),
            onTap: () async {
              if (context.mounted) {
                await authService.logout(callback: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                        (route) => false,
                  );
                }, removeUser: true);
              }
            },
          ),
        ],
      ),
    );
  }
}
