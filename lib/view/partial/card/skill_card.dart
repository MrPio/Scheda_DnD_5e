import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/dice_page.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/model/character.dart' as ch show Alignment;
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';

import '../../../model/character.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;
  final TextEditingController skillInputController;
  final int raceSkill; // The contribute given by the race and subRace selection
  const SkillCard(this.skill,
      {super.key, required this.skillInputController, required this.raceSkill});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      clickable: false,
      height: Measures.skillCardHeight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Measures.hMarginMed, vertical: Measures.hMarginMed),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + Title
                  Row(
                    children: [
                      skill.iconPath.toIcon(color: skill.color),
                      const SizedBox(width: Measures.hMarginSmall),
                      Text(skill.title,
                          style: Fonts.regular(size: 14),
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                  // value
                  Row(
                    children: [
                      NumericInput(NumericInputArgs(
                          min: 3,
                          max: 18,
                          controller: skillInputController,
                          width: 50,
                          isDense: true,
                          style: Fonts.black())),
                      Text('+ $raceSkill', style: Fonts.light(size: 16)),
                    ],
                  )
                ]),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'info'.toIcon(
                    onTap: () {
                      context.popup(skill.title,
                          message: skill.description,
                          positiveText: 'Ok',
                          backgroundColor: Palette.background.withOpacity(0.5));
                    },
                    padding: const EdgeInsets.all(8)),
                'png/dice_on'.toIcon(
                    onTap: () async {
                      int? result = await Navigator.of(context).pushNamed(
                          '/dice',
                          arguments: DiceArgs(
                              title: 'Lancio per ${skill.title}',
                              dices: List.filled(3, Dice.d6),
                              modifier: 0,
                              oneShot: true)) as int?;
                      if (result != null) {
                        skillInputController.text = result.toString();
                      }
                    },
                    padding: const EdgeInsets.all(8))
              ],
            ),
          )
        ],
      ),
    );
  }
}
