import 'package:flutter/cupertino.dart';

import '../enum/character_alignment.dart';
import '../enum/character_alignment.localized.g.part';
import '../enum/character_background.dart';
import '../enum/character_background.localized.g.part';
import '../enum/class.dart';
import '../enum/class.localized.g.part';
import '../enum/language.dart';
import '../enum/language.localized.g.part';
import '../enum/mastery.dart';
import '../enum/mastery.localized.g.part';
import '../enum/mastery_type.dart';
import '../enum/mastery_type.localized.g.part';
import '../enum/race.dart';
import '../enum/race.localized.g.part';
import '../enum/skill.dart';
import '../enum/skill.localized.g.part';
import '../enum/status.dart';
import '../enum/status.localized.g.part';
import '../enum/subclass.dart';
import '../enum/subclass.localized.g.part';
import '../enum/subrace.dart';
import '../enum/subrace.localized.g.part';
import '../enum/subskill.dart';
import '../enum/subskill.localized.g.part';

abstract class WithTitle {
  final String title = '';
}

abstract class EnumWithTitle implements Enum {
  // String title(BuildContext context)=>'';
  static Map<Type, String Function(Enum, BuildContext)> titles = {
    CharacterAlignment: (Enum e, BuildContext c) => (e as CharacterAlignment).title(c),
    CharacterBackground: (Enum e, BuildContext c) => (e as CharacterBackground).title(c),
    Class: (Enum e, BuildContext c) => (e as Class).title(c),
    SubClass: (Enum e, BuildContext c) => (e as SubClass).title(c),
    Race: (Enum e, BuildContext c) => (e as Race).title(c),
    SubRace: (Enum e, BuildContext c) => (e as SubRace).title(c),
    Skill: (Enum e, BuildContext c) => (e as Skill).title(c),
    SubSkill: (Enum e, BuildContext c) => (e as SubSkill).title(c),
    Status: (Enum e, BuildContext c) => (e as Status).title(c),
    Language: (Enum e, BuildContext c) => (e as Language).title(c),
    Mastery: (Enum e, BuildContext c) => (e as Mastery).title(c),
    MasteryType: (Enum e, BuildContext c) => (e as MasteryType).title(c),
    // Level and others...
  };
}
