import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/interface/with_title.dart';
import 'package:scheda_dnd_5e/view/partial/glass_checkbox.dart';

extension ContextExtensions on BuildContext {
  popup(String title,
      {String? message,
      Widget? child,
      String? positiveText,
      Color backgroundColor = Palette.background,
      Function()? positiveCallback,
      String? negativeText,
      Function()? negativeCallback,
      bool noContentHPadding = false}) {
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
                padding: EdgeInsets.symmetric(
                    vertical: 26, horizontal: noContentHPadding ? 0 : 26),
                color: backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: noContentHPadding ? 26 : 0),
                      child: Text(title, style: Fonts.bold()),
                    ),
                    const SizedBox(height: Measures.vMarginSmall),
                    if (message != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal: noContentHPadding ? 26 : 0)
                            .copyWith(bottom: Measures.vMarginSmall),
                        child: Text(message, style: Fonts.light(size: 16)),
                      ),
                    if (child != null)
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                            maxHeight: 316,
                          ),
                          child: SingleChildScrollView(child: child)),
                    const SizedBox(height: Measures.vMarginThin),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: noContentHPadding ? 26 : 0),
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
                                  style: Fonts.bold(size: 15)),
                            ),
                          if (negativeText != null)
                            TextButton(
                              onPressed: () {
                                negativeCallback?.call();
                                Navigator.pop(this);
                              },
                              child: Text(negativeText.toUpperCase(),
                                  style: Fonts.bold(size: 15)),
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
              borderRadius: BorderRadius.all(Radius.circular(25))),
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor.withOpacity(1),
          elevation: 0,
          content: Text(message, style: Fonts.regular()),
        ),
      );

  checklist<T extends EnumWithTitle>(String title,
      {required List<T> values,
      Function(T)? onChanged,
      bool Function(T)? value,
      Color color = Palette.primaryBlue}) {
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
                              GlassCheckbox(
                                value: value?.call(values[j]),
                                onChanged: () =>
                                    setState(() => onChanged?.call(values[j])),
                                color: color,
                              ),
                              Text(values[j].title, style: Fonts.regular())
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ));
  }
}
