import 'package:ehac_money/models/transaction.dart';
import 'package:ehac_money/pages/auth/login/code.dart';
import 'package:ehac_money/pages/auth/login/login.dart';
import 'package:ehac_money/pages/client/dashboard/dashboard.dart';
import 'package:ehac_money/pages/vendor/dashboard/dashboard.dart';
import 'package:ehac_money/providers/user_provider.dart';
import 'package:ehac_money/services/auth_service.dart';
import 'package:ehac_money/services/token_service.dart';
import 'package:ehac_money/services/transaction_service.dart';
import 'package:ehac_money/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
  // getPhoneNumber();
  //testUser();
  // resetToken();

}

Future<void> resetToken() async{
  final authService = AuthService();
  authService.logout(removeUser: true);
}

Future<void> testToken() async{
  final tokenService = TokenService();
  final logger = Logger();
  final token = await tokenService.getToken();
  final isToken = await tokenService.isTokenExpired();
  logger.i(token);
  logger.i(isToken);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sama Calpé',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder<Widget>(
                future: _getInitialScreen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading indicator while waiting
                  } else {
                    return snapshot.data ??
                        const PinLoginScreen(); // Fallback to PinLoginScreen if data is null
                  }
                },
              ),
          '/client/dashboard': (context) => const ClientDashboardPage(),
          '/vendor/dashboard': (context) => const VendorDashboardPage()
        });
  }

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      return const PinCodeScreen();
    } else {
      return const PinLoginScreen();
    }
  }
}

Future<void> getPhoneNumber() async{
  final userService =  UserService();
  final logger = Logger();
  final result = userService.findByPhone(phone: "778133536");
  logger.i(result);
  return;
}

Future<void> testUser() async {
  final logger = Logger();
  final userService = UserService();
  try {
    final test = await userService.current();
    List<TransactionItem> trans = TransactionService().getTransactionFromUser(test);
    logger.i(test);
  } catch (e) {
    logger.e('Récupe user : $e');
  }
}


