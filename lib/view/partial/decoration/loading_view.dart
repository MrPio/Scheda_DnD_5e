import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';

class LoadingView extends StatelessWidget {
  final bool visible;

  const LoadingView({this.visible = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Container(
          color: Palette.backgroundGrey.withValues(alpha: 0.2),
          child: const Center(
            child: CircularProgressIndicator(
              color: Palette.onBackground,
            ),
          ),
        ));
  }
}
