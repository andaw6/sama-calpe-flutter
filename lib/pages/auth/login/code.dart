import 'package:ehac_money/models/enums/user_role.dart';
import 'package:ehac_money/pages/auth/login/widgets/numeric_keypad_widget.dart';
import 'package:ehac_money/pages/auth/login/widgets/pin_dots_widget.dart';
import 'package:ehac_money/pages/auth/login/widgets/pin_logo_widget.dart';
import 'package:ehac_money/pages/auth/login/widgets/pin_title_widget.dart';
import 'package:ehac_money/services/auth_service.dart';
import 'package:ehac_money/widget/success_dialog_witget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  PinCodeScreenState createState() => PinCodeScreenState();
}

class PinCodeScreenState extends State<PinCodeScreen> with SingleTickerProviderStateMixin {
  String currentPin = '';
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  final authService = AuthService();


  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _addDigit(String digit) {
    if (currentPin.length < 4) {
      setState(() {
        currentPin += digit;
      });

      if (currentPin.length == 4) {
        _checkPin();
      }
    }
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


  Future<void> _checkPin() async {
    String? phoneNumber = await authService.getPhoneNumberUser();
    bool isValid =
    await authService.login(phone: phoneNumber!, password: currentPin);

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
      }

      _resetPin();
    } else {
      _shakeController.forward(from: 0.0);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _resetPin();
      });
    }
  }

  void _resetPin() {
    setState(() {
      currentPin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E88E5), Color(0xFF7E57C2)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeController.value * 10 * math.sin(_shakeController.value * math.pi * 8), 0),
                child: child,
              );
            },
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinLogo(),
                      const SizedBox(height: 40),
                      PinTitle(),
                      const SizedBox(height: 40),
                      PinDots(currentPin: currentPin),
                      const SizedBox(height: 60),
                      NumericKeypad(onDigitPressed: _addDigit),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
