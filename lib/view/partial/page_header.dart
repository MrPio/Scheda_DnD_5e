import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

import '../../constant/fonts.dart';
import '../../constant/measures.dart';

class PageHeader extends StatelessWidget {
  final bool isPage;
  final String title;
  final Widget? rightIcon;

  /// The header of a widget that can act as both a screen and a page.
  ///
  /// Displays the [title], with a chevron on the left if [isPage] and the [rightIcon] on the right.
  /// When [isPage], restricts the title to a single line of text.
  const PageHeader({required this.title, this.isPage = false, this.rightIcon, super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: Measures.vMarginBig + (!isPage ? Measures.vMarginMed : -Measures.vMarginThin)),
          Stack(children: [
            if (isPage)
              Align(
                  child: Padding(
                padding: EdgeInsets.only(
                    top: Measures.vMarginThin,
                    bottom: Measures.vMarginThin,
                    left: Measures.hPadding * 2 + Measures.hMarginMed,
                    right: (rightIcon != null ? Measures.hMarginBig : 0)),
                child: Text(title, style: Fonts.black(size: 18), overflow: TextOverflow.ellipsis),
              ))
            else
              Padding(
                padding: EdgeInsets.only(right: (rightIcon != null ? Measures.hMarginBig * 2 : 0)),
                child: Align(alignment: Alignment.centerLeft, child: Text(title, style: Fonts.black())),
              ),
            // Chevron on the left
            if (isPage)
              Align(
                alignment: Alignment.centerLeft,
                child: 'chevron_left'.toIcon(onTap: ()=>context.pop(), padding: Measures.chevronPadding),
              ),
            // Child on the right
            if (rightIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: Measures.hPadding),
                child: Align(alignment: Alignment.centerRight, child: rightIcon),
              ),
          ]),
          SizedBox(height: isPage ? Measures.vMarginSmall : Measures.vMarginMed),
        ],
      );
}
