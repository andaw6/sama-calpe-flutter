import 'dart:convert';
import 'package:ehac_money/models/api_reponse.dart';
import 'package:ehac_money/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  static const String apiUrl = "http://10.0.2.2:8000/api";
  late final String baseUrl;
  final logger = Logger();
  final _tokenService = TokenService();

  ApiService(String url) {
    baseUrl = apiUrl + url;
  }

  // Ajout du token à l'en-tête
  Future<Map<String, String>> _getHeaders() async {
    final token = await _tokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Méthode pour ajouter les query parameters à l'URL
  String _buildUrl(String endpoint, Map<String, String>? queryParams) {
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      return '$baseUrl$endpoint?$queryString';
    }
    return '$baseUrl$endpoint';
  }

  // Méthode GET avec support des query parameters et retour ApiResponse
  Future<ApiResponse<T>> get<T>(String endpoint,
      {Map<String, String>? queryParams,
      required T Function(Object? json) fromJsonT}) async {
    final headers = await _getHeaders();
    final url = _buildUrl(endpoint, queryParams);

    final response = await http.get(Uri.parse(url), headers: headers);
    _handleResponse(response);
    return ApiResponse.fromJson(json.decode(response.body), fromJsonT);
  }

  // Méthode POST avec support des query parameters et retour ApiResponse
  Future<ApiResponse<T>> post<T>(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? queryParams,
      required T Function(Object? json) fromJsonT}) async {
    final headers = await _getHeaders();
    final url = _buildUrl(endpoint, queryParams);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );
    _handleResponse(response);
    return ApiResponse.fromJson(json.decode(response.body), fromJsonT);
  }

  // Méthode PUT avec support des query parameters et retour ApiResponse
  Future<ApiResponse<T>> put<T>(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? queryParams,
      required T Function(Object? json) fromJsonT}) async {
    final headers = await _getHeaders();
    final url = _buildUrl(endpoint, queryParams);

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );
    _handleResponse(response);
    return ApiResponse.fromJson(json.decode(response.body), fromJsonT);
  }

  // Méthode PATCH avec support des query parameters et retour ApiResponse
  Future<ApiResponse<T>> patch<T>(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? queryParams,
      required T Function(Object? json) fromJsonT}) async {
    final headers = await _getHeaders();
    final url = _buildUrl(endpoint, queryParams);

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );
    _handleResponse(response);
    return ApiResponse.fromJson(json.decode(response.body), fromJsonT);
  }

  // Méthode DELETE avec support des query parameters et retour ApiResponse
  Future<ApiResponse<T>> delete<T>(String endpoint,
      {Map<String, String>? queryParams,
      required T Function(Object? json) fromJsonT}) async {
    final headers = await _getHeaders();
    final url = _buildUrl(endpoint, queryParams);

    final response = await http.delete(Uri.parse(url), headers: headers);
    _handleResponse(response);
    return ApiResponse.fromJson(json.decode(response.body), fromJsonT);
  }

  // Fonction pour gérer la réponse de l'API
  void _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Tout va bien
    } else {
      logger.e(
          'Erreur HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
