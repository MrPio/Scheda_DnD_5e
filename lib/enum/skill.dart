import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/subskill.dart';

import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';

@Localized(['title', 'description'])
enum Skill implements EnumWithTitle {
  forza('png/strength', Color(0xFFe5737c), [SubSkill.atletica]),
  destrezza('png/dexterity', Color(0xFFe5ac73), [
    SubSkill.acrobazia,
    SubSkill.furtivita,
    SubSkill.rapiditaDiMano,
  ]),
  costituzione('png/costitution', Color(0xFFe5e573), []),
  intelligenza('png/intelligence', Color(0xFF6cd9a2), [
    SubSkill.arcano,
    SubSkill.storia,
    SubSkill.indagare,
    SubSkill.natura,
    SubSkill.religione,
  ]),
  saggezza('png/wisdom', Color(0xFF7979f2), [
    SubSkill.addestrareAnimali,
    SubSkill.intuizione,
    SubSkill.medicina,
    SubSkill.percezione,
    SubSkill.sopravvivenza,
  ]),
  carisma('png/carisma', Color(0xFFd273e5), [
    SubSkill.inganno,
    SubSkill.intimidire,
    SubSkill.intrattenere,
    SubSkill.persuasione,
  ]);

  final String iconPath;
  final List<SubSkill> subSkills;
  final Color color;

  const Skill(this.iconPath, this.color, this.subSkills);
}
