import 'dart:math';

import 'package:flutter/material.dart';

import '../../constant/fonts.dart';
import '../../constant/measures.dart';
import '../../constant/palette.dart';

class NumericInputArgs {
  TextEditingController? controller;
  String? suffix, initialValue;
  int max, min, decimalPlaces;
  double? defaultValue;
  double Function(double)? valueRestriction;
  Function(double)? onSubmit;
  Function()? finalize;
  double width;
  EdgeInsets contentPadding;
  bool isDense;
  String? hint;
  TextStyle? style;
  FocusNode? focusNode;
  bool autofocus;
  String? zeroEncoding;

  NumericInputArgs(
      {required this.min,
      required this.max,
      this.controller,
      this.suffix,
      this.decimalPlaces = 0,
      this.defaultValue,
      this.initialValue,
      this.valueRestriction,
      this.onSubmit,
      this.finalize,
      this.width = 50,
      this.contentPadding = const EdgeInsets.symmetric(vertical: 2),
      this.isDense = false,
      this.hint,
      this.style,
      this.focusNode,
      this.autofocus = false,
      this.zeroEncoding});
}

class NumericInput extends StatefulWidget {
  final NumericInputArgs args;

  const NumericInput(this.args, {super.key});

  @override
  State<NumericInput> createState() => _NumericInputState();

  int get value => ((args.valueRestriction ?? (v) => v)(max(
              args.min.toDouble(),
              min(
                  args.max.toDouble(),
                  (double.tryParse(args.controller?.text ?? args.initialValue ?? '0') ??
                      args.defaultValue ??
                      0)))) *
          pow(10, args.decimalPlaces))
      .toInt();
}

class _NumericInputState extends State<NumericInput> {
  late final double Function(double) valueRestriction;
  bool hasFocus = false;

  int get value => (valueRestriction(max(
              widget.args.min.toDouble(),
              min(widget.args.max.toDouble(),
                  (double.tryParse(widget.args.controller!.text) ?? widget.args.defaultValue ?? 0)))) *
          pow(10, widget.args.decimalPlaces))
      .toInt();

  set value(int value) => setState(() => widget.args.controller!.text =
      (value.toDouble() / pow(10, widget.args.decimalPlaces)).toStringAsFixed(widget.args.decimalPlaces) +
          (hasFocus ? '' : (widget.args.suffix ?? '')));

  bool get hasSign => widget.args.min < 0 || widget.args.max < 0;

  @override
  void initState() {
    widget.args.controller ??= TextEditingController();
    valueRestriction = widget.args.valueRestriction ?? (v) => v;
    widget.args.controller!.addListener(() {
      // If the text is '0', replace it with the zero encoding, if any
      if (widget.args.zeroEncoding != null &&
          int.tryParse(widget.args.controller!.text) != null &&
          int.parse(widget.args.controller!.text) == 0) {
        widget.args.controller!.text = widget.args.zeroEncoding!;
        return;
      }
      // Remove unnecessary minus signs
      if (widget.args.controller!.text.contains(hasSign ? '--' : '-')) {
        widget.args.controller!.text =
            widget.args.controller!.text.replaceAll(hasSign ? '--' : '-', hasSign ? '-' : '');
      }
      // Move any minus sign at the beginning of the text
      if (hasSign && widget.args.controller!.text.indexOf('-') > 0) {
        widget.args.controller!.text = '-${widget.args.controller!.text.replaceAll('-', '')}';
      }
      // Remove any points if it's an integer numeric input
      if (widget.args.decimalPlaces <= 0 && widget.args.controller!.text.contains('.')) {
        widget.args.controller!.text = widget.args.controller!.text.replaceAll('.', '');
      }
      // Remove or replace commas with points to separate decimal digits
      if (widget.args.controller!.text.contains(',')) {
        widget.args.controller!.text =
            widget.args.controller!.text.replaceAll(',', widget.args.decimalPlaces <= 0 ? '' : '.');
      }
      // Add leading plus symbol if a negative numbers are allowed
      if (widget.args.controller!.text.isNotEmpty &&
          hasSign &&
          !widget.args.controller!.text.contains('+') &&
          !widget.args.controller!.text.contains('-') &&
          value > 0) {
        widget.args.controller!.text = '+$value';
      }
    });
    // Initialize the text
    widget.args.controller!.text = widget.args.initialValue ?? widget.args.min.toString();
    super.initState();
  }

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
          } else if (widget.args.zeroEncoding != null &&
              widget.args.controller!.text == widget.args.zeroEncoding) {
            widget.args.controller!.text = '';
          }
        },
        child: TextField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + Measures.vMarginBig * 3),
            autofocus: widget.args.autofocus,
            focusNode: widget.args.focusNode,
            onSubmitted: (_) {
              value = value;
              widget.args.onSubmit?.call(value.toDouble() / pow(10, widget.args.decimalPlaces));
              widget.args.finalize?.call();
            },
            onTapOutside: (_) => value = value,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.number,
            maxLength: widget.args.max.toString().length +
                (hasSign ? 1 : 0) +
                (widget.args.decimalPlaces > 0 ? widget.args.decimalPlaces + 1 : 0) +
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
            controller: widget.args.controller!,
            style: widget.args.style ?? Fonts.black(size: 26)),
      ),
    );
  }
}
