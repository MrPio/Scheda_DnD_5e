import 'dart:math';

import 'package:flutter/material.dart';

import '../../constant/fonts.dart';
import '../../constant/palette.dart';

class NumericInputArgs {
  TextEditingController controller;
  String? suffix;
  int max, min, decimalPlaces;
  double? defaultValue;
  double Function(double)? valueRestriction;
  Function(double)? onSubmitted;
  Function()? finalize;
  double width;
  EdgeInsets contentPadding;
  bool isDense;
  String? hint;
  TextStyle? style;
  FocusNode? focusNode;
  bool autofocus;

  NumericInputArgs(
      {required this.min,
      required this.max,
      required this.controller,
      this.suffix,
      this.decimalPlaces = 0,
      this.defaultValue,
      this.valueRestriction,
      this.onSubmitted,
      this.finalize,
      this.width = 50,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 2),
      this.isDense = false,
      this.hint,
      this.style,
      this.focusNode,
      this.autofocus=false});
}

class NumericInput extends StatefulWidget {
  final NumericInputArgs args;

  const NumericInput(this.args, {super.key});

  @override
  State<NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  late final double Function(double) valueRestriction;

  int get value => (valueRestriction(max(
              widget.args.min.toDouble(),
              min(
                  widget.args.max.toDouble(),
                  (double.tryParse(widget.args.controller.text) ??
                      widget.args.defaultValue ??
                      0)))) *
          pow(10, widget.args.decimalPlaces))
      .toInt();

  set value(int value) => setState(() => widget.args.controller.text =
      (value.toDouble() / pow(10, widget.args.decimalPlaces))
              .toStringAsFixed(widget.args.decimalPlaces) +
          (hasFocus ? '' : (widget.args.suffix ?? '')));

  bool get hasSign => widget.args.min < 0 || widget.args.max < 0;

  @override
  void initState() {
    valueRestriction = widget.args.valueRestriction ?? (v) => v;
    widget.args.controller.addListener(() {
      if (widget.args.controller.text.contains(hasSign ? '--' : '-')) {
        widget.args.controller.text = widget.args.controller.text
            .replaceAll(hasSign ? '--' : '-', hasSign ? '-' : '');
      }
      if (hasSign &&
          widget.args.controller.text.contains('-') &&
          widget.args.controller.text.indexOf('-') != 0) {
        widget.args.controller.text =
            '-${widget.args.controller.text.replaceAll('-', '')}';
      }
      if (widget.args.decimalPlaces <= 0 &&
          widget.args.controller.text.contains('.')) {
        widget.args.controller.text =
            widget.args.controller.text.replaceAll('.', '');
      }
      if (widget.args.controller.text.contains(',')) {
        widget.args.controller.text = widget.args.controller.text
            .replaceAll(',', widget.args.decimalPlaces <= 0 ? '' : '.');
      }
      if (widget.args.controller.text.isEmpty) {
        // value = 0;
      } else if (hasSign &&
          !widget.args.controller.text.contains('+') &&
          value > 0) {
        widget.args.controller.text = '+$value';
      }
    });
    super.initState();
  }

  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.args.width + (widget.args.suffix?.length ?? 0) * 5,
      child: Focus(
        onFocusChange: (focus) {
          hasFocus = focus;
          value = value;
          if (!focus) {
            widget.args.finalize?.call();
          }
        },
        child: TextField(
          autofocus: widget.args.autofocus,
            focusNode: widget.args.focusNode,
            onSubmitted: (_) {
              value = value;
              widget.args.onSubmitted
                  ?.call(value.toDouble() / pow(10, widget.args.decimalPlaces));
              widget.args.finalize?.call();
            },
            onTapOutside: (_) => value = value,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.number,
            maxLength: widget.args.max.toString().length +
                (hasSign ? 1 : 0) +
                (widget.args.decimalPlaces > 0
                    ? widget.args.decimalPlaces + 1
                    : 0) +
                (hasFocus ? (widget.args.suffix?.length ?? 0) : 0),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                hintText: widget.args.hint,
                isDense: widget.args.isDense,
                border: widget.args.isDense ? null : InputBorder.none,
                contentPadding: widget.args.contentPadding,
                hintStyle: Fonts.light(color: Palette.hint),
                hoverColor: Palette.onBackground,
                focusColor: Palette.onBackground,
                counterText: ''),
            controller: widget.args.controller,
            style: widget.args.style ?? Fonts.black(size: 26)),
      ),
    );
  }
}
