import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/view/gradient/glass_card.dart';
import 'package:scheda_dnd_5e/view/gradient/gradient_background.dart';

class DicePage extends StatelessWidget {
  const DicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundGreen),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
            child: Column(
              children: [
                // Header
                const SizedBox(height: Measures.vMarginBig),
                Align(
                  alignment: Alignment.center,
                  child: Text('Dadi', style: Fonts.bold()),
                ),
                const SizedBox(height: Measures.vMarginSmall),
                // Body
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Selected dice ===============================
                        SizedBox(height: Measures.vMarginSmall),
                        GlassCard(height: 240),
                        SizedBox(height: Measures.vMarginSmall),
                        // D4, D6, D8 dice ===============================
                        Row(
                          children: [
                            Expanded(
                                child: GlassCard(height: Measures.diceCardHeight)),
                            SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: GlassCard(height: Measures.diceCardHeight)),
                            SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: GlassCard(height: Measures.diceCardHeight)),
                          ],
                        ),
                        SizedBox(height: Measures.vMarginThin),
                        //  D10, D12, D100 dice
                        Row(
                          children: [
                            Expanded(
                                child: GlassCard(height: Measures.diceCardHeight)),
                            SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: GlassCard(height: Measures.diceCardHeight)),
                            SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: GlassCard(height: Measures.diceCardHeight)),
                          ],
                        ),
                        SizedBox(height: Measures.vMarginThin),
                        // D20 Dice ===============================
                        GlassCard(height: Measures.diceCardHeight),
                        SizedBox(height: Measures.vMarginSmall),
                        GlassCard(height: 150),
                        SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Measures.bottomButtonMargin),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shadowColor: Palette.primaryGreen,
                      elevation: 12,
                    ),
                    child: Text('LANCIA', style: Fonts.button()),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
