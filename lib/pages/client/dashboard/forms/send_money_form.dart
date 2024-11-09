import 'package:ehac_money/models/user.dart';
import 'package:ehac_money/pages/client/dashboard/send_money_form_page.dart';
import 'package:ehac_money/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SendMoneyForm extends StatefulWidget {
  final User? user;
  const SendMoneyForm({super.key, this.user});

  @override
  SendMoneyFormState createState() => SendMoneyFormState();
}

class SendMoneyFormState extends State<SendMoneyForm> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();
  final logger = Logger();
  late UserInfo? userSend;
  String? beneficiaryName;
  String? phoneNumberError;
  String? phoneNumber;
  bool isPhoneNumberValid = false;
  bool isLoading = false;

  bool _isSenegalPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^(\+221)?(7[0678]\d{7})$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  void validatePhoneNumber(String value) async {
    setState(() {
      phoneNumber = value;
      phoneNumberError = _isSenegalPhoneNumber(value) ? null : "Entrez un numéro sénégalais valide (ex. 77XX...)";
    });

    if (_isSenegalPhoneNumber(value)) {
      setState(() => isLoading = true);
      userSend = await userService.findByPhone(phone: phoneNumber!);
      setState(() {
        isLoading = false;
        isPhoneNumberValid = userSend != null;
        phoneNumberError = userSend == null ?"Ce numéro n'a pas de comptes Sama Calpé":null;
        if(phoneNumber == widget.user?.phoneNumber){
          isPhoneNumberValid = false;
          phoneNumberError = "Vous avez saisie votre numéro de compte";
        }else{
          beneficiaryName = userSend == null? beneficiaryName : userSend!.name;
        }
      });
    } else {
      setState(() {
        isLoading = false;
        isPhoneNumberValid = false;
      });
    }
  }

  Widget _buildPhoneValidationStatus() {
    if (isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]!),
        ),
      );
    } else if (isPhoneNumberValid) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 20,
      );
    } else if (phoneNumber?.isNotEmpty == true) {
      return Icon(
        Icons.error,
        color: Colors.red[300],
        size: 20,
      );
    }
    return const SizedBox(width: 20);
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
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                      onChanged: (value) => setState(() => beneficiaryName = value),
                    )
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
                        suffixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildPhoneValidationStatus(),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        errorText: phoneNumberError,
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: validatePhoneNumber,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                                beneficiaryName?.isNotEmpty == true && isPhoneNumberValid) {
                              if (userSend != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SendMoneyFormPage(userInfo: userSend!),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPhoneNumberValid && beneficiaryName?.isNotEmpty == true
                              ? Colors.blue
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: isPhoneNumberValid && beneficiaryName?.isNotEmpty == true ? 2 : 0,
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