import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'package:scheda_dnd_5e/view/partial/card/button_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/page_header.dart';
import 'package:scheda_dnd_5e/view/partial/profile_picture.dart';
import 'package:scheda_dnd_5e/view/user_page.dart';

import '../../constant/palette.dart';
import '../../manager/data_manager.dart';
import '../partial/clickable.dart';
import '../partial/decoration/rule.dart';

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
            onTap: showChangeUsernamePopup,
          ),
          const SizedBox(height: Measures.vMarginThin),

          // Change password
          ButtonCard(
            title: "Cambia Password",
            description: 'Modifica o reimposta le credenziali di accesso',
            icon: 'password',
            bottomSheetArgs: BottomSheetArgs(
              header: Row(
                children: [
                  'password'.toIcon(),
                  const SizedBox(width: Measures.hMarginBig),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modifica la password di accesso', style: Fonts.bold()),
                      Text('Ricordi la password attuale?', style: Fonts.light()),
                    ],
                  )
                ],
              ),
              items: [
                BottomSheetItem(
                  'png/edit',
                  'Ricordo la password attuale',
                  () => showChangePasswordPopup(),
                ),
                BottomSheetItem(
                  'email',
                  'Non ricordo la password attuale',
                  resetPassword,
                ),
              ],
            ),
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
            onTap: showLogoutPopup,
          ),
          const SizedBox(height: Measures.vMarginBig * 3),
        ],
      ),
    );
  }

  resetPassword() async {
    // Assuming the email is already available in the user object
    final String email = user?.email ?? '';

    if (email.isNotEmpty && email.isEmail) {
      context.popup(
        'Reset della password',
        message: 'Un link per reimpostare la tua password sarà inviato a:\n$email',
        positiveText: 'Invia email',
        negativeText: 'Annulla',
        positiveCallback: () async {
          ResetPasswordStatus status = await AccountManager().resetPassword(email);
          if (status == ResetPasswordStatus.success) {
            context.snackbar(
              'Controlla il tuo indirizzo email per reimpostare la password',
              backgroundColor: Palette.backgroundBlue,
            );
          } else {
            context.snackbar(
              'Errore generico durante l\'invio dell\'email di reset!',
              backgroundColor: Palette.primaryRed,
            );
          }
        },
        backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2),
      );
    } else {
      context.snackbar(
        'Errore: l\'email associata non è valida!',
        backgroundColor: Palette.primaryRed,
      );
    }
  }

  showChangePasswordPopup() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool currentPasswordVisible = false, newPasswordVisible = false, confirmPasswordVisible = false;

    context.popup('Cambia la password',
        message: 'Inserisci prima la tua password attuale poi la nuova password.',
        expanded: true,
        positiveText: 'Conferma',
        negativeText: 'Annulla',
        positiveCallback: () async {
          if (currentPasswordController.text.isEmpty ||
              newPasswordController.text.isEmpty ||
              confirmPasswordController.text.isEmpty) {
            return false;
          }
          if (newPasswordController.text == confirmPasswordController.text) {
            // Check if the password meets all constraints
            if (AccountManager.passwordConstraints
                .any((constraint) => !constraint.item2.hasMatch(newPasswordController.text))) {
              context.snackbar('La password non soddisfa tutti i requisiti',
                  backgroundColor: Palette.primaryRed, bottomMargin: Measures.bottomBarHeight);
            } else {
              final status = await AccountManager().resetPasswordWithConstraints(
                  currentPasswordController.text, newPasswordController.text);
              if (status == ResetPasswordStatus.success) {
                context.snackbar('Password cambiata con successo!',
                    backgroundColor: Palette.backgroundGrey, bottomMargin: Measures.bottomBarHeight);
              } else {
                context.snackbar('Errore durante il cambio della password',
                    backgroundColor: Palette.primaryRed, bottomMargin: Measures.bottomBarHeight);
              }
            }
          } else {
            context.snackbar('Le due password non corrispondono', backgroundColor: Palette.primaryRed);
          }
          return true;
        },
        backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2),
        child: StatefulBuilder(builder: (context, setState) {
          newPasswordController.addListener(() => setState(() {}));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current password text field
              GlassTextField(
                clearable: false,
                iconPath: 'password',
                maxLength: 30,
                textController: currentPasswordController,
                secondaryIconPath: currentPasswordVisible ? 'visibility_on' : 'visibility_off',
                onSecondaryIconTap: () =>
                    setState(() => currentPasswordVisible = !currentPasswordVisible),
                obscureText: !currentPasswordVisible,
                hintText: 'Password attuale',
              ),
              const SizedBox(height: Measures.vMarginSmall),
              Rule(),
              const SizedBox(height: Measures.vMarginSmall),

              // New password
              GlassTextField(
                clearable: false,
                iconPath: 'png/edit',
                maxLength: 30,
                textController: newPasswordController,
                secondaryIconPath: newPasswordVisible ? 'visibility_on' : 'visibility_off',
                onSecondaryIconTap: () => setState(() => newPasswordVisible = !newPasswordVisible),
                obscureText: !newPasswordVisible,
                hintText: 'Nuova password',
              ),

              // Password constraints
              if (newPasswordController.text.isNotEmpty) ...[
                const SizedBox(height: Measures.vMarginThin),
                ...AccountManager.passwordConstraints
                    .where((constraint) => !constraint.item2.hasMatch(newPasswordController.text))
                    .map((constraint) => Text(
                          '• ${constraint.item1}',
                          style: Fonts.regular(color: Palette.primaryRed),
                        ))
              ],

              // Confirm password
              const SizedBox(height: Measures.vMarginSmall),
              GlassTextField(
                clearable: false,
                iconPath: 'png/confirm',
                maxLength: 30,
                textController: confirmPasswordController,
                secondaryIconPath: confirmPasswordVisible ? 'visibility_on' : 'visibility_off',
                onSecondaryIconTap: () =>
                    setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                obscureText: !confirmPasswordVisible,
                hintText: 'Conferma password',
              ),
            ],
          );
        }));
  }

  showChangeUsernamePopup() async {
    final newUsernameController = TextEditingController(text: AccountManager().user.username);

    context.popup(
      'Inserisci il tuo nuovo username',
      message: 'Controlleremo che il nome utente non sia già stato scelto da un altro utente.',
      positiveText: 'Conferma',
      negativeText: 'Annulla',
      expanded: true,
      positiveCallback: () async {
        final newUsername = newUsernameController.text.trim();
        try {
          await DataManager().changeUsername(newUsername);
          setState(() {});
          context.snackbar('Username aggiornato con successo!',
              backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
        } on UsernameAlreadyTakenException {
          context.snackbar('Username non disponibile!',
              backgroundColor: Palette.primaryRed, bottomMargin: Measures.bottomBarHeight);
        } on FormatException catch (e) {
          context.snackbar(e.message,
              backgroundColor: Palette.primaryRed, bottomMargin: Measures.bottomBarHeight);
        }
      },
      backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2),
      child: GlassTextField(
        iconPath: 'person',
        clearable: false,
        textController: newUsernameController,
        hintText: 'Nuovo username',
      ),
    );
  }

  showLogoutPopup() => context.popup(
        'Conferma di logout',
        message: 'Sei sicuro di voler uscire?',
        positiveText: 'Si',
        negativeText: 'No',
        positiveCallback: () async {
          context.snackbar(
            'Alla prossima, ${AccountManager().user.username}!',
            backgroundColor: Palette.backgroundBlue,
          );
          await AccountManager().signOut();
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          return false;
        },
        backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2),
      );
}
