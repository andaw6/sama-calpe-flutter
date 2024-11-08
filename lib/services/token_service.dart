import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Assurez-vous que cette dépendance est incluse.

class TokenService {
  // Récupère le token depuis les préférences partagées ou autre stockage sécurisé.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');  // Remplacez par la clé de votre token.
  }

  // Décode le token JWT et vérifie s'il est expiré.
  Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) {
      return true; // Aucun token, donc expiré
    }

    try {
      // Décoder le token JWT
      final payload = Jwt.parseJwt(token);
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

      // Vérifier si la date d'expiration est dans le passé
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // Si le token est invalide ou ne peut pas être décodé, le considérer comme expiré.
    }
  }

  // Méthode pour décoder un token JWT et extraire ses informations
  Map<String, dynamic> decodeToken(String token) {
    try {
      final payload = Jwt.parseJwt(token);  // Décoder le token JWT
      return payload;  // Retourner les données du payload
    } catch (e) {
      throw Exception("Erreur de décodage du token: $e");
    }
  }

  // Enregistrer un nouveau token dans les préférences partagées.
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  // Effacer le token du stockage.
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }
}
