import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/mixin/validable.dart';
import 'package:scheda_dnd_5e/model/user.dart';

import '../manager/data_manager.dart';
import 'partial/decoration/gradient_background.dart';
import 'partial/decoration/loading_view.dart';
import 'partial/glass_button.dart';
import 'partial/glass_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with Loadable, Validable {
  late final TextEditingController usernameController, emailController, passwordController;
  bool passwordVisible = false;

  @override
  void initState() {
    usernameController = TextEditingController(text: 'pippoPad');
    emailController = TextEditingController(text: 'valeriomorelli500@gmail.com')
      ..addListener(() {
        setState(() {});
      });
    passwordController = TextEditingController(text: 'aaaaa@A3a');
    passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundGreen),
          // Header + Body
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    SizedBox(width: double.infinity, child: Text('Benvenuto!', style: Fonts.black())),
                    const SizedBox(
                      height: Measures.vMarginThin,
                    ),

                    // Subtitle
                    Text(
                        'Crea un account per creare i tuoi personaggi, partecipare a campagne e molto altro!',
                        style: Fonts.light()),
                    const SizedBox(
                      height: Measures.vMarginMed,
                    ),

                    // Username TextField
                    GlassTextField(
                        iconPath: 'person',
                        hintText: 'Inserisci il tuo username',
                        textController: usernameController,
                        clearable: true,
                        keyboardType: TextInputType.name),
                    const SizedBox(height: Measures.vMarginSmall),

                    // Email TextField
                    GlassTextField(
                        iconPath: 'email',
                        hintText: 'Inserisci la tua email',
                        textController: emailController,
                        clearable: true,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: Measures.vMarginSmall),

                    // Password TextField
                    GlassTextField(
                      iconPath: 'password',
                      secondaryIconPath: passwordVisible ? 'visibility_on' : 'visibility_off',
                      obscureText: !passwordVisible,
                      hintText: 'Inserisci la tua password',
                      maxLength: 30,
                      textController: passwordController,
                      clearable: false,
                      onSecondaryIconTap: () {
                        setState(() => passwordVisible = !passwordVisible);
                      },
                    ),

                    // Password constraints
                    if (passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: Measures.vMarginThin),
                      ...AccountManager.passwordConstraints
                          .where((constraint) => !constraint.item2.hasMatch(passwordController.text))
                          .map((constraint) => Text(
                                '• ${constraint.item1}',
                                style: Fonts.regular(color: Palette.primaryRed),
                              ))
                    ],

                    const SizedBox(height: Measures.vMarginMed),

                    // SignIn button
                    GlassButton(
                      'REGISTRATI',
                      color: Palette.primaryGreen,
                      onTap: signUp,
                    ),
                    const SizedBox(height: Measures.vMarginSmall),

                    // Or line
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Palette.card2,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: Measures.hMarginMed),
                        Text('Oppure', style: Fonts.light()),
                        const SizedBox(width: Measures.hMarginMed),
                        Expanded(
                          child: Container(
                            color: Palette.card2,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Measures.vMarginSmall),

                    // Google button
                    GlassButton(
                      'Registrati con Google',
                      color: Palette.primaryGreen,
                      outlined: true,
                      iconPath: 'google',
                      onTap: signInWithGoogle,
                    ),
                    const SizedBox(height: Measures.vMarginMed),

                    // SignIn line
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Hai già un account?', style: Fonts.light()),
                        const SizedBox(width: 6),
                        GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/signin'),
                            child: Text('Accedi al tuo account',
                                style: Fonts.regular(size: 14, color: Palette.primaryBlue))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // LoadingView
          LoadingView(visible: isLoading)
        ],
      ),
    );
  }

  signUp() => withLoading(() async {
        if (!await IOManager().hasInternetConnection(context)) {
          return;
        }
        await validateAsync(() async {
          final user = User(username: usernameController.text, email: emailController.text);
          SignUpStatus status =
              await AccountManager().signUp(emailController.text, passwordController.text, user);
          if (status.errorMessage != null) {
            context.snackbar(status.errorMessage!, backgroundColor: Palette.primaryRed);
          }
          if (status == SignUpStatus.success) {
            context.snackbar('Benvenuto ${AccountManager().user.username}!',
                backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
            await DataManager().fetchData();
            await DataManager().fetchUserItems();
            context.goto('/home', pop: true);
          }
        });
      });

  signInWithGoogle() => withLoading(() async {
        if (!await IOManager().hasInternetConnection(context)) {
          return;
        }
        SignInStatus status = await AccountManager().signInWithGoogle();
        if (status == SignInStatus.googleProviderError) {
          context.snackbar('Errore nell\'accesso a Google', backgroundColor: Palette.primaryRed);
        } else if (status == SignInStatus.userNotInDatabase) {
          context.snackbar('L\'account non è più esistente!', backgroundColor: Palette.primaryRed);
        } else if (status == SignInStatus.success) {
          context.snackbar('Bentornato ${AccountManager().user.username}!',
              backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
          Navigator.of(context).popAndPushNamed('/home');
        } else if (status == SignInStatus.successNewAccount) {
          context.snackbar('Benvenuto ${AccountManager().user.username}!',
              backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
          Navigator.of(context).popAndPushNamed('/home');
        }
      });
}
