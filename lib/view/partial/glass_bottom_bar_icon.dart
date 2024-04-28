import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

class GlassBottomBarIcon extends StatelessWidget {
  final String title, iconPathOn, iconPathOff;
  final bool active;
  final Function()? onTap;

  const GlassBottomBarIcon(
      {required this.title,
      required this.iconPathOn,
      required this.iconPathOff,
      this.active = true,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (active ? iconPathOn : iconPathOff).toIcon(height: 30),
            const SizedBox(height: Measures.vMarginMoreThin),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(title,
                  style: active ? Fonts.black(size: 12) : Fonts.regular(size: 0)),
            )
          ],
        ),
      ),
    );
  }
}
