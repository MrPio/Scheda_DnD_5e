import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../../../constant/palette.dart';

class SheetItemCard extends StatelessWidget {
  final String iconPath, text;
  final Color? iconColor;
  final String? value, subValue, valueSuffix;
  final Widget? child, bottomSheetHeader;
  final List<BottomSheetItem>? bottomSheetItems;
  final int min, max, decimalPlaces;
  final TextEditingController? textEditingController;
  final double Function(double)? valueRestriction;
  final Function()? onTap;

  final double? defaultValue;

  SheetItemCard(
      {super.key,
      required this.iconPath,
      this.iconColor,
      required this.text,
      this.value,
      this.subValue,
      this.child,
      this.bottomSheetHeader,
      this.min = 0,
      this.max = 10,
      this.textEditingController,
      this.defaultValue,
      this.decimalPlaces = 0,
      this.valueRestriction,
      this.valueSuffix,
      this.bottomSheetItems, this.onTap}){
    if (textEditingController != null) {
      textEditingController!.text = value.toString();
    }
  }

  bool get isSmall => value == null && subValue == null;

  @override
  Widget build(BuildContext context) {
    final _bottomSheetHeader = (bottomSheetHeader != null||bottomSheetItems!=null)
        ? Align(
      alignment: Alignment.center,
          child: Column(
              children: [
                const SizedBox(height: Measures.vMarginThin),
                Text(text, style: Fonts.bold(size: 18)),
                if(bottomSheetHeader!=null)
                const SizedBox(height: Measures.vMarginMed),
                if(bottomSheetHeader!=null)
                bottomSheetHeader!,
                if(bottomSheetHeader!=null)
                const SizedBox(
                    height: Measures.vMarginMed + Measures.vMarginSmall),
              ],
            ),
        )
        : null;
    return GlassCard(
      height: isSmall ? Measures.sheetCardSmallHeight : null,
      clickable: bottomSheetHeader != null || bottomSheetItems!=null || onTap!=null,
      bottomSheetHeader: _bottomSheetHeader,
      bottomSheetItems: bottomSheetItems,
      onTap: onTap??() {
        context.bottomSheet(header: _bottomSheetHeader,items: bottomSheetItems);
      },
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
                    height: 15,
                    color: iconColor ?? Palette.onBackground),
                SizedBox(
                    width:
                        isSmall ? Measures.hMarginSmall : Measures.hMarginThin),
                Flexible(
                  child: Text(
                    text,
                    style: Fonts.regular(size: 13),
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior: isSmall
                        ? const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false)
                        : null,
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
                    textEditingController != null
                        ? NumericInput(
                            min,
                            max,
                            controller: textEditingController!,
                            style: Fonts.black(size: 18),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            defaultValue: defaultValue,
                            decimalPlaces: decimalPlaces,
                            valueRestriction: valueRestriction,
                            suffix: valueSuffix,
                          )
                        : Text(value!, style: Fonts.black(size: 18)),
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
