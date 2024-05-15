import 'dart:math';

import 'package:flutter/material.dart';

import '../../constant/fonts.dart';
import '../../constant/palette.dart';

class NumericInput extends StatefulWidget {
  final double width;
  final EdgeInsets contentPadding;
  final TextEditingController controller;
  final bool isDense;
  final String? hint,suffix;
  final int max, min, decimalPlaces;
  final double? defaultValue;
  final TextStyle? style;
  final double Function(double)? valueRestriction;

  const NumericInput(this.min, this.max,
      {super.key,
      this.width = 50,
      this.isDense = false,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 2),
      required this.controller,
      this.hint,
      this.style,
      this.defaultValue,
      this.decimalPlaces = 0,
      this.valueRestriction, this.suffix});

  @override
  State<NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  late final double Function(double) valueRestriction;

  int get value => (valueRestriction(max(
              widget.min.toDouble(),
              min(
                  widget.max.toDouble(),
                  (double.tryParse(widget.controller.text) ??
                      widget.defaultValue ??
                      0)))) *
          pow(10, widget.decimalPlaces))
      .toInt();

  set value(int value) => setState(() => widget.controller.text =
      (value.toDouble() / pow(10, widget.decimalPlaces))
          .toStringAsFixed(widget.decimalPlaces)+(hasFocus?'':(widget.suffix??'')));

  bool get hasSign => widget.min < 0 || widget.max < 0;

  @override
  void initState() {
    valueRestriction = widget.valueRestriction ?? (v) => v;
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
      if (widget.decimalPlaces <= 0 && widget.controller.text.contains('.')) {
        widget.controller.text = widget.controller.text.replaceAll('.', '');
      }
      if (widget.controller.text.contains(',')) {
        widget.controller.text = widget.controller.text
            .replaceAll(',', widget.decimalPlaces <= 0 ? '' : '.');
      }
      if (widget.controller.text.isEmpty) {
        // value = 0;
      } else if (hasSign &&
          !widget.controller.text.contains('+') &&
          value > 0) {
        widget.controller.text = '+$value';
      }
    });
    super.initState();
  }
bool hasFocus=false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width+(widget.suffix?.length??0)*5,
      child: Focus(
        onFocusChange: (focus) {hasFocus=focus;value = value;},
        child: TextField(
            onSubmitted: (_) => value = value,
            onTapOutside: (_) => value = value,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.number,
            maxLength: widget.max.toString().length +
                (hasSign ? 1 : 0) +
                (widget.decimalPlaces > 0 ? widget.decimalPlaces + 1 : 0)+(hasFocus?(widget.suffix?.length??0):0),
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
