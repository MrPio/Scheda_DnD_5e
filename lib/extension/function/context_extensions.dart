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
      Function()? negativeCallback}) {
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
                padding: const EdgeInsets.all(26),
                color: backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Fonts.bold()),
                    const SizedBox(height: 20),
                    if (message != null) Text(message, style: Fonts.regular()),
                    if (child != null) child,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (positiveText != null)
                        TextButton(
                          onPressed: () {
                            positiveCallback?.call();
                            Navigator.pop(this);
                          },
                          child:
                              Text(positiveText.toUpperCase(), style: Fonts.bold(size: 16)),
                        ),
                        if (negativeText != null)
                          TextButton(
                            onPressed: () {
                              negativeCallback?.call();
                              Navigator.pop(this);
                            },
                            child:
                                Text(negativeText.toUpperCase(), style: Fonts.bold(size: 16)),
                          ),
                      ],
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
}
