import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';

class DiceCard extends StatelessWidget {
  final Dice dice;
  final bool clickable;
  final void Function(Dice)? onTap;

  const DiceCard(this.dice, {super.key, this.onTap, this.clickable=true});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      clickable: clickable,
      onTap: ()=>onTap?.call(dice),
      height: Measures.diceCardHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dice.title, style: Fonts.regular()),
          const SizedBox(width: Measures.vMarginThin),
          SvgPicture.asset(dice.svgPath, height: 34)
        ],
      ),
    );
  }
}
