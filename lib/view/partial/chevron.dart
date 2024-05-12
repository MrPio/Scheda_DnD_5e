import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

import '../../constant/measures.dart';

class Chevron extends StatelessWidget {
  final Function()? onTap;
  const Chevron({this.onTap,super.key});

  @override
  Widget build(BuildContext context) {
    return 'chevron_left'.toIcon(
        height: 24,
        onTap: onTap??Navigator.of(context).pop,
        margin:Measures.chevronMargin,
        padding:Measures.chevronPadding);
  }
}
