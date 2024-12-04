import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';

import '../model/enchantment.dart' hide Level;
import 'partial/decoration/gradient_background.dart';

class EnchantmentPage extends StatefulWidget {
  const EnchantmentPage({super.key});

  @override
  State<EnchantmentPage> createState() => _EnchantmentPageState();
}

class _EnchantmentPageState extends State<EnchantmentPage> {
  @override
  Widget build(BuildContext context) {
    final enchantment =
        ModalRoute.of(context)!.settings.arguments as Enchantment;
    return Scaffold(
      backgroundColor: Palette.background,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundPurple),
          // Header + Body
          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(
                    top: Measures.vMarginBig,
                    bottom: Measures.vMarginSmall,
                    left: Measures.hPadding + 10,
                    right: Measures.hPadding + 10),
                child: Stack(alignment: Alignment.center, children: [
                  Column(children: [
                    Text(enchantment.name, style: Fonts.black(size: 18)),
                    Text(enchantment.type.title, style: Fonts.light(size: 16))
                  ]),
                ]),
              ),
              // Body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: Measures.vMarginSmall),

                      // Description card
                      GlassCard(
                        isFlat: true,
                        width: double.infinity,
                        clickable: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Measures.hPadding,vertical: Measures.vMarginSmall),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              descriptionEntry(
                                  key: 'Tempo di lancio',
                                  value: enchantment.launchTimeStr),
                              descriptionEntry(
                                  key: 'Gittata',
                                  value: enchantment.rangeStr),
                              descriptionEntry(
                                  key: 'Componenti',
                                  value: enchantment.componentsStr),
                              descriptionEntry(
                                  key: 'Durata',
                                  value: enchantment.durationStr),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Measures.vMarginSmall),
                      // Classes
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                    const SizedBox(width: Measures.hPadding)
                                        as Widget
                                  ] +
                                  List.generate(
                                      enchantment.classes.length,
                                      (i) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: RadioButton(
                                              onPressed: (){
                                                context.popup(enchantment.classes[i].title,
                                                    message: enchantment.classes[i].description,
                                                    positiveText: 'Ok',
                                                    backgroundColor: Palette
                                                        .background
                                                        .withOpacity(0.5));
                                              },
                                              color: Palette.primaryBlue,
                                              text:
                                                  enchantment.classes[i].title,
                                            ),
                                          )) +
                                  [
                                    const SizedBox(
                                        width: Measures.hPadding - 10)
                                  ]),
                        ),
                      ),
                      const SizedBox(height: Measures.vMarginSmall),
                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Measures.hPadding),
                        child: MarkdownBody(
                            data: enchantment.description,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                                p: Fonts.light(size: 16), listBullet: Fonts.light(size: 16))),
                      ),
                      const SizedBox(height: Measures.vMarginBig)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Chevron(),
              Padding(
                padding: const EdgeInsets.only(
                    top: Measures.vMarginBig, right: Measures.hPadding),
                child: Level(level: enchantment.level.num, maxLevel: 9),
              ),
            ],
          )
        ],
      ),
    );
  }

  descriptionEntry({required String key, required String value}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '$key: ', style: Fonts.bold()),
              TextSpan(text: value, style: Fonts.light(size: 16)),
            ],
          ),
        ),
      );
}
