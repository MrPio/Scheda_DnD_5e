import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

class GlassTextField extends StatefulWidget {
  TextEditingController? textController;
  final String? iconPath, secondaryIconPath, hintText;
  final bool obscureText, clearable, autofocus, isFlat;
  final int lines, maxLength;
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
    this.onSubmitted,
    this.lines = 1,
    this.maxLength = 40,
    this.isFlat = false});

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  int get maxLength => widget.lines * widget.maxLength;

  @override
  Widget build(BuildContext context) {
    widget.textController ??= TextEditingController();
    widget.textController!.addListener(() {
      if (mounted) setState(() {});
    });

    return Container(
      decoration: BoxDecoration(
          color: Palette.card2,
          borderRadius: BorderRadius.circular(widget.isFlat
              ? 0
              : widget.lines > 1
              ? 12
              : 999)),
      child: Padding(
        padding: EdgeInsets.only(
            left: Measures.hTextFieldPadding,
            right: widget.secondaryIconPath != null ? 6 : Measures.hTextFieldPadding),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Row(
              crossAxisAlignment: widget.lines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                if (widget.iconPath != null) ...[
                  widget.iconPath!
                      .toIcon(height: 18, margin: EdgeInsets.only(top: widget.lines > 1 ? 12 : 0)),
                  const SizedBox(width: Measures.hMarginMed),
                ],
                Expanded(
                  child: TextField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom + Measures.vMarginBig * 3),
                      maxLength: maxLength,
                      maxLines: widget.lines,
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
                if (widget.clearable && widget.textController!.text.isNotEmpty) ...[
                  'close'.toIcon(
                      height: 14,
                      onTap: () => setState(() => widget.textController!.text = ''),
                      padding: const EdgeInsets.all(13)),
                ],
                if (widget.secondaryIconPath != null)
                  widget.secondaryIconPath!.toIcon(
                      height: 18, onTap: widget.onSecondaryIconTap, padding: const EdgeInsets.all(12))
              ],
            ),
            if (widget.lines > 1)
              Padding(
                padding: const EdgeInsets.only(right: Measures.hMarginSmall),
                child: Text('${widget.textController!.text.length}/$maxLength', style: Fonts.light()),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
