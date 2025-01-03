import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';

import '../../constant/fonts.dart';
import '../../constant/palette.dart';

class Level extends StatelessWidget {
  final int level, maxLevel;
  final BottomSheetArgs? bottomSheetArgs;

  const Level({required this.level, required this.maxLevel, this.bottomSheetArgs, super.key});

  @override
  Widget build(BuildContext context) {
    return Clickable(
      bottomSheetArgs: bottomSheetArgs,
      active: bottomSheetArgs != null,
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(
                  color: Color.lerp(Palette.primaryYellow, Palette.primaryRed, level / (maxLevel - 1))!,
                  width: 2))),
          child: Center(
            child: Text(level.toString(), style: Fonts.regular()),
          )),
    );
  }
}
