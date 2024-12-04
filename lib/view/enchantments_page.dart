import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/gradient_background.dart';
import 'package:scheda_dnd_5e/view/screen/enchantments_screen.dart';

import '../constant/palette.dart';
import '../model/character.dart';

class EnchantmentsArgs {
  List<Class>? filterClasses;
  final String? title;

  EnchantmentsArgs({this.title, this.filterClasses});
}

class EnchantmentsPage extends StatelessWidget {
  static Function()? onFabTap;

  const EnchantmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)!.settings.arguments) as EnchantmentsArgs?;
    return PopScope(
        onPopInvokedWithResult: (_, __) => ScaffoldMessenger.of(context).clearSnackBars(),
        child: Scaffold(
          backgroundColor: Palette.background,
          body: Stack(
            children: [
              const GradientBackground(topColor: Palette.backgroundPurple),
              EnchantmentsScreen(args: args),
            ],
          ),
        ));
  }
}
