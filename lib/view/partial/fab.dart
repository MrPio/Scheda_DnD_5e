import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

import '../../constant/measures.dart';

class FABArgs {
  final Color color;
  final String icon;
  final Function()? onPress;
  final double bottomMargin;

  FABArgs({required this.color, required this.icon, this.onPress, this.bottomMargin=Measures.fABBottomMargin});
}

class FAB extends StatelessWidget {
  final FABArgs args;

  const FAB(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(bottom: args.bottomMargin, right: Measures.hPadding),
          child: FloatingActionButton(
            onPressed: args.onPress,
            elevation: 0,
            foregroundColor: args.color,
            backgroundColor: args.color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            child: args.icon.toIcon(height: 20),
          ),
        ));
  }
}
