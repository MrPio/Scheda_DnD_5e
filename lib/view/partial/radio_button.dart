import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class RadioButton extends StatefulWidget {
  final String text;
  final Color color;
  final bool selected, isSmall;
  final void Function()? onPressed;
  final double? width;

  const RadioButton(
      {super.key,
      this.text = '',
      this.color = Palette.background,
      this.selected = false,
      this.onPressed,
      this.isSmall = false,
      this.width});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  TextStyle get textStyle =>
      widget.selected ? Fonts.bold(size: widget.isSmall?12:14) : Fonts.regular(size: widget.isSmall?12:14);

  double get buttonBorderWidth => widget.selected ? 0 : 1;

  Color get buttonBackgroundColor =>
      widget.selected ? widget.color : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: widget.color, width: buttonBorderWidth),
          backgroundColor: buttonBackgroundColor,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: NoSplash.splashFactory,
          foregroundColor: Colors.transparent,
          minimumSize: Size.zero,
          fixedSize: widget.width==null?null:Size(widget.width!, widget.isSmall?29:40),
          padding: EdgeInsets.symmetric(
              vertical: widget.isSmall
                  ? Measures.vButtonPaddingSmall
                  : Measures.vButtonPadding,
              horizontal: widget.width==null?Measures.hPadding / 2:0),
        ),
        child: Text(widget.text, style: textStyle,overflow: TextOverflow.ellipsis,maxLines: 1,));
  }
}
