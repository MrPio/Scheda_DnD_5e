import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheda_dnd_5e/view/character_page.dart';
import 'package:scheda_dnd_5e/view/create_character_page.dart';
import 'package:scheda_dnd_5e/view/dice_page.dart';
import 'package:scheda_dnd_5e/view/enchantment_page.dart';
import 'package:scheda_dnd_5e/view/enchantments_page.dart';
import 'package:scheda_dnd_5e/view/home_page.dart';
import 'package:scheda_dnd_5e/view/signin_page.dart';
import 'package:scheda_dnd_5e/view/signup_page.dart';
import 'package:tuple/tuple.dart';

import 'constant/palette.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Palette.background));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scheda DnD 5e',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, primary: Colors.white),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final Map<String, Tuple2<Offset, Widget>> transitions = {
          '/signup': const Tuple2(Offset(1.0, 0.0), SignUpPage()),
          '/signin': const Tuple2(Offset(-1.0, 0.0), SignInPage()),
        };
        if (transitions.containsKey(settings.name)) {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                transitions[settings.name]!.item2,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var tween = Tween(
                      begin: transitions[settings.name]!.item1,
                      end: Offset.zero)
                  .chain(CurveTween(curve: Curves.ease));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        }
        return null;
      },
      routes: <String, WidgetBuilder>{
        '/': (context) => const SignInPage(),
        // '/signin': (context) => const SignInPage(),
        // '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/dice': (context) => const DicePage(),
        '/enchantments': (context) => const EnchantmentsPage(),
        '/enchantment': (context) => const EnchantmentPage(),
        '/create_character':(context) => const CreateCharacterPage(),
        '/character':(context) => const CharacterPage(),
      },
    );
  }
}
