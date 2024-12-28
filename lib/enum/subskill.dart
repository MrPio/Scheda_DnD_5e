import 'package:scheda_dnd_5e/enum/skill.dart';

import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';

@Localized(['title'])
enum SubSkill implements EnumWithTitle {
  // Forza
  atletica,
  // Destrezza
  acrobazia,
  furtivita,
  rapiditaDiMano,
  // Intelligenza
  arcano,
  storia,
  indagare,
  natura,
  religione,
  // Saggezza
  addestrareAnimali,
  intuizione,
  medicina,
  percezione,
  sopravvivenza,
  // Carisma
  inganno,
  intimidire,
  intrattenere,
  persuasione;

  Skill get skill => Skill.values.firstWhere((e) => e.subSkills.contains(this));
}
