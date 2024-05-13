import 'package:flutter/material.dart';

import '../../constant/fonts.dart';
import '../../constant/palette.dart';

class Level extends StatelessWidget {
  final int level, maxLevel;
  const Level({super.key, required this.level, required this.maxLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(
                color: Color.lerp(Palette.primaryYellow,
                    Palette.primaryRed, level / (maxLevel-1))!,
                width: 2))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(level.toString(),
              style: Fonts.regular()),
        ));
  }
}
