import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';

import '../model/character.dart' hide Alignment;
import 'partial/gradient_background.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context)!.settings.arguments as Character;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundBlue),
          // Header + Body
          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: Measures.vMarginBig),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    Text(character.name, style: Fonts.black(size: 20)),
                    Text(
                        character.subRace == null
                            ? character.race.title
                            : '${character.subRace!.title} (${character.race.title})',
                        style: Fonts.light(size: 16))
                  ]),
                ),
              ),
              // Body
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: Measures.vMarginSmall),
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
                child: Level(level: character.level, maxLevel: 10),
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
              TextSpan(text: '$key: ', style: Fonts.bold(size: 18)),
              TextSpan(text: value, style: Fonts.light(size: 18)),
            ],
          ),
        ),
      );
}
