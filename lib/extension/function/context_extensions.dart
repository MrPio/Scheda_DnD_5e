import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

extension ContextExtensions on BuildContext {
  popup(String title,
      {String? message,
      Widget? child,
      String? positiveText,
      Color backgroundColor = Palette.background,
      Function()? positiveCallback,
      String? negativeText,
      Function()? negativeCallback,
      bool noContentHPadding=false}) {
    showDialog(
      context: this,
      builder: (_) {
        return AlertDialog(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.zero,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 26, horizontal: noContentHPadding?0:26),
                color: backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: noContentHPadding?26:0),
                      child: Text(title, style: Fonts.bold()),
                    ),
                    const SizedBox(height: Measures.vMarginSmall),
                    if (message != null) Padding(
                      padding: EdgeInsets.symmetric(horizontal: noContentHPadding?26:0),
                      child: Text(message, style: Fonts.regular()),
                    ),
                    if (child != null)
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 100,
                            maxHeight: 300,
                          ),
                          child: SingleChildScrollView(child: child)),
                    const SizedBox(height: Measures.vMarginThin),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: noContentHPadding?26:0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (positiveText != null)
                            TextButton(
                              onPressed: () {
                                positiveCallback?.call();
                                Navigator.pop(this);
                              },
                              child: Text(positiveText.toUpperCase(),
                                  style: Fonts.bold(size: 16)),
                            ),
                          if (negativeText != null)
                            TextButton(
                              onPressed: () {
                                negativeCallback?.call();
                                Navigator.pop(this);
                              },
                              child: Text(negativeText.toUpperCase(),
                                  style: Fonts.bold(size: 16)),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> askDate(BuildContext context, {DateTime? init}) async {
    return await showDatePicker(
      context: context,
      initialDate: init ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
  }

  snackbar(String message,
          {Color backgroundColor = Palette.background,
          double bottomMargin = Measures.hPadding}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          margin: EdgeInsets.only(
              left: Measures.hPadding,
              right: Measures.hPadding,
              bottom: bottomMargin),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(99))),
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor.withOpacity(0.65),
          elevation: 0,
          content: Text(message, style: Fonts.regular()),
        ),
      );

  checklist<T extends Enum>(String title,
      {required List<T> values,
      Function(T)? onChanged,
      bool Function(T)? value,
      String Function(T)? text,
      Color color=Palette.primaryBlue}) {
    popup(title,
        noContentHPadding: true,
        backgroundColor: Palette.popup,
        positiveText: 'Ok',
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            children: List.generate(
                values.length,
                (j) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => onChanged?.call(values[j])),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Row(
                            children: [
                              Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => states
                                            .contains(MaterialState.selected)
                                        ? const BorderSide(
                                            color: Colors.transparent)
                                        : const BorderSide(color: Palette.card2),
                                  ),
                                  activeColor: color,
                                  checkColor: Palette.onBackground,
                                  value: value?.call(values[j]),
                                  onChanged: (_) =>
                                      setState(() => onChanged?.call(values[j]))),
                              Text(text?.call(values[j])??'', style: Fonts.regular())
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ));
  }
}
