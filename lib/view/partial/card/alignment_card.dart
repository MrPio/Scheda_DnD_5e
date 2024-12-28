import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/enum/character_alignment.dart';
import 'package:scheda_dnd_5e/enum/character_alignment.localized.g.part';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';

class AlignmentCard extends StatelessWidget {
  final CharacterAlignment alignment;
  final void Function(CharacterAlignment)? onTap;
  final bool isSmall;

  const AlignmentCard(this.alignment, {super.key, this.onTap, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => onTap?.call(alignment),
      height: isSmall ? Measures.alignmentCardSmallHeight : Measures.alignmentCardHeight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Measures.hMarginMed),
            child: Align(
              alignment: isSmall ? Alignment.center : Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isSmall ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: alignment.fullInitials
                    .map((e) => Text(e,
                        style: Fonts.regular(size: isSmall ? 14 : 13), overflow: TextOverflow.ellipsis))
                    .toList(),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: 'info'.toIcon(
                onTap: () {
                  context.popup(alignment.title(context),
                      message: alignment.description(context),
                      positiveText: 'Ok',
                      backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2));
                },
                padding: const EdgeInsets.all(10)),
          )
        ],
      ),
    );
  }
}
