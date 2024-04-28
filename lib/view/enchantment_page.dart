import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';

import '../model/enchantment.dart';
import 'partial/gradient_background.dart';

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
      backgroundColor: Colors.transparent,
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
                    Text(enchantment.name, style: Fonts.black(size: 20)),
                    Text(enchantment.type.title, style: Fonts.light(size: 16))
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent ,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: 'chevron_left'.toIcon(height: 24),
                      ),
                    ],
                  ),
                ]),
              ),
              // Body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: Measures.vMarginSmall),
                      // Description card
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Measures.hPadding),
                        child: GlassCard(
                            width: double.infinity,
                            clickable: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
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
                            )),
                      ),
                      const SizedBox(height: Measures.vMarginSmall),
                      // Classes
                      // TODO: Class page opens onTap
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
                                p: Fonts.light(), listBullet: Fonts.light())),
                      ),
                      const SizedBox(height: Measures.vMarginBig)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  descriptionEntry({required String key, required String value}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '$key: ', style: Fonts.bold(size: 18)),
              TextSpan(text: value, style: Fonts.light(size: 18)),
            ],
          ),
        ),
      );
}
