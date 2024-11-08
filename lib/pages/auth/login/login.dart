import 'package:ehac_money/models/enums/user_role.dart';
import 'package:ehac_money/services/auth_service.dart';
import 'package:ehac_money/widget/success_dialog_witget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:logger/logger.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  PinLoginScreenState createState() => PinLoginScreenState();
}

class PinLoginScreenState extends State<PinLoginScreen>
    with SingleTickerProviderStateMixin {
  String phoneNumber = '';
  String pin = '';
  bool isShaking = false;
  bool isLoading = false;
  double _penguinOffset = 0;
  String? phoneNumberError;
  final logger= Logger();
  final authService = AuthService();


  late AnimationController _shakeController;
  late Animation<double> _bounceAnimation;

  final RegExp _senegalPhoneRegex = RegExp(
    r'^(\+221)?(7[0678]\d{7})$',
  );

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 5).animate(_shakeController)
      ..addListener(() {
        setState(() {
          _penguinOffset =
              math.sin(DateTime.now().millisecondsSinceEpoch / 300) * 5;
        });
      });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void handlePinChange(String value) {
    String cleanedValue = value
        .replaceAll(RegExp(r'\D'), '')
        .substring(0, math.min(4, value.length));
    setState(() {
      pin = cleanedValue;
    });
    if (cleanedValue.length == 4) {
      checkPin(cleanedValue);
    }
  }

  Future<void> checkPin(String enteredPin) async {
    setState(() {
      isLoading = true;
    });


    bool isValid = await authService.login(phone: phoneNumber, password: pin);
    setState(() {
      isLoading = false;
    });

    if (isValid) {
      String? userRole = await authService.getUserRole();
      if (mounted) {
        if (userRole == UserRole.client.name) {
          Navigator.pushReplacementNamed(context, '/client/dashboard');
        } else if (userRole == UserRole.vendor.name) {
          Navigator.pushReplacementNamed(context, '/vendor/dashboard');
        } else {
          _showSuccessDialog();
        }
        return;
      }
    }

    // Si le login est incorrect
    setState(() {
      isShaking = true;
      pin = '';
      phoneNumber = ''; // Réinitialisation du numéro de téléphone
    });

    _shakeController.forward(from: 0.0); // Démarre l'animation de shake
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      isShaking = false;
    });
  }


  void validatePhoneNumber(String value) {
    setState(() {
      phoneNumber = value;
      phoneNumberError = _senegalPhoneRegex.hasMatch(value)
          ? null
          : "Entrez un numéro sénégalais valide (ex. +2217XX...)";
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche la fermeture du dialog en cliquant en dehors
      builder: (BuildContext context) {
        return const SuccessDialog(message: "Vous n'être pas sur cette app");
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _shakeController.value *
                        10 *
                        (math.Random().nextBool() ? 1 : -1),
                    0,
                  ),
                  child: child,
                );
              },
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, _penguinOffset),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4158D0).withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
                          ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
                          ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Numéro de téléphone',
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        errorText: phoneNumberError,
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: validatePhoneNumber,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '• • • •',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 10,
                      ),
                      onChanged: handlePinChange,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: isLoading ? null : () => checkPin(pin),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF4158D0),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        shadowColor: const Color(0xFF4158D0).withOpacity(0.5),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4158D0),
                        side: const BorderSide(
                          color: Color(0xFF4158D0),
                          width: 1.5,
                        ),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Créer un nouveau compte',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
