import 'dart:math';

import 'package:flutter/material.dart';

import '../../constant/fonts.dart';
import '../../constant/palette.dart';

class NumericInput extends StatefulWidget {
  final double width;
  final EdgeInsets contentPadding;
  final TextEditingController controller;
  final bool isDense;
  final String? hint;
  final int max, min;
  final TextStyle? style;

  const NumericInput(this.min, this.max,
      {super.key,
      this.width = 50,
      this.isDense = false,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 2),
      required this.controller,
      this.hint,
      this.style});

  @override
  State<NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  int get value => max(widget.min,min(widget.max,int.tryParse(widget.controller.text)??0));

  set value(int value) =>
      setState(() => widget.controller.text = value.toString());

  bool get hasSign => widget.min < 0 || widget.max < 0;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.text.contains(hasSign ? '--' : '-')) {
        widget.controller.text = widget.controller.text
            .replaceAll(hasSign ? '--' : '-', hasSign ? '-' : '');
      }
      if (hasSign &&
          widget.controller.text.contains('-') &&
          widget.controller.text.indexOf('-') != 0) {
        widget.controller.text =
            '-${widget.controller.text.replaceAll('-', '')}';
      }
      if (widget.controller.text.contains('.') ||
          widget.controller.text.contains(',')) {
        widget.controller.text =
            widget.controller.text.replaceAll('.', '').replaceAll(',', '');
      }
      if (widget.controller.text.isEmpty) {
        // value = 0;
      } else if (hasSign &&
          !widget.controller.text.contains('+') &&
          value > 0) {
        widget.controller.text = '+$value';
      }
      // if (value > widget.max) {
      //   value = widget.max;
      // } else if (value < widget.min) {
      //   value = widget.min;
      // }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Focus(
        onFocusChange: (_)=>
        value=value,
        child: TextField(
          onSubmitted: (_)=>
            value=value,
            onTapOutside: (_)=>value=value,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.number,
            maxLength: widget.max.toString().length + (hasSign ? 1 : 0),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                hintText: widget.hint,
                isDense: widget.isDense,
                border: widget.isDense ? null : InputBorder.none,
                contentPadding: widget.contentPadding,
                hintStyle: Fonts.light(color: Palette.hint),
                hoverColor: Palette.onBackground,
                focusColor: Palette.onBackground,
                counterText: ''),
            controller: widget.controller,
            style: widget.style ?? Fonts.black(size: 26)),
      ),
    );
  }
}
