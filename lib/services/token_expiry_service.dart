import 'dart:async';
import 'package:flutter/material.dart';
import 'token_service.dart';

class TokenExpiryService {
  final TokenService _tokenService = TokenService();
  final BuildContext context;
  late Timer _tokenCheckTimer;

  TokenExpiryService(this.context);

  // Méthode pour vérifier le token toutes les 5 minutes
  void startTokenExpiryCheck() {
    // Attendre 1 minute avant de démarrer la vérification périodique
    Future.delayed(const Duration(minutes: 1), () {
      _tokenCheckTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
        final isExpired = await _tokenService.isTokenExpired();

        if (isExpired) {
          if (context.mounted) {
            _tokenService.clearToken();
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      });
    });
  }


  // Méthode pour arrêter la vérification périodique
  void stopTokenExpiryCheck() {
    if (_tokenCheckTimer.isActive) {
      _tokenCheckTimer.cancel();
    }
  }
}
