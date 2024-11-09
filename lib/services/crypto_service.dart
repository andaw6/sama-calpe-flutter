import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class CryptoService {
  final int saltRounds = 10;
  final String secretKey = 'ehacdev-sama-calpé'; // Remplacez par une clé secrète sécurisée
  final logger = Logger();


  // Hachage unidirectionnel avec bcrypt
  Future<String> hashData(String data) async {
    try {
      final salt = await FlutterBcrypt.salt();
      final hashedData = await FlutterBcrypt.hashPw(password: data, salt: salt);
      return hashedData;
    } catch (error) {
      logger.e('Error hashing data: $error');
      rethrow;
    }
  }

  // Comparaison de données avec un hash bcrypt
  Future<bool> verifyHash(String data, String hash) async {
    try {
      final isValid = await FlutterBcrypt.verify(password: data, hash: hash);  // Correction ici
      return isValid;
    } catch (error) {
      logger.e('Error comparing data: $error');
      rethrow;
    }
  }

  // Génère une clé de 32 bytes à partir de la clé secrète
  List<int> _generateKey() {
    final bytes = utf8.encode(secretKey);
    final hash = sha256.convert(bytes);
    return hash.bytes;
  }

  // Génère un IV aléatoire de 16 bytes
  List<int> _generateIv() {
    // En production, utilisez une méthode sécurisée pour générer l'IV
    return List<int>.filled(16, 0); // Exemple simple, à modifier en production
  }

  // Chiffrement AES pour des données réversibles
  String encrypt(String data) {
    try {
      final key = _generateKey();
      final iv = _generateIv();
      
      // Création du cipher
      final cipher = AesCbc(key: key, iv: iv);
      
      // Chiffrement des données
      final paddedData = _addPKCS7Padding(utf8.encode(data));
      final encrypted = cipher.encrypt(paddedData);
      
      // Concaténation de l'IV et des données chiffrées
      final combined = [...iv, ...encrypted];
      
      return base64.encode(combined);
    } catch (error) {
      logger.e('Error encrypting data: $error');
      rethrow;
    }
  }

  // Déchiffrement AES pour des données réversibles
  String decrypt(String encryptedData) {
    try {
      final combined = base64.decode(encryptedData);
      
      // Extraction de l'IV et des données chiffrées
      final iv = combined.sublist(0, 16);
      final encrypted = combined.sublist(16);
      
      final key = _generateKey();
      
      // Création du cipher
      final cipher = AesCbc(key: key, iv: iv);
      
      // Déchiffrement et suppression du padding
      final decrypted = cipher.decrypt(encrypted);
      final unpaddedData = _removePKCS7Padding(decrypted);
      
      return utf8.decode(unpaddedData);
    } catch (error) {
      logger.e('Error decrypting data: $error');
      rethrow;
    }
  }

  // Ajout du padding PKCS7
  List<int> _addPKCS7Padding(List<int> data) {
    final padLength = 16 - (data.length % 16);
    return [...data, ...List<int>.filled(padLength, padLength)];
  }

  // Suppression du padding PKCS7
  List<int> _removePKCS7Padding(List<int> data) {
    final padLength = data.last;
    return data.sublist(0, data.length - padLength);
  }
}

class AesCbc {
  final List<int> key;
  final List<int> iv;

  AesCbc({required this.key, required this.iv});

  List<int> encrypt(List<int> data) {
    // Implémentation du chiffrement AES-CBC
    // Utilisez la bibliothèque 'crypto' pour l'implémentation réelle
    throw UnimplementedError('Implement actual encryption using crypto package');
  }

  List<int> decrypt(List<int> encryptedData) {
    // Implémentation du déchiffrement AES-CBC
    // Utilisez la bibliothèque 'crypto' pour l'implémentation réelle
    throw UnimplementedError('Implement actual decryption using crypto package');
  }
}