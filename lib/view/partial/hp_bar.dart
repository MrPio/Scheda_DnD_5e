import 'package:flutter/material.dart';

import '../../constant/fonts.dart';
import '../../constant/measures.dart';
import '../../constant/palette.dart';
import '../../model/character.dart' hide Alignment;

class HpBar extends StatelessWidget {
  final int hp, maxHp;
  final bool showText;

  const HpBar(this.hp, this.maxHp, {super.key, this.showText = true});

  bool get isNeg => hp < 0;

  double get hpFraction => hp.abs() / maxHp;

  Color get color => isNeg
      ? Palette.primaryRed
      : switch (hpFraction) {
          > .5 => Palette.primaryBlue,
          > .25 => Color.lerp(Palette.primaryRed, Palette.primaryBlue, (hpFraction - .25) * 4) ??
              Palette.primaryBlue,
          _ => Palette.primaryRed
        };

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: Measures.hpBarHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Palette.background ),
              ),
              Align(
                alignment: isNeg?Alignment.centerRight:Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: hpFraction,
                  child: AnimatedContainer(
                    curve: Curves.easeOut,
                    duration: Durations.medium3,
                    width: double.infinity,
                    height: Measures.hpBarHeight,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(0.25), offset: const Offset(0, 0), blurRadius: 14)
                    ], borderRadius: BorderRadius.circular(999), color: color),
                  ),
                ),
              ),
            ],
          ),
          if (showText) Text('$hp / $maxHp HP', style: Fonts.light())
        ],
      );
}
