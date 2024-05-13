import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

import '../../constant/measures.dart';

class Chevron extends StatelessWidget {
  final Function()? onTap;
  final bool inAppBar;
  const Chevron({this.onTap,super.key,  this.inAppBar=false});

  @override
  Widget build(BuildContext context) {
    return 'chevron_left'.toIcon(
        height: 24,
        onTap: onTap??Navigator.of(context).pop,
        margin: inAppBar?const EdgeInsets.only( left: Measures.hMarginMed):Measures.chevronMargin,
        padding:Measures.chevronPadding);
  }
}
