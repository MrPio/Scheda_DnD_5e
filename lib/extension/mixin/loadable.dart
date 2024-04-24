import 'package:flutter/material.dart';

mixin Loadable<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  withLoading( Future<void> Function() task) async {
    setState(() => isLoading = true);
    await task.call();
    setState(() => isLoading = false);
  }
}
