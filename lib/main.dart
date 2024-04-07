import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/manager/dummy_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'package:scheda_dnd_5e/view/dice_page.dart';
import 'package:scheda_dnd_5e/view/enchantment_page.dart';
import 'package:scheda_dnd_5e/view/enchantments_page.dart';
import 'package:scheda_dnd_5e/view/signin_page.dart';
import 'package:scheda_dnd_5e/view/signup_page.dart';

import 'firebase_options.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    Future.delayed(Duration.zero, () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await IOManager().init();
      // ⚠️⚠️⚠️ DANGER ZONE ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

      // 👤👤👤 FIREBASE AUTH 👤👤👤
      const uid = 'VeaLO6032Qb5VgWj5ajnpvWqjDT2';
      const email = 'valeriomorelli50@gmail.com';
      const password = 'aaaaaa';
      // await IOManager().set(IOManager.accountUID, uid);
      // await AccountManager().cacheSignIn();
      await AccountManager().signIn(email, password);

      // 📘📘📘 FIREBASE FIRESTORE 📘📘📘
      // await DummyManager().populateEnchantments();
      // await IOManager().remove('enchantments_timestamp');
      // ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

      // TODO: loading screen here!!!
      await DataManager().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scheda DnD 5e',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, primary: Colors.white),
        useMaterial3: true,
      ),
      routes: <String, WidgetBuilder>{
        '/': (context) => const SignInPage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/dice': (context) => const DicePage(),
        '/enchantments': (context) => const EnchantmentsPage(),
        '/enchantment': (context) => const EnchantmentPage(),
      },
    );
  }
}
