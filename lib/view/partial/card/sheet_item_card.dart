import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../../../constant/palette.dart';

class SheetItemCard extends StatefulWidget {
  final String iconPath, text;
  final Color? iconColor;
  final String? value, subValue;
  final Widget? child;
  final BottomSheetArgs? bottomSheetArgs;
  final NumericInputArgs? numericInputArgs;
  final Function()? onTap;

  SheetItemCard(
      {super.key,
      required this.iconPath,
      this.iconColor,
      required this.text,
      this.value,
      this.subValue,
      this.child,
      this.bottomSheetArgs,
      this.numericInputArgs,
      this.onTap}) {
    if (numericInputArgs != null && numericInputArgs!.controller != null) {
      numericInputArgs!.controller!.text = value.toString();
    }
  }

  @override
  State<SheetItemCard> createState() => _SheetItemCardState();
}

class _SheetItemCardState extends State<SheetItemCard> {
  bool get isSmall => widget.value == null && widget.subValue == null;
bool isShimmer=true;

@override
  void initState() {
    Future.delayed(Durations.medium2,()=>setState(()=>isShimmer=false));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final newBottomSheetArgs = widget.bottomSheetArgs != null
        ? BottomSheetArgs(
            header: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: Measures.vMarginThin),
                  Text(widget.text, style: Fonts.bold(size: 18)),
                  if (widget.bottomSheetArgs?.header != null) const SizedBox(height: Measures.vMarginMed),
                  if (widget.bottomSheetArgs?.header != null) widget.bottomSheetArgs!.header!,
                  if (widget.bottomSheetArgs?.header != null)
                    const SizedBox(height: Measures.vMarginMed + Measures.vMarginSmall),
                ],
              ),
            ),
            items: widget.bottomSheetArgs?.items)
        : null;
    return GlassCard(
      isShimmer: isShimmer,
      shimmerHeight: 60,
      height: isSmall ? Measures.sheetCardSmallHeight : null,
      clickable: widget.bottomSheetArgs != null || widget.onTap != null,
      bottomSheetArgs: newBottomSheetArgs,
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: isSmall ? 0 : Measures.vMarginThin, horizontal: isSmall ? Measures.hMarginMed : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon + title
            Row(
              mainAxisAlignment: isSmall ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                widget.iconPath.toIcon(height: 15, color: widget.iconColor ?? Palette.onBackground),
                SizedBox(width: isSmall ? Measures.hMarginSmall : Measures.hMarginThin),
                Flexible(
                  child: Text(
                    widget.text,
                    style: Fonts.regular(size: 13),
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior: isSmall
                        ? const TextHeightBehavior(
                            applyHeightToFirstAscent: false, applyHeightToLastDescent: false)
                        : null,
                    maxLines: isSmall ? 2 : 1,
                  ),
                )
              ],
            ),
            // Value + subValue
            if (widget.value != null)
              Padding(
                padding: const EdgeInsets.only(top: Measures.vMarginMoreThin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.numericInputArgs != null
                        ? NumericInput(
                            widget.numericInputArgs!
                              ..style = Fonts.black(size: 18)
                              ..isDense = true
                              ..contentPadding = EdgeInsets.zero,
                          )
                        : Text(widget.value!, style: Fonts.black(size: 18)),
                    if (widget.subValue != null) Text('(${widget.subValue})', style: Fonts.light()),
                  ],
                ),
              ),
            if (widget.child != null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Measures.vMarginMoreThin),
                child: Rule(),
              ),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}
