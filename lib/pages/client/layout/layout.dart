import 'package:ehac_money/pages/client/layout/widgets/aside_bar.dart';
import 'package:ehac_money/providers/user_provider.dart';
import 'package:ehac_money/services/token_expiry_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ClientLayout extends StatefulWidget {
  final Widget body;
  final String title;

  const ClientLayout({super.key, required this.body, this.title = 'Sama Calpé'});

  @override
  BaseLayoutState createState() => BaseLayoutState();
}

class BaseLayoutState extends State<ClientLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBalanceVisible = false;
  int _selectedIndex = 0; // Initialiser l'index sélectionné
  late TokenExpiryService _tokenExpiryService;  // Déclarez une instance de TokenExpiryService

  @override
  void initState() {
    super.initState();
    _loadUser();  // Chargement de l'utilisateur lors de l'initialisation
    //_tokenExpiryService = TokenExpiryService(context); // Initialiser le service avec le contexte
    //_tokenExpiryService.startTokenExpiryCheck(); // Démarrer la vérification du token
  }

  Future<void> _loadUser() async {
    await Provider.of<UserProvider>(context, listen: false).loadUser();
  }

  @override
  void dispose() {
    //_tokenExpiryService.stopTokenExpiryCheck(); // Arrêter la vérification quand le widget est détruit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100], // Définir la couleur de fond du layout
      appBar: AppBar(
        backgroundColor: const Color(0xFF2962FF), // Couleur de la barre de navigation
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // Icône du menu
          onPressed: () => _scaffoldKey.currentState?.openDrawer(), // Ouvrir le tiroir du menu
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white), // Icône des paramètres
            onPressed: () {
              // Action pour les paramètres
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white), // Icône du profil
            onPressed: () {
              // Action pour le profil
            },
          ),
        ],
      ),
      drawer: AsideBar(), // Assurez-vous que ce widget est correctement créé
      body: widget.body, // Corps du layout
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portefeuille',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Couleur de l'élément sélectionné
        unselectedItemColor: Colors.grey, // Couleur des éléments non sélectionnés
        onTap: _onItemTapped, // Fonction de gestion de la sélection de l'élément
        type: BottomNavigationBarType.fixed,
      ),
      // Utilisation du Consumer pour obtenir l'utilisateur actuel
      // floatingActionButton: Consumer<UserProvider>(
      //   builder: (context, userProvider, child) {
      //     // Vous pouvez utiliser ici les informations de l'utilisateur
      //     var currentUser = userProvider.user;
      //     return FloatingActionButton(
      //       onPressed: () {
      //         // Action avec l'utilisateur actuel
      //         final logger = Logger();
      //         logger.i('Utilisateur actuel: ${currentUser?.name}');
      //       },
      //       child: const Icon(Icons.account_circle),
      //     );
      //   },
      // ),
    );
  }

  // Fonction de gestion de la sélection dans la barre de navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mettre à jour l'index sélectionné
    });
  }
}
