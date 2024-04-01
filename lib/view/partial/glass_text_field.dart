import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GlassTextField extends StatelessWidget {
  TextEditingController? textController;
  final String? iconPath, hintText;

  GlassTextField(
      {super.key, this.iconPath, this.hintText, this.textController});

  @override
  Widget build(BuildContext context) {
    textController ??= TextEditingController();
    return Container(
      decoration: BoxDecoration(
          color: Palette.card2, borderRadius: BorderRadius.circular(999)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Measures.hTextFieldPadding),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/icons/$iconPath.svg', height: 22),
            const SizedBox(width: Measures.hMarginMed),
            Expanded(
              child: TextField(
                  cursorColor: Palette.onBackground,
                  autofocus: false,
                  style: Fonts.regular(),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      border: InputBorder.none,
                      hintStyle: Fonts.light(color: Palette.hint),
                      hintText: hintText,
                      hoverColor: Palette.onBackground,
                      focusColor: Palette.onBackground),
                  controller: textController),
            ),
            if (textController!.text.isNotEmpty)
              Row(
                children: [
                  const SizedBox(width: Measures.hMarginMed),
                  GestureDetector(
                    onTap: () => textController!.text = '',
                    child: SvgPicture.asset('assets/images/icons/close.svg',
                        height: 16),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
