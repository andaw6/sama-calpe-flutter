import 'package:ehac_money/models/api_reponse.dart';
import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/services/api_service.dart';
import 'package:logger/logger.dart';

class UserService extends ApiService {
  UserService() : super("/users");

  // Marquer la méthode comme 'async' pour permettre l'utilisation de 'await'
  Future<User> current() async {
    // Utilisation de 'await' pour attendre la réponse
    final ApiResponse<Map<String, dynamic>> response = await get(
      "/current",
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    // Vérifiez si 'ApiResponse' a une méthode ou un champ pour obtenir le code d'état
    if (response.success) {
      return User.fromJson(response.data!);
    } else {
      throw Exception("Erreur lors de la récupération de l'utilisateur");
    }
  }

  Future<User?> findByPhone({required String phone}) async {
    final ApiResponse<Map<String, dynamic>> response = await get(
      "/phone/$phone",
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    if(response.success){
      return User.fromJson(response.data!);
    }{
      logger.e("Utilisateur avec le numéro $phone n'exist pas");
      return null;
    }
  }
}
