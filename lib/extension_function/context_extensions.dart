import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';
import 'package:scheda_dnd_5e/view/partial/glass_checkbox.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../view/partial/clickable.dart';

class BottomSheetItem {
  final String iconPath, text;
  final Function() onTap;

  BottomSheetItem(this.iconPath, this.text, this.onTap);
}

extension ContextExtensions on BuildContext {
  Future<void> popup(String title,
      {String? message,
      Widget? child,
      Color backgroundColor = Palette.background,
      String? positiveText,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.zero,
            content: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Measures.hPadding, horizontal: noContentHPadding ? 0 : Measures.hPadding),
                  color: backgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: noContentHPadding ? Measures.hPadding : 0),
                        child: Text(title, style: Fonts.bold()),
                      ),
                      const SizedBox(height: Measures.vMarginSmall),
                      if (message != null)
                        Flexible(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                      horizontal: noContentHPadding ? Measures.hPadding : 0)
                                  .copyWith(bottom: Measures.vMarginSmall),
                              child: MarkdownBody(
                                  data: message,
                                  shrinkWrap: true,
                                  styleSheet: MarkdownStyleSheet(
                                      // TODO in mago c'è un pezzo nero
                                      p: Fonts.light(size: 15),
                                      tableBody: Fonts.light(size: 12),
                                      listBullet: Fonts.light(size: 15),
                                      tableCellsPadding: const EdgeInsets.all(4))),
                            ),
                          ),
                        ),
                      if (child != null) Flexible(child: SingleChildScrollView(child: child)),
                      const SizedBox(height: Measures.vMarginThin),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: noContentHPadding ? Measures.hPadding : 0),
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
                                child: Text(positiveText.toUpperCase(), style: Fonts.bold(size: 15)),
                              ),
                            if (negativeText != null)
                              TextButton(
                                onPressed: () {
                                  negativeCallback?.call();
                                  Navigator.pop(this);
                                },
                                child: Text(negativeText.toUpperCase(), style: Fonts.bold(size: 15)),
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

  Future<void> checkList<T extends WithTitle>(String title,
      {required List<T> values,
      Function(T)? onChanged,
      // Function()? positiveCallback,
      bool Function(T)? value,
      Color color = Palette.primaryBlue,
      bool isRadio = false,
      dismissible = true,
      int? selectionRequirement}) async {
    await popup(title,
        dismissible: dismissible,
        noContentHPadding: true,
        backgroundColor: Palette.popup,
        positiveText: 'Ok',
        // positiveCallback: positiveCallback,
        canPopPositiveCallback: () =>
            selectionRequirement == null ||
            selectionRequirement == values.map((e) => (value?.call(e) ?? false) ? 1 : 0).toList().sum(),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            children: List.generate(
                values.length,
                (j) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => onChanged?.call(values[j])),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                          child: Row(
                            children: [
                              GlassCheckbox(
                                isRadio: isRadio,
                                value: value?.call(values[j]),
                                onChanged: () => setState(() => onChanged?.call(values[j])),
                                color: color,
                              ),
                              Flexible(
                                  child: Text(
                                values[j].title,
                                style: Fonts.regular(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ))
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ));
  }

  snackbar(
    String message, {
    Color backgroundColor = Palette.background,
    double bottomMargin = Measures.vMarginSmall,
    Function()? undoCallback,
  }) async =>
      await ScaffoldMessenger.of(this)
          .showSnackBar(
            SnackBar(
              duration: undoCallback == null ? const Duration(seconds: 3) : const Duration(seconds: 6),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: EdgeInsets.only(
                  left: Measures.hPadding, right: Measures.hPadding, bottom: bottomMargin),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              behavior: SnackBarBehavior.floating,
              backgroundColor: backgroundColor,
              elevation: 0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(message, style: Fonts.regular())),
                  if (undoCallback != null)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(this).clearSnackBars();
                        undoCallback();
                      },
                      child: Text('ANNULLA', style: Fonts.bold(size: 15)),
                    )
                ],
              ),
            ),
          )
          .closed;

  bottomSheet(BottomSheetArgs args) => showModalBottomSheet(
      context: this,
      backgroundColor: Palette.background,
      enableDrag: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Measures.vMarginSmall),
            // Handle
            Align(
                alignment: Alignment.center,
                child: Container(
                  width: 32,
                  height: 4,
                  decoration:
                      BoxDecoration(color: Palette.card, borderRadius: BorderRadius.circular(999)),
                )),
            const SizedBox(height: Measures.vMarginSmall),

            if (args.header != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                child: args.header,
              ),
            if (args.header != null && args.items != null)
              const Padding(
                padding: EdgeInsets.only(top: Measures.vMarginSmall),
                child: Rule(),
              ),
            if (args.items != null)
              Column(
                children: [const SizedBox(height: Measures.vMarginThin) as Widget] +
                    args.items!
                        .map(
                          (e) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                e.onTap();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                                child: SizedBox(
                                  height: 60,
                                  child: Row(
                                    children: [
                                      e.iconPath.toIcon(),
                                      const SizedBox(width: Measures.hMarginBig),
                                      Flexible(
                                          child: Text(e.text,
                                              style: Fonts.bold(), overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()
                        .cast<Widget>(),
              ),
            const SizedBox(height: Measures.vMarginThin),
          ],
        );
      });

  draggableBottomSheet({required Widget body}) => showModalBottomSheet(
      context: this,
      backgroundColor: Palette.background,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: .35,
          maxChildSize: 1,
          expand: false,
          snap: true,
          snapSizes: const [.35, 1],
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Measures.vMarginSmall),
                  // Handle
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration:
                            BoxDecoration(color: Palette.card, borderRadius: BorderRadius.circular(999)),
                      )),
                  const SizedBox(height: Measures.vMarginSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                    child: body,
                  ),
                  const SizedBox(height: Measures.vMarginThin),
                ],
              ),
            );
          },
        );
      });

  goto(String routeName, {Object? arguments, Function(Object?)? then}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments).then((value) => then?.call(value));
}
