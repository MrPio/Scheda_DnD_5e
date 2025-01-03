import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/class.dart';
import 'package:scheda_dnd_5e/enum/class.localized.g.part';
import 'package:scheda_dnd_5e/enum/mastery.localized.g.part';
import 'package:scheda_dnd_5e/enum/skill.localized.g.part';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';

import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../../../constant/palette.dart';
import '../clickable.dart';
import '../glass_card.dart';
import '../radio_button.dart';

class ClassCard extends StatelessWidget {
  final Function()? onTap;
  final Class class_;

  const ClassCard(this.class_, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    descriptionPopup() => context.popup(class_.title(context),
        message: class_.description(context),
        positiveText: 'Ok',
        backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2));
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        class_.iconPath.toIcon(height: 24),
        const SizedBox(width: Measures.hMarginMed),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(class_.title(context), style: Fonts.bold()),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(class_.subClassesInfo(context), style: Fonts.light(size: 14)),
              ),
            ],
          ),
        ),
        const SizedBox(width: Measures.hMarginBig),
      ],
    );
    return GlassCard(
      bottomSheetArgs: BottomSheetArgs(
          header: header, items: [BottomSheetItem('info', 'Leggi descrizione', descriptionPopup)]),
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Measures.hMarginMed),
            child: Column(
              children: [
                // Title, description and info button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Measures.hMarginBig),
                  child: header,
                ),
                const SizedBox(height: Measures.vMarginThin),
                // Saving throws
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [const SizedBox(width: Measures.hMarginBig)].cast<Widget>() +
                          (class_.savingThrows.isEmpty
                              ? [
                                  const RadioButton(
                                    text: 'Nessuna',
                                    color: Palette.primaryBlue,
                                    isSmall: true,
                                    width: 100,
                                  )
                                ]
                              : class_.savingThrows
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(right: 6.0),
                                        child: RadioButton(
                                          text: e.title(context),
                                          color: Palette.primaryYellow,
                                          isSmall: true,
                                          width: 100,
                                        ),
                                      ))
                                  .toList()),
                    ),
                  ),
                ),
                const SizedBox(height: Measures.vMarginThin),
                // Masteries
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [const SizedBox(width: Measures.hMarginBig)].cast<Widget>() +
                          (class_.defaultMasteries.isEmpty
                              ? [
                                  const RadioButton(
                                    text: 'Nessuna',
                                    color: Palette.primaryBlue,
                                    isSmall: true,
                                    width: 100,
                                  )
                                ]
                              : class_.defaultMasteries
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(right: 6.0),
                                        child: RadioButton(
                                          text: e.title(context),
                                          color: Palette.primaryBlue,
                                          isSmall: true,
                                          width: 100,
                                        ),
                                      ))
                                  .toList()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: Measures.hMarginSmall, right: Measures.hMarginSmall),
              child: 'info'.toIcon(onTap: descriptionPopup, padding: const EdgeInsets.all(12)),
            ),
          )
        ],
      ),
    );
  }
}
