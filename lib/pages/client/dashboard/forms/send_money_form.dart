import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({super.key});

  @override
  SendMoneyFormState createState() => SendMoneyFormState();
}

class SendMoneyFormState extends State<SendMoneyForm> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();
  final logger = Logger();
  String? beneficiaryName;
  String? phoneNumber;
  bool isPhoneNumberValid = false;
  String errorMessage = '';

  // Function to validate the phone number
  bool _isSenegalPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^(?:\+221)?(77|76|70|75|78)[0-9]{7}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Function to validate phone number and check if it exists in the database
  Future<void> _validateForm() async {
    if (!_isSenegalPhoneNumber(phoneNumber!)) {
      setState(() {
        isPhoneNumberValid = false;
        errorMessage = "Numéro invalide. Veuillez entrer un numéro sénégalais.";
      });
      return;
    }

    // Check if the phone number exists in the database
    final User? exists = await userService.findByPhone(phone: phoneNumber!);
    if (exists == null) {
      setState(() {
        isPhoneNumberValid = false;
        errorMessage = "Ce numéro de téléphone n'est pas enregistré.";
      });
    } else {
      setState(() {
        isPhoneNumberValid = true;
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    const Text(
                      'Envoyer de L\'argent à',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Remplissez les informations du destinataire',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nom du bénéficiaire',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Entrez le nom du bénéficiaire',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) =>
                          setState(() => beneficiaryName = value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Numéro de téléphone',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'XX XXX XX XX',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        prefixText: '+221 ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                          errorMessage = '';
                        });
                      },
                    ),
                    if (errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (phoneNumber?.isNotEmpty == true &&
                                beneficiaryName?.isNotEmpty == true) {
                              await _validateForm();
                              if (isPhoneNumberValid) {
                                // Proceed to the next step
                                // Example: Navigator.of(context).push(...);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isPhoneNumberValid ? Colors.blue : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Suivant',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
