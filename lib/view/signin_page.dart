import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/firebase_options.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/view/create_item_page.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_checkbox.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/loading_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constant/palette.dart';
import '../database/database_seeder.dart';
import '../model/character.dart';
import '../model/enchantment.dart' hide Duration;
import '../model/loot.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with Loadable {
  static bool _isInitialized = false;
  late final TextEditingController _emailController, _passwordController;
  bool _passwordVisible = false, _rememberMe = true;

  @override
  void initState() {
    if (!_isInitialized) {
      _isInitialized = true;
      Future.delayed(Duration.zero, () async {
        withLoading(() async {
          await dotenv.load(fileName: ".env");
          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          await Supabase.initialize(
            url: 'https://olkuecwwoctlcamzvylf.supabase.co',
            anonKey: dotenv.env['SUPABASE_KEY']!,
          );
          await IOManager().init();
          if (!await IOManager().hasInternetConnection(context)) {
            return;
          }

          // 📘📘📘 FIREBASE FIRESTORE 📘📘📘
          // ⚠️⚠️⚠️ DANGER ZONE ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
          // await seedDatabase(fresh: true);
          // await DataManager().invalidateCache<Enchantment>();
          // await DataManager().invalidateCache<Weapon>();
          // await DataManager().invalidateCache<Armor>();
          // await DataManager().invalidateCache<Item>();
          // await DataManager().invalidateCache<Coin>();
          // await DataManager().invalidateCache<Equipment>();
          // await DataManager().invalidateCache<Character>();
          // ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

          // 👤👤👤 FIREBASE AUTH 👤👤👤
          if (await AccountManager().cacheSignIn()) {
            setState(() => isLoading = true);
            await gotoHome();
            await DataManager().fetchUserItems();
          }
        });
      });
    }

    _emailController = TextEditingController(text: 'valeriomorelli50@gmail.com'); // TODO here
    _passwordController = TextEditingController(text: 'aA1!4444');
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundBlue),
          // Header + Body
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  SizedBox(width: double.infinity, child: Text('Bentornato!', style: Fonts.black())),
                  const SizedBox(
                    height: Measures.vMarginThin,
                  ),
                  // Subtitle
                  Text('Per favore accedi al tuo account per poter utilizzare l’app.',
                      style: Fonts.light()),
                  const SizedBox(
                    height: Measures.vMarginMed,
                  ),
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
                    secondaryIconPath: _passwordVisible ? 'visibility_on' : 'visibility_off',
                    obscureText: !_passwordVisible,
                    hintText: 'Inserisci la tua password',
                    textController: _passwordController,
                    clearable: false,
                    onSecondaryIconTap: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
                  const SizedBox(height: Measures.vMarginThin),
                  // Remember me & forgot password
                  Row(
                    children: [
                      GlassCheckbox(
                        value: _rememberMe,
                        onChanged: () => setState(() => _rememberMe = !_rememberMe),
                        color: Palette.primaryBlue,
                      ),
                      Text('Ricordami', style: Fonts.light()),
                      Expanded(child: Container()),
                      GestureDetector(
                          onTap: forgotPassword,
                          child: Text('Password dimenticata',
                              style: Fonts.regular(size: 14, color: Palette.primaryBlue))),
                    ],
                  ),
                  const SizedBox(height: Measures.vMarginSmall),
                  // SignIn button
                  GlassButton(
                    'ACCEDI',
                    color: Palette.primaryBlue,
                    onTap: signIn,
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
                    'Continua con Google',
                    color: Palette.primaryBlue,
                    outlined: true,
                    iconPath: 'google',
                    onTap: signInWithGoogle,
                  ),
                  const SizedBox(height: Measures.vMarginMed),
                  // Signup line
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Non hai un account?', style: Fonts.light()),
                      const SizedBox(width: 6),
                      GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/signup'),
                          child: Text('Crea un account',
                              style: Fonts.regular(size: 14, color: Palette.primaryBlue))),
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

  signIn() => withLoading(() async {
        if (!await IOManager().hasInternetConnection(context)) {
          return;
        }
        if (!_emailController.text.isEmail) {
          context.snackbar('Per favore inserisci una email valida',
              backgroundColor: Palette.backgroundBlue);
        } else {
          SignInStatus status =
              await AccountManager().signIn(_emailController.text, _passwordController.text);
          if (status == SignInStatus.wrongCredentials) {
            context.snackbar('Le credenziali sono errate!', backgroundColor: Palette.primaryRed);
          } else if (status == SignInStatus.userNotInDatabase) {
            context.snackbar('L\'account non è più esistente!', backgroundColor: Palette.primaryRed);
          } else if (status == SignInStatus.success) {
            context.snackbar('Bentornato ${AccountManager().user.username}!',
                backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight);
            gotoHome();
          }
        }
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
          gotoHome();
        } else if (status == SignInStatus.successNewAccount) {
          context.snackbar('Benvenuto ${AccountManager().user.username}!',
              backgroundColor: Palette.backgroundGreen, bottomMargin: Measures.bottomBarHeight);
          gotoHome();
        }
      });

  forgotPassword() async {
    final emailController = TextEditingController();
    context.popup(
      'Reset della password',
      message: 'Inserisci l\'email dell\'account del quale vuoi reimpostare la password:',
      positiveText: 'Invia email',
      positiveCallback: () async {
        if (emailController.text.isEmail) {
          ResetPasswordStatus status = await AccountManager().resetPassword(emailController.text);
          if (status == ResetPasswordStatus.success) {
            context.snackbar('Controlla il tuo indirizzo per reimpostare la password',
                backgroundColor: Palette.backgroundBlue);
          } else {
            context.snackbar('Errore generico!', backgroundColor: Palette.primaryRed);
          }
        } else {
          context.snackbar('L\'email inserita non è valida', backgroundColor: Palette.primaryRed);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: Measures.vMarginMed),
        child: GlassTextField(
          iconPath: 'email',
          hintText: 'Inserisci la tua email',
          textController: emailController,
          clearable: false,
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }

  gotoHome() async{
    await DataManager().fetchData();
    context.goto('/home', pop: true);
  }
}
