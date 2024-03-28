import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';

extension ContextExtensions on BuildContext {
  popup(String title,
      {String? message,
      Widget? child,
        String positiveText = 'OK',
        Function()? positiveCallback,
        String? negativeText,
        Function()? negativeCallback}) {
    showDialog(
      context: this,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Theme.of(this).primaryColor,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: Fonts.bold()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              message == null
                  ? Container()
                  : Text(message, style: Fonts.regular()),
              child ?? Container(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                positiveCallback?.call();
                Navigator.pop(this);
              },
              child: Text(positiveText, style: Fonts.bold(size: 16)),
            ),
            negativeText==null?Container():
            TextButton(
              onPressed: () {
                negativeCallback?.call();
                Navigator.pop(this);
              },
              child: Text(negativeText, style: Fonts.bold(size: 16)),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> askDate(BuildContext context, {DateTime? init}) async {
    return await showDatePicker(
      context: context,
      initialDate: init??DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
  }
}
