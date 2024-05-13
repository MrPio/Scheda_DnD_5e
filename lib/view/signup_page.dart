import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';

import 'partial/glass_button.dart';
import 'partial/glass_text_field.dart';
import 'partial/gradient_background.dart';
import 'partial/loading_view.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with Loadable {
  late final TextEditingController _usernameController,
      _emailController,
      _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController(text: 'valeriomorelli50@gmail.com')
      ..addListener(() {
        setState(() {});
      });
    _passwordController = TextEditingController(text: 'aaaaaa');
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
              padding:
                  const EdgeInsets.symmetric(horizontal: Measures.hPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  SizedBox(
                      width: double.infinity,
                      child: Text('Benvenuto!', style: Fonts.black())),
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
                      textController: _usernameController,
                      clearable: true,
                      keyboardType: TextInputType.name),
                  const SizedBox(height: Measures.vMarginSmall),
                  // Email TextField
                  GlassTextField(
                      iconPath: 'email',
                      hintText: 'Inserisci la tua email',
                      textController: _emailController,
                      clearable: true,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: Measures.vMarginSmall),
                  // Password TextField
                  GlassTextField(
                    iconPath: 'password',
                    secondaryIconPath:
                        _passwordVisible ? 'visibility_on' : 'visibility_off',
                    obscureText: !_passwordVisible,
                    hintText: 'Inserisci la tua password',
                    textController: _passwordController,
                    clearable: false,
                    onSecondaryIconTap: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
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
                          onTap: () =>
                              Navigator.of(context).pushNamed('/signin'),
                          child: Text('Accedi al tuo account',
                              style: Fonts.regular(
                                  size: 14, color: Palette.primaryBlue))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // LoadingView
          LoadingView(visible: isLoading)
        ],
      ),
    );
  }

  signUp() => withLoading(() async{
        if (!await IOManager().hasInternetConnection(context)) {
          return;
        }
        if (!_usernameController.text.isUsername) {
          context.snackbar('Per favore inserisci un nome utente valido',
              backgroundColor: Palette.backgroundGreen);
        } else if (!_emailController.text.isEmail) {
          context.snackbar('Per favore inserisci una email valida',
              backgroundColor: Palette.backgroundGreen);
        } else {
          SignUpStatus status = await AccountManager().signUp(
              _emailController.text,
              _passwordController.text,
              User(
                  nickname: _usernameController.text,
                  email: _emailController.text));
          if (status == SignUpStatus.weakPassword) {
            context.snackbar('La password è troppo corta!',
                backgroundColor: Palette.primaryRed);
          } else if (status == SignUpStatus.emailInUse) {
            context.snackbar('L\'email è già in uso!',
                backgroundColor: Palette.primaryRed);
          } else if (status == SignUpStatus.genericError) {
            context.snackbar('Errore generico!',
                backgroundColor: Palette.primaryRed);
          } else if (status == SignUpStatus.success) {
            context.snackbar('Benvenuto ${AccountManager().user.nickname}!',
                backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
            Navigator.of(context).popAndPushNamed('/home');
          }
        }
      });

  signInWithGoogle() => withLoading(() async {
        if (!await IOManager().hasInternetConnection(context)) {
          return;
        }
        SignInStatus status = await AccountManager().signInWithGoogle();
        if (status == SignInStatus.googleProviderError) {
          context.snackbar('Errore nell\'accesso a Google',
              backgroundColor: Palette.primaryRed);
        } else if (status == SignInStatus.userNotInDatabase) {
          context.snackbar('L\'account non è più esistente!',
              backgroundColor: Palette.primaryRed);
        } else if (status == SignInStatus.success) {
          context.snackbar('Bentornato ${AccountManager().user.nickname}!',
              backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
          Navigator.of(context).popAndPushNamed('/home');
        } else if (status == SignInStatus.successNewAccount) {
          context.snackbar('Benvenuto ${AccountManager().user.nickname}!',
              backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
          Navigator.of(context).popAndPushNamed('/home');
        }
      });
}
