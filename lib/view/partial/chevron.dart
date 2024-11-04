import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

import '../../constant/measures.dart';

class Chevron extends StatelessWidget {
  final Function()? onTap;
  final bool inAppBar;
  final Object? popArgs;
  const Chevron({this.onTap,super.key,  this.inAppBar=false, this.popArgs});

  @override
  Widget build(BuildContext context) {
    return 'chevron_left'.toIcon(
        height: 22,
        onTap: onTap??()=>Navigator.of(context).pop(popArgs),
        margin: inAppBar?const EdgeInsets.only( left: Measures.hMarginMed):Measures.chevronMargin,
        padding:Measures.chevronPadding);
  }
}
