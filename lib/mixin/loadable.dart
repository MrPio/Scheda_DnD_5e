import 'package:flutter/material.dart';

/// Keep the [isLoading] variable in sync with the task completion status.
/// This is used to show a loading indicator or a shimmer effect while performing network operations.
mixin Loadable<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  withLoading(Future<void> Function() task) async {
    setState(() => isLoading = true);
    await task();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}
