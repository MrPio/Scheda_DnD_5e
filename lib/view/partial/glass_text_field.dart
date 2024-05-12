import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

class GlassTextField extends StatelessWidget {
  TextEditingController? textController;
  final String? iconPath, secondaryIconPath, hintText;
  final bool obscureText, clearable, autofocus;
  final Function()? onSecondaryIconTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  GlassTextField(
      {super.key,
      this.iconPath,
      this.secondaryIconPath,
      this.onSecondaryIconTap,
      this.hintText,
      this.textController,
      this.keyboardType,
      this.obscureText = false,
      this.clearable = true,
      this.autofocus = false,
      this.textInputAction,
      this.onSubmitted});

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
            if (iconPath != null) iconPath!.toIcon(),
            if (iconPath != null) const SizedBox(width: Measures.hMarginMed),
            Expanded(
              child: TextField(
                  maxLength: 50,
                  maxLines: 1,
                  textInputAction: textInputAction,
                  onSubmitted: onSubmitted,
                  cursorColor: Palette.onBackground,
                  autofocus: autofocus,
                  style: Fonts.regular(size: 16),
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      border: InputBorder.none,
                      hintStyle: Fonts.light(color: Palette.hint, size: 16),
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
                    child: 'close'.toIcon(height: 16),
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
                    child: secondaryIconPath!.toIcon(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
