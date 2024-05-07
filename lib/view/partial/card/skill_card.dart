import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/model/character.dart' as ch show Alignment;

import '../../../model/character.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;
  final void Function(Skill)? onTap;

  const SkillCard(this.skill, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      clickable: false,
      height: Measures.skillCardHeight,
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Measures.hMarginMed, vertical: Measures.hMarginMed),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      skill.iconPath.toIcon(),
                      const SizedBox(width: Measures.hMarginSmall),
                      Text(skill.title,
                          style: Fonts.regular(size: 14),
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                  Row(
                    children: [
                      skill.iconPath.toIcon(),
                      const SizedBox(width: Measures.hMarginSmall),
                      Text(skill.title,
                          style: Fonts.regular(size: 14),
                          overflow: TextOverflow.ellipsis)
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
                    padding: const EdgeInsets.all(10)),
                'info'.toIcon(
                    onTap: () {
                      context.popup(skill.title,
                          message: skill.description,
                          positiveText: 'Ok',
                          backgroundColor: Palette.background.withOpacity(0.5));
                    },
                    padding: const EdgeInsets.all(10))
              ],
            ),
          )
        ],
      ),
    );
  }
}
