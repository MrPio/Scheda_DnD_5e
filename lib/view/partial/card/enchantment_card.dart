import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart' hide Level;

import '../../../constant/fonts.dart';
import '../../../constant/measures.dart';
import '../../../extension_function/context_extensions.dart';
import '../clickable.dart';
import '../glass_card.dart';
import '../level.dart';

class EnchantmentCard extends StatelessWidget {
  final Enchantment enchantment;

  const EnchantmentCard(this.enchantment, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GlassCard(
          bottomSheetArgs: BottomSheetArgs(
              header: Row(
                children: [
                  Level(level: enchantment.level.num, maxLevel: 9),
                  const SizedBox(width: Measures.hMarginBig),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(enchantment.name, style: Fonts.bold()),
                      Text(enchantment.type.title, style: Fonts.light()),
                    ],
                  )
                ],
              ),
              items: [
                BottomSheetItem('png/open', 'Visualizza dettagli',
                    () => Navigator.of(context).pushNamed('/enchantment', arguments: enchantment)),
              ]),
          onTap: () => Navigator.of(context).pushNamed('/enchantment', arguments: enchantment),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and type
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(child: Text(enchantment.name, style: Fonts.bold())),
                      Text(enchantment.type.title, style: Fonts.light()),
                    ],
                  ),
                ),
                const SizedBox(width: Measures.hMarginMed),
                // Level
                Level(level: enchantment.level.num, maxLevel: 9),
              ],
            ),
          ),
        ),
      );
}
