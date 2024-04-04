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

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await IOManager().init();
  // ⚠️⚠️⚠️ DANGER ZONE ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

  // 👤👤👤 FIREBASE AUTH 👤👤👤
  final uid = 'VeaLO6032Qb5VgWj5ajnpvWqjDT2';
  final email = 'valeriomorelli50@gmail.com';
  final password = 'aaaaaa';
  // await IOManager().set(IOManager.accountUID, uid);
  // await AccountManager().cacheSignIn();
  await AccountManager().signIn(email, password);

  // 📘📘📘 FIREBASE FIRESTORE 📘📘📘
  // await DummyManager().populateEnchantments();
  // await IOManager().remove('enchantments_timestamp');
  // ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

  // TODO: loading screen here!!!
  await DataManager().fetchData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/': (context) => const EnchantmentsPage(),
        '/dice': (context) => const DicePage(),
        '/enchantments': (context) => const EnchantmentsPage(),
        '/enchantment': (context) => const EnchantmentPage(),
      },
    );
  }
}
