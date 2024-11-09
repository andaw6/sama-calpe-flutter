import 'package:ehac_money/services/api_service.dart';
import 'package:ehac_money/models/api_reponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'token_service.dart';

class AuthService extends ApiService {
  final TokenService _tokenService = TokenService();

  AuthService() : super("/auth");

  Future<bool> login({required String phone, required String password}) async {
    final ApiResponse<Map<String, dynamic>> response = await post(
      "/login",
      {'phone': phone, 'password': password},
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    if (response.success &&
        response.data != null &&
        response.data!['token'] != null) {
      logger.i("Token: ${response.data!['token']}");
      await _tokenService.setToken(response.data!['token']);
      _saveUserInfo(response.data!["token"]);

      return true;
    } else {
      logger.e("Erreur de connexion : jeton non trouvé.");
      return false;
    }
  }

  Future<void> logout({Function? callback, bool removeUser = false}) async {
    try {
      final test = await post('/logout', {}, fromJsonT: (json) => json);
      logger.i(test);
      await _tokenService.clearToken();

      logger.i("User logged out successfully.");
      callback?.call();
      if (removeUser) _clearUserInfo();
    } catch (e) {
      logger.e("Error during logout: $e");
    }
  }

  Future<String?> getPhoneNumberUser() async {
    final dynamic info = await getUserInfo();
    return info != null && info.containsKey("phoneNumber")
        ? info["phoneNumber"]
        : null;
  }

  Future<String?> getUserRole() async {
    final dynamic info = await getUserInfo();
    return info != null && info.containsKey("role") ? info["role"] : null;
  }

  Future<void> _saveUserInfo(dynamic userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_info', userInfo);
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString('user_info');
    if (userInfoString != null) {
      return _tokenService.decodeToken(userInfoString);
    } else {
      return null; // Retourner null si aucune donnée n'est trouvée
    }
  }

  Future<void> _clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_info');
  }
}
