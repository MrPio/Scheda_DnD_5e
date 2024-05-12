import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';

import '../constant/palette.dart';

mixin Validable<T extends StatefulWidget> on State<T> {
  bool validate(Function() task) {
    try {
      task();
      return true;
    } on FormatException catch (e) {
      context.snackbar(e.message, backgroundColor: Palette.primaryRed);
      return false;
    }
  }
}
