import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

class GlassTextField extends StatefulWidget {
  TextEditingController? textController;
  final String? iconPath, secondaryIconPath, hintText;
  final bool obscureText, clearable, autofocus, multiline;
  final Function()? onSecondaryIconTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  GlassTextField({super.key,
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
    this.onSubmitted, this.multiline = false});

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  @override
  Widget build(BuildContext context) {
    widget.textController ??= TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    return Container(
      decoration: BoxDecoration(color: Palette.card2, borderRadius: BorderRadius.circular(widget.multiline?12:999)),
      child: Padding(
        padding: EdgeInsets.only(
            left: Measures.hTextFieldPadding,
            right: widget.secondaryIconPath != null ? 6 : Measures.hTextFieldPadding),
        child: Row(
          crossAxisAlignment: widget.multiline?CrossAxisAlignment.start:CrossAxisAlignment.center,
          children: [
            if (widget.iconPath != null) ...[
              widget.iconPath!.toIcon(height: 18,margin: EdgeInsets.only(top: widget.multiline?12:0)),
              const SizedBox(width: Measures.hMarginMed),
            ],
            Expanded(
              child: TextField(
                  maxLength: widget.multiline ? 500 : 50,
                  maxLines: widget.multiline ? 5 : 1,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  cursorColor: Palette.onBackground,
                  autofocus: widget.autofocus,
                  style: Fonts.regular(),
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                      border: InputBorder.none,
                      hintStyle: Fonts.light(color: Palette.hint, size: 16),
                      hintText: widget.hintText,
                      hoverColor: Palette.onBackground,
                      focusColor: Palette.onBackground),
                  controller: widget.textController),
            ),
            if (widget.clearable && widget.textController!.text.isNotEmpty)
              Row(
                children: [
                  const SizedBox(width: Measures.hMarginMed),
                  GestureDetector(
                    onTap: () => widget.textController!.text = '',
                    child: 'close'.toIcon(height: 14),
                  ),
                ],
              ),
            if (widget.secondaryIconPath != null)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.multiline ? 12 : 999),
                  splashColor: Palette.onBackground.withOpacity(0.5),
                  onTap: widget.onSecondaryIconTap,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: widget.secondaryIconPath!.toIcon(height: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
