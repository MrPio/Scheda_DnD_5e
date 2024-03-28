import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/model/user.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // AccountManager().signIn('valeriomorelli50@gmail.com', 'aaaaaa');
  // DatabaseManager().post('users', User().toJSON());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Scheda DnD 5e',
      home: Placeholder(),
    );
  }
}
