import 'package:flutter/material.dart';
import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/services/user_service.dart';
import 'package:logger/logger.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final UserService _userService = UserService();
  final logger = Logger();

  User? get user => _user;

  Future<void> loadUser() async {
    try {
      logger.i("Début de la récupération de l'utilisateur");
      _user = await _userService.current();
      logger.i("Utilisateur récupéré : $_user");
      notifyListeners();
    } catch (e) {
      logger.e("Erreur lors de la récupération de l'utilisateur : $e");
    }
  }
}
