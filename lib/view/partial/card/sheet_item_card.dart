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
      this.subValue, this.child});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      clickable: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Measures.vMarginThin ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconPath.toIcon(height: 15,color: iconColor??Palette.onBackground),
                const SizedBox(width: Measures.hMarginThin),
                Flexible(
                  child: Text(
                    text,
                    style: Fonts.regular(size: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
            if(child!=null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Measures.vMarginMoreThin),
                child: Rule(),
              ),
            if(child!=null)
              child!,
          ],
        ),
      ),
    );
  }
}
