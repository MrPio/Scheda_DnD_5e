import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../../../constant/palette.dart';

class SheetItemCard extends StatefulWidget {
  final String iconPath, text;
  final Color? iconColor;
  final String? value, subValue,valueSuffix;
  final Widget? child, popup;
  final int min, max,decimalPlaces;
  final TextEditingController? textEditingController;
  final double Function(double)? valueRestriction;

  final double? defaultValue;

  const   SheetItemCard(
      {super.key,
      required this.iconPath,
      this.iconColor,
      required this.text,
      this.value,
      this.subValue,
      this.child,
      this.popup,
      this.min = 0,
      this.max = 10,
      this.textEditingController, this.defaultValue, this.decimalPlaces=0, this.valueRestriction, this.valueSuffix});

  @override
  State<SheetItemCard> createState() => _SheetItemCardState();
}

class _SheetItemCardState extends State<SheetItemCard> {
  bool get isSmall => widget.value == null && widget.subValue == null;

  @override
  void initState() {
    if (widget.textEditingController != null) {
      widget.textEditingController!.text = widget.value.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheetHeader = widget.popup != null
        ? Column(
            children: [
              const SizedBox(height: Measures.vMarginThin),
              Text(widget.text, style: Fonts.bold(size: 18)),
              const SizedBox(height: Measures.vMarginMed),
              widget.popup!,
              const SizedBox(
                  height: Measures.vMarginMed + Measures.vMarginSmall),
            ],
          )
        : null;
    return GlassCard(
      height: isSmall ? Measures.sheetCardSmallHeight : null,
      clickable: widget.popup != null,
      bottomSheetHeader: bottomSheetHeader,
      onTap: () {
        context.bottomSheet(header: bottomSheetHeader);
        // context.popup('Modifica $text',
        //     backgroundColor: Palette.background.withOpacity(0.5), child: popup);
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
                widget.iconPath.toIcon(
                    height: 15,
                    color: widget.iconColor ?? Palette.onBackground),
                SizedBox(
                    width:
                        isSmall ? Measures.hMarginSmall : Measures.hMarginThin),
                Flexible(
                  child: Text(
                    widget.text,
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
            if (widget.value != null)
              Padding(
                padding: const EdgeInsets.only(top: Measures.vMarginMoreThin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.textEditingController != null
                        ? NumericInput(
                            widget.min,
                            widget.max,
                            controller: widget.textEditingController!,
                            style: Fonts.black(size: 18),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                      defaultValue: widget.defaultValue,
                      decimalPlaces: widget.decimalPlaces,
                      valueRestriction: widget.valueRestriction,
                      suffix: widget.valueSuffix,
                          )
                        : Text(widget.value!, style: Fonts.black(size: 18)),
                    if (widget.subValue != null)
                      Text('(${widget.subValue})', style: Fonts.light()),
                  ],
                ),
              ),
            if (widget.child != null)
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Measures.vMarginMoreThin),
                child: Rule(),
              ),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}
