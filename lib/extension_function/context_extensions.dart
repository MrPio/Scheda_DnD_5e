import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';
import 'package:scheda_dnd_5e/view/partial/glass_checkbox.dart';

extension ContextExtensions on BuildContext {
  Future<void> popup(String title,
      {String? message,
      Widget? child,
      String? positiveText,
      Color backgroundColor = Palette.background,
      Function()? positiveCallback,
      bool Function()? canPopPositiveCallback,
      String? negativeText,
      Function()? negativeCallback,
      bool noContentHPadding = false,
      dismissible = true}) async {
    await showDialog(
      barrierDismissible: dismissible,
      context: this,
      builder: (_) {
        return PopScope(
          canPop: dismissible,
          child: AlertDialog(
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
                        Flexible(
                          child: SingleChildScrollView(

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                      horizontal: noContentHPadding ? 26 : 0)
                                  .copyWith(bottom: Measures.vMarginSmall),
                              child: MarkdownBody(
                                  data: message,
                                  shrinkWrap: true,
                                  styleSheet: MarkdownStyleSheet(
                                      p: Fonts.light(size: 15),
                                      tableBody: Fonts.light(size: 12),
                                      listBullet: Fonts.light(size: 15),
                                      tableCellsPadding:
                                          const EdgeInsets.all(4))),
                            ),
                          ),
                        ),
                      if (child != null)
                        Flexible(child: SingleChildScrollView(child: child)),
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
                                  if (canPopPositiveCallback?.call() ?? true) {
                                    Navigator.pop(this);
                                  }
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

  Future<void> checkList<T extends EnumWithTitle>(
    String title, {
    required List<T> values,
    Function(T)? onChanged,
    // Function()? positiveCallback,
    bool Function(T)? value,
    Color color = Palette.primaryBlue,
    bool isRadio = false,
    dismissible = true,
        int? selectionRequirement
  }) async {
    await popup(title,
        dismissible: dismissible,
        noContentHPadding: true,
        backgroundColor: Palette.popup,
        positiveText: 'Ok',
        // positiveCallback: positiveCallback,
        canPopPositiveCallback: ()=>selectionRequirement==null||selectionRequirement==values.map((e) => (value?.call(e)??false)?1:0).toList().sum(),
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
                                isRadio: isRadio,
                                value: value?.call(values[j]),
                                onChanged: () =>
                                    setState(() => onChanged?.call(values[j])),
                                color: color,
                              ),
                              Flexible(child: Text(values[j].title, style: Fonts.regular(), overflow: TextOverflow.ellipsis,maxLines: 2,))
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ));
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
          backgroundColor: backgroundColor.withOpacity(0.925),
          elevation: 0,
          content: Text(message, style: Fonts.regular()),
        ),
      );

  bottomSheet()=>
      showModalBottomSheet(
          context: this,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SizedBox(
                // height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight:Radius.circular(32) ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 26, horizontal: 0),
                      color: Palette.popup,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Measures.vMarginSmall),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 26),
                                child: SizedBox(
                                  height: 60,
                                  child: Row(
                                    children: [
                                      'dice'.toIcon(),
                                      const SizedBox(width: Measures.hMarginMed),
                                      Flexible(child: Text('Ciao', style: Fonts.regular(), overflow: TextOverflow.ellipsis))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )                        ],
                      ),
                    ),
                  ),
                )
            );
          });
}
