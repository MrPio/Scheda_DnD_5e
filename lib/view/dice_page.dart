import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/fab.dart';
import 'package:scheda_dnd_5e/view/screen/dice_screen.dart';

import '../constant/measures.dart';
import '../constant/palette.dart';

class DiceArgs {
  final String? title;
  final List<Dice>? dices;
  final int? modifier;
  final bool oneShot;

  DiceArgs({this.title, this.dices, this.modifier, this.oneShot = false});
}

class DicePage extends StatelessWidget {
  static Function() onFabTap = () {};

  const DicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)!.settings.arguments) as DiceArgs?;
    return PopScope(
      onPopInvokedWithResult: (_, __) => ScaffoldMessenger.of(context).clearSnackBars(),
      child: Scaffold(
        backgroundColor: Palette.background,
        body: Stack(
          children: [
            const GradientBackground(topColor: Palette.backgroundGreen),
            DiceScreen(args: args),
            // FAB
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: Measures.fABBottomMargin, right: Measures.hPadding),
                  child: FAB(FABArgs(
                    color: Palette.primaryGreen,
                    icon: 'refresh',
                    onPress: () => DicePage.onFabTap(),
                  )),
                )),
          ],
        ),
      ),
    );
  }
}
