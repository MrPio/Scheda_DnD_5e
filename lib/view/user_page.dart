import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/gradient_background.dart';
import 'package:scheda_dnd_5e/view/screen/dice_screen.dart';
import 'package:scheda_dnd_5e/view/screen/user_screen.dart';

import '../constant/measures.dart';
import '../constant/palette.dart';
import '../model/user.dart';

class UserArgs {
  final String? title;
  final User? user;

  UserArgs({this.title, this.user});
}

class UserPage extends StatelessWidget {
  static Function()? onFabTap;
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)!.settings.arguments) as UserArgs?;
    return PopScope(
      onPopInvokedWithResult: (_, __) => ScaffoldMessenger.of(context).clearSnackBars(),
      child: Scaffold(
        backgroundColor: Palette.background,
        body: Stack(
          children: [
            const GradientBackground(topColor: Palette.backgroundGrey),
            UserScreen(args: args),
          ],
        ),
      ),
    );
  }
}
