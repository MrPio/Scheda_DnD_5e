import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'package:scheda_dnd_5e/view/partial/card/button_card.dart';
import 'package:scheda_dnd_5e/view/partial/page_header.dart';
import 'package:scheda_dnd_5e/view/partial/profile_picture.dart';
import 'package:scheda_dnd_5e/view/user_page.dart';

import '../../constant/palette.dart';

class UserScreen extends StatefulWidget {
  final UserArgs? args;

  const UserScreen({this.args, super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserArgs? get args => widget.args;
  final double avatarRadius = 999;
  User? user;

  List<String> unmetRequirements = [];
  bool passwordsMatch = true;
  bool bothPasswordsEntered = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = args?.user ?? AccountManager().user;
  }

  // Function to check password complexity
  void checkPasswordComplexity(String password) {
    final rules = {
      r'(?=.*[A-Z])': 'Almeno una lettera maiuscola',
      r'(?=.*[a-z])': 'Almeno una lettera minuscola',
      r'(?=.*\d)': 'Almeno un numero',
      r'(?=.*[@$!%*?&])': 'Almeno un simbolo speciale (@\$!%*?)',
      r'.{8,}': 'Almeno 8 caratteri',
    };

    setState(() {
      unmetRequirements = rules.entries
          .where((entry) => !RegExp(entry.key).hasMatch(password))
          .map((entry) => entry.value)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
      child: Column(
        children: [
          PageHeader(title: args?.title ?? 'Gestisci il tuo profilo', isPage: args != null),
          Column(
            children: [
              ProfilePicture(user: user),
              const SizedBox(height: Measures.vMarginThin),
              Text(
                user!.username,
                style: Fonts.black(size: 20),
              ),
              Text(
                user!.email,
                style: Fonts.light(size: 16),
              ),
            ],
          ),
          const SizedBox(height: Measures.vMarginMed + Measures.vMarginSmall),
          ButtonCard(
            title: "Lista Amici",
            icon: 'group',
            description: "Gestisci la tua community, consulta il profilo dei tuoi amici",
            onTap: () {
              Navigator.pushNamed(context, '/friends');
            },
          ),
          const SizedBox(height: Measures.vMarginThin),
          ButtonCard(
            title: "Cambia Password",
            description: 'Modifica le credenziali di accesso al tuo account',
            icon: 'password',
            onTap: () {
              _showChangePasswordPopup(context);
            },
          ),
          const SizedBox(height: Measures.vMarginThin),
          ButtonCard(
            title: "Cambia username",
            description: 'Modifica il tuo nome visibile pubblicamente',
            icon: 'person',
            onTap: () {
              _showChangeUsernamePopup(context);
            },
          ),
          const SizedBox(height: Measures.vMarginThin),
          ButtonCard(
            title: "Impostazioni",
            icon: 'png/settings',
            description: "Personalizza il comportamento dell'applicazione",
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const SizedBox(height: Measures.vMarginBig * 3),
        ],
      ),
    );
  }

  // Popup for changing password
  void _showChangePasswordPopup(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    List<String> unmetRequirements = [];
    bool passwordsMatch = true;
    bool bothPasswordsEntered = false;

    // Function to check the password complexity dynamically
    void checkPasswordComplexity(String password) {
      final rules = {
        r'(?=.*[A-Z])': 'Almeno una lettera maiuscola',
        r'(?=.*[a-z])': 'Almeno una lettera minuscola',
        r'(?=.*\d)': 'Almeno un numero',
        r'(?=.*[@$!%*?&])': 'Almeno un simbolo speciale (@\$!%*?)',
        r'.{8,}': 'Almeno 8 caratteri',
      };

      unmetRequirements = rules.entries
          .where((entry) => !RegExp(entry.key).hasMatch(password))
          .map((entry) => entry.value)
          .toList();
    }

    context.popup(
      'Cambia Password',
      positiveText: 'Conferma',
      negativeText: 'Annulla',
      positiveCallback: () async {
        // Only proceed if both passwords are entered and meet complexity requirements
        if (newPasswordController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty) {
          if (newPasswordController.text == confirmPasswordController.text) {
            if (unmetRequirements.isEmpty) {
              // Password changed successfully
              bool success = true; // TODO, Placeholder for actual db logic
              if (success) {
                context.snackbar('Password cambiata con successo!',
                    backgroundColor: Palette.backgroundBlue);
              } else {
                context.snackbar('Errore durante il cambio della password',
                    backgroundColor: Palette.primaryRed);
              }
            } else {
              context.snackbar('La password non soddisfa i requisiti di complessità',
                  backgroundColor: Palette.primaryRed);
            }
          } else {
            context.snackbar('Le due password non corrispondono', backgroundColor: Palette.primaryRed);
          }
        } else {
          context.snackbar('Non lasciare campi vuoti', backgroundColor: Palette.primaryRed);
        }
      },
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Column(
            children: [
              // New Password Field
              TextField(
                controller: newPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nuova Password',
                ),
                onChanged: (value) {
                  setState(() {
                    checkPasswordComplexity(value); // Dynamically check complexity
                    passwordsMatch = value == confirmPasswordController.text;
                    bothPasswordsEntered = value.isNotEmpty && confirmPasswordController.text.isNotEmpty;
                  });
                },
              ),
              const SizedBox(height: Measures.vMarginSmall),

              // Confirm Password Field
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Conferma Password',
                ),
                onChanged: (value) {
                  setState(() {
                    passwordsMatch = value == newPasswordController.text;
                    bothPasswordsEntered = newPasswordController.text.isNotEmpty && value.isNotEmpty;
                  });
                },
              ),
              const SizedBox(height: Measures.vMarginSmall),

              // Complexity Feedback (Updated dynamically)
              if (unmetRequirements.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: unmetRequirements.map((requirement) {
                    return Text(
                      '• $requirement',
                      style: Fonts.light(color: Colors.red),
                    );
                  }).toList(),
                ),

              // Password Match Feedback
              if (!passwordsMatch && bothPasswordsEntered)
                Text(
                  'Le due password non corrispondono',
                  style: Fonts.light(color: Colors.red),
                ),
            ],
          );
        },
      ),
    );
  }


  // Popup for changing username
  void _showChangeUsernamePopup(BuildContext context) {
    final usernameController = TextEditingController();
    bool isUsernameUnique = true; // TODO, Default to true, will check uniqueness later
    String usernameFeedback = '';

    Future<void> checkUsernameUniqueness(String username) async {
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        if (username == "existingUsername") {
          isUsernameUnique = false;
          usernameFeedback = 'Username già in uso';
        } else {
          isUsernameUnique = true;
          usernameFeedback = '';
        }
      });
    }

    context.popup(
      'Cambia Username',
      positiveText: 'Conferma',
      negativeText: 'Annulla',
      positiveCallback: () async {
        if (isUsernameUnique && usernameController.text.isNotEmpty) {
          bool success = true; // TODO, Placeholder for actual logic
          if (success) {
            context.snackbar('Username cambiato con successo!',
                backgroundColor: Palette.backgroundBlue);
          } else {
            context.snackbar('Errore durante il cambio dello username',
                backgroundColor: Palette.primaryRed);
          }
        } else {
          context.snackbar('Username non valido o già in uso',
              backgroundColor: Palette.primaryRed);
        }
      },
      child: Column(
        children: [
          // Username Field
          TextField(
            controller: usernameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Nuovo Username',
            ),
            onChanged: (value) {
              checkUsernameUniqueness(value);
            },
          ),
          const SizedBox(height: Measures.vMarginSmall),

          // Username Feedback
          if (!isUsernameUnique)
            Text(
              usernameFeedback,
              style: Fonts.light(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
