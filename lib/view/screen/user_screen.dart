import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'package:scheda_dnd_5e/view/partial/card/button_card.dart';
import 'package:scheda_dnd_5e/view/partial/page_header.dart';
import 'package:scheda_dnd_5e/view/partial/profile_picture.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/user_page.dart';

import '../../constant/palette.dart';
import '../../manager/data_manager.dart';

class UserScreen extends StatefulWidget {
  final UserArgs? args;

  const UserScreen({this.args, super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserArgs? get args => widget.args;
  final double avatarRadius = 999;

  /// The user whose profile will be shown.
  /// If no user is given in args, the current user is used
  User? user;

  @override
  void initState() {
    user = args?.user ?? AccountManager().user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
      child: Column(
        children: [
          // Page Title
          PageHeader(title: args?.title ?? 'Gestisci il tuo profilo', isPage: args != null),
          const SizedBox(height: Measures.vMarginThin),

          // Profile picture
          Column(
            children: [
              ProfilePicture(user: user, isEditable: true),
              const SizedBox(height: Measures.vMarginThin),

              // Username text
              Text(
                user!.username,
                style: Fonts.black(size: 20),
              ),

              // Email text
              Text(
                user!.email,
                style: Fonts.light(size: 16),
              ),
            ],
          ),
          const SizedBox(height: Measures.vMarginMed),

          // Friends list
          ButtonCard(
            title: "Lista Amici",
            icon: 'group',
            description: "Gestisci la tua community, consulta il profilo dei tuoi amici",
            onTap: () {
              Navigator.pushNamed(context, '/friends');
            },
          ),
          const SizedBox(height: Measures.vMarginThin),

          // Change username
          ButtonCard(
            title: "Cambia Username",
            description: 'Modifica il tuo nome visibile pubblicamente',
            icon: 'person',
            onTap: () {
              showChangeNicknamePopup();
            },
          ),
          const SizedBox(height: Measures.vMarginThin),

          // Change password
          ButtonCard(
            title: "Cambia Password",
            description: 'Modifica le credenziali di accesso al tuo account',
            icon: 'password',
            onTap: () {
              showChangePasswordPopup();
            },
          ),
          const SizedBox(height: Measures.vMarginThin),

          // Settings
          ButtonCard(
            title: "Impostazioni",
            icon: 'png/settings',
            description: "Personalizza il comportamento dell'applicazione",
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const SizedBox(height: Measures.vMarginThin),

          // Logout
          ButtonCard(
            title: "Esci",
            icon: 'logout',
            onTap: () {
              // TODO
              //AccountManager().logout();
              //Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
            },
          ),
          const SizedBox(height: Measures.vMarginBig * 3),
        ],
      ),
    );
  }

  showChangePasswordPopup() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    context.popup(
      'Cambia Password',
      positiveText: 'Conferma',
      negativeText: 'Annulla',
      positiveCallback: () {
        // Check if the passwords match
        if (newPasswordController.text == confirmPasswordController.text) {
          // Check if the password meets all constraints
          if (isPasswordValid(newPasswordController.text)) {
            final status = AccountManager().resetPasswordWithConstraints(
                currentPasswordController.text, newPasswordController.text);
            if (status == ResetPasswordStatus.success) {
              context.snackbar('Password cambiata con successo!', backgroundColor: Palette.backgroundBlue);
            } else {
              context.snackbar('Errore durante il cambio della password', backgroundColor: Palette.primaryRed);
            }
          } else {
            context.snackbar('La password non soddisfa i requisiti', backgroundColor: Palette.primaryRed);
          }
        } else {
          context.snackbar('Le due password non corrispondono', backgroundColor: Palette.primaryRed);
        }
      },
      child: PasswordChangeForm(
        currentPasswordController: currentPasswordController,
        newPasswordController: newPasswordController,
        confirmPasswordController: confirmPasswordController,
      ),
    );
  }

  // Check if password meets all the constraints
  bool isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[!@#$&*~]').hasMatch(password);
  }

  showChangeNicknamePopup() async {
    final newNicknameController = TextEditingController();

    context.popup(
      'Cambia Username',
      positiveText: 'Conferma',
      negativeText: 'Annulla',
      positiveCallback: () async {
        final newNickname = newNicknameController.text.trim();
        if (newNickname.isEmpty) {
          context.snackbar('Inserisci un nuovo username', backgroundColor: Palette.primaryRed);
          return;
        }

        try {
          await DataManager().checkNickname(newNickname);
          // Update user object with new nickname (optional)
          user!.username = newNickname;
          // Update UI with the new nickname
          setState(() {});
          context.snackbar('Username aggiornato con successo!', backgroundColor: Palette.backgroundBlue);
        } catch (e) {
          context.snackbar('Username non disponibile!', backgroundColor: Palette.primaryRed);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassTextField(
            textController: newNicknameController,
            hintText: 'Nuovo Username',
          )
        ],
      ),
    );
  }
}

class PasswordChangeForm extends StatefulWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const PasswordChangeForm({
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    super.key,
  });

  @override
  PasswordChangeFormState createState() => PasswordChangeFormState();
}

class PasswordChangeFormState extends State<PasswordChangeForm> {
  final Map<String, bool> passwordConstraints = {
    'Tra 8 e 30 caratteri': false,
    'Una lettera maiuscola': false,
    'Una lettera minuscola': false,
    'Un numero': false,
    'Un carattere speciale (@\$!%*?&)': false,
  };

  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    currentPasswordController = widget.currentPasswordController;
    newPasswordController = widget.newPasswordController;
    confirmPasswordController = widget.confirmPasswordController;

    // Add listener for text changes in the new password field
    newPasswordController.addListener(updateConstraints);
  }

  @override
  void dispose() {
    // Remove listener when the widget is disposed
    newPasswordController.removeListener(updateConstraints);
    super.dispose();
  }

  updateConstraints() {
    final password = newPasswordController.text;
    setState(() {
      passwordConstraints['Tra 8 e 30 caratteri'] = password.length >= 8 && password.length <= 30;
      passwordConstraints['Una lettera maiuscola'] = RegExp(r'[A-Z]').hasMatch(password);
      passwordConstraints['Una lettera minuscola'] = RegExp(r'[a-z]').hasMatch(password);
      passwordConstraints['Un numero'] = RegExp(r'\d').hasMatch(password);
      passwordConstraints['Un carattere speciale (@\$!%*?&)'] = RegExp(r'[!@#\\$&*~]').hasMatch(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current password text field
        GlassTextField(
          textController: currentPasswordController,
          obscureText: true,
          hintText: 'Password Attuale',
        ),
        const SizedBox(height: Measures.vMarginSmall),

        // New password text field
        GlassTextField(
          textController: newPasswordController,
          obscureText: true,
          hintText: 'Nuova Password',
        ),
        const SizedBox(height: Measures.vMarginSmall),

        // Confirm password text field
        GlassTextField(
          textController: confirmPasswordController,
          obscureText: true,
          hintText: 'Conferma Password',
        ),
        const SizedBox(height: Measures.vMarginSmall),

        // Display password constraints with color change based on match
        ...passwordConstraints.entries.map((entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            entry.key,
            style: Fonts.regular(
              color: entry.value ? Palette.primaryGreen : Palette.primaryRed, // Color based on constraint match
            ),
          ),
        )),
      ],
    );
  }
}
