import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GlassButton extends StatelessWidget {
  final Function()? onTap;
  final Color color;
  final String text;
  final String? iconPath;
  final bool outlined;

  const GlassButton(
    this.text, {
    super.key,
    this.iconPath,
    this.color = Colors.black,
    this.outlined = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: outlined ? Palette.background : color,
          side: outlined ? BorderSide(color: color, width: 1) : BorderSide.none,
          padding:
              const EdgeInsets.symmetric(vertical: Measures.vButtonPadding),
          shadowColor: color,
          elevation: outlined?0:12,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset('assets/images/icons/$iconPath.svg', height: 22),
            ),
          Text(text, style: outlined?Fonts.buttonOutlined():Fonts.button()),
        ]),
      ),
    );
  }
}
