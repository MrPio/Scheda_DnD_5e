import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../../../constant/palette.dart';

class SheetItemCard extends StatelessWidget {
  final String iconPath, text;
  final Color? iconColor;
  final String? value, subValue;
  final Widget? child;

  const SheetItemCard(
      {super.key,
      required this.iconPath,
      this.iconColor,
      required this.text,
      this.value,
      this.subValue,
      this.child});

  bool get isSmall => value == null && subValue == null;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      height: isSmall ? Measures.sheetCardSmallHeight : null,
      clickable: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: isSmall ? 0 : Measures.vMarginThin,
            horizontal: isSmall ? Measures.hMarginMed : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment:
                  isSmall ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                iconPath.toIcon(
                    height: 15, color: iconColor ?? Palette.onBackground),
                SizedBox(
                    width:
                        isSmall ? Measures.hMarginSmall : Measures.hMarginThin),
                Flexible(
                  child: Text(
                    text,
                    style: Fonts.regular(size: 13),
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior:  isSmall?const TextHeightBehavior(
                        applyHeightToFirstAscent: false,applyHeightToLastDescent: false):null,
                    maxLines: isSmall ? 2 : 1,
                  ),
                )
              ],
            ),
            // Value and subValue
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(top: Measures.vMarginMoreThin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(value!, style: Fonts.black(size: 18)),
                    if (subValue != null)
                      Text('($subValue)', style: Fonts.light()),
                  ],
                ),
              ),
            if (child != null)
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Measures.vMarginMoreThin),
                child: Rule(),
              ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
