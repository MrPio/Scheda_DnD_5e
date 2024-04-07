import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GlassTextField extends StatelessWidget {
  TextEditingController? textController;
  final String? iconPath, secondaryIconPath, hintText;
  final bool obscureText, clearable;
  final Function()? onSecondaryIconTap;
  final TextInputType? keyboardType;

  GlassTextField(
      {super.key,
      this.iconPath,
      this.secondaryIconPath,
      this.onSecondaryIconTap,
      this.hintText,
      this.textController,
      this.keyboardType,
      this.obscureText = false,
      this.clearable = true});

  @override
  Widget build(BuildContext context) {
    textController ??= TextEditingController();
    return Container(
      decoration: BoxDecoration(
          color: Palette.card2, borderRadius: BorderRadius.circular(999)),
      child: Padding(
        padding: EdgeInsets.only(
            left: Measures.hTextFieldPadding,
            right: secondaryIconPath != null ? 6 : Measures.hTextFieldPadding),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/icons/$iconPath.svg', height: 22),
            const SizedBox(width: Measures.hMarginMed),
            Expanded(
              child: TextField(
                  cursorColor: Palette.onBackground,
                  autofocus: false,
                  style: Fonts.regular(size: 17),
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      border: InputBorder.none,
                      hintStyle: Fonts.light(color: Palette.hint, size: 17),
                      hintText: hintText,
                      hoverColor: Palette.onBackground,
                      focusColor: Palette.onBackground),
                  controller: textController),
            ),
            if (clearable && textController!.text.isNotEmpty)
              Row(
                children: [
                  const SizedBox(width: Measures.hMarginMed),
                  GestureDetector(
                    onTap: () => textController!.text = '',
                    child: SvgPicture.asset('assets/images/icons/close.svg',
                        height: 16),
                  ),
                ],
              ),
            if (secondaryIconPath != null)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  splashColor: Palette.onBackground.withOpacity(0.5),
                  onTap: onSecondaryIconTap,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                        'assets/images/icons/$secondaryIconPath.svg',
                        height: 22),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
