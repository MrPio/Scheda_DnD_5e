import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/map_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/set_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/legend.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';

import '../enum/fonts.dart';
import '../enum/measures.dart';
import '../enum/palette.dart';
import '../mixin/validable.dart';
import '../model/character.dart' hide Alignment;

class CreateCharacterPage extends StatefulWidget {
  const CreateCharacterPage({super.key});

  @override
  State<CreateCharacterPage> createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage>
    with Validable {
  List<Character?> characters = [Character(), null, null, null, null];

  Character get character => characters[_index]!;

  late final PageController _pageController;
  late final TextEditingController _nameController;

  List<Widget>? _screens;

  final _hasBottomButton = [true, false, false, false, false, false, false];
  int _index = 0;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _index = _pageController.page?.toInt() ?? 0;
        });
      });
    _nameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screens /*TODO: add ??*/ = [
      // Choose name
      Column(children: [
        // Page Title
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Assegna un nome', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginMed),
        // Search TextField
        GlassTextField(
          iconPath: 'search_alt',
          hintText: 'Il nome del personaggio',
          textController: _nameController,
          autofocus: true,
          onSubmitted: (text) {
            if (validate(() => character.name = text)) {
              next();
            }
          },
          textInputAction: TextInputAction.next,
        ),
      ]),
      // Select race
      Column(children: [
        // Page Title
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Seleziona la razza', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginMed),
        // Legend
        const Legend(items: {
          'Linguaggi': Palette.primaryGreen,
          'Punti caratteristica': Palette.primaryYellow
        }),
        const SizedBox(height: Measures.vMarginMed),
        // Races cards
        Column(
            children: Race.values
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: Measures.vMarginThin),
                          child: Stack(
                            children: [
                              GlassCard(
                                onTap: () async {
                                  // Set race fields
                                  character.race = e;
                                  character.languages =
                                      e.defaultLanguages.toSet();
                                  character.masteries.clear();
                                  character.skills = e.defaultSkills;
                                  character.subSkills.clear();
                                  // Ask the possible choices before continuing
                                  if (e.canChoiceLanguage) {
                                    final languages = Language.values
                                        .where((language) => !e.defaultLanguages
                                            .contains(language))
                                        .toList()
                                      ..sort(
                                          (a, b) => a.title.compareTo(b.title));
                                    character.languages.add(languages[0]);
                                    await context.checkList<Language>(
                                      'Scegli un linguaggio',
                                      dismissible: false,
                                      isRadio: true,
                                      values: languages,
                                      color: Palette.primaryGreen,
                                      onChanged: (value) =>
                                          character.languages =
                                              (e.defaultLanguages + [value])
                                                  .toSet(),
                                      value: (value) =>
                                          character.languages.contains(value),
                                    );
                                  }
                                  if (e.choiceableMasteries.isNotEmpty) {
                                    character.masteries = {
                                      e.choiceableMasteries[0]
                                    };
                                    await context.checkList<Mastery>(
                                      'Scegli una maestria',
                                      dismissible: false,
                                      isRadio: true,
                                      values: e.choiceableMasteries,
                                      color: Palette.primaryBlue,
                                      onChanged: (value) =>
                                          character.masteries = {value},
                                      value: (value) =>
                                          character.masteries.contains(value),
                                    );
                                  }
                                  if (e.numChoiceableSkill > 0) {
                                    Skill.values
                                        .sublist(0, e.numChoiceableSkill)
                                        .forEach((skill) =>
                                            character.skills += {skill: 1});
                                    await context.checkList<Skill>(
                                      'Scegli ${e.numChoiceableSkill} competenza/e a cui assegnare +1',
                                      dismissible: false,
                                      isRadio: e.numChoiceableSkill == 1,
                                      values: Skill.values,
                                      color: Palette.primaryYellow,
                                      onChanged: (value) {
                                        var selected =
                                            character.skills - e.defaultSkills;
                                        if (selected.containsKey(value)) {
                                          character.skills -= {value: 1};
                                        } else if (selected.isEmpty ||
                                            selected.values.toList().sum() <
                                                e.numChoiceableSkill) {
                                          character.skills += {value: 1};
                                        }
                                      },
                                      value: (value) =>
                                          character.skills[value] ==
                                          (e.defaultSkills[value] ?? 0) + 1,
                                    );
                                  }
                                  if (e.numChoiceableSubSkill > 0) {
                                    SubSkill.values
                                        .sublist(0, e.numChoiceableSkill)
                                        .forEach((subSkill) => character
                                            .subSkills += {subSkill: 1});
                                    await context.checkList<SubSkill>(
                                      'Scegli ${e.numChoiceableSubSkill} sottocompetenza/e',
                                      dismissible: false,
                                      isRadio: e.numChoiceableSubSkill == 1,
                                      values: SubSkill.values,
                                      color: Palette.primaryYellow,
                                      onChanged: (value) {
                                        if (character.subSkills
                                            .containsKey(value)) {
                                          character.subSkills -= {value: 1};
                                        } else if (character
                                                .subSkills.isEmpty ||
                                            character.subSkills.values
                                                    .toList()
                                                    .sum() <
                                                e.numChoiceableSubSkill) {
                                          character.subSkills += {value: 1};
                                        }
                                      },
                                      value: (value) =>
                                          character.subSkills[value] == 1,
                                    );
                                  }
                                  next(step: e.subRaces.isEmpty ? 2 : 1);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Measures.hMarginMed),
                                  child: Column(
                                    children: [
                                      // Title, description and info button
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Measures.hMarginBig),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.title,
                                                      style:
                                                          Fonts.bold(size: 16)),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(e.subRacesInfo,
                                                        style: Fonts.light(
                                                            size: 14)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                width: Measures.hMarginBig),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height: Measures.vMarginThin),
                                      // Languages
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                                  const SizedBox(
                                                      width:
                                                          Measures.hMarginBig)
                                                ].cast<Widget>() +
                                                (e.defaultLanguages.isEmpty
                                                    ? [
                                                        const RadioButton(
                                                          text: 'Nessuna',
                                                          color: Palette
                                                              .primaryGreen,
                                                          isSmall: true,
                                                          width: 100,
                                                        )
                                                      ]
                                                    : e.defaultLanguages
                                                        .map((e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          6.0),
                                                              child:
                                                                  RadioButton(
                                                                text: e.title,
                                                                color: Palette
                                                                    .primaryGreen,
                                                                isSmall: true,
                                                                width: 100,
                                                              ),
                                                            ))
                                                        .toList()) +
                                                (e.canChoiceLanguage
                                                    ? [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 6.0),
                                                          child: RadioButton(
                                                            text:
                                                                '+ 1 a scelta',
                                                            color: Palette
                                                                .primaryGreen,
                                                            isSmall: true,
                                                            width: 100,
                                                          ),
                                                        )
                                                      ]
                                                    : []),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: Measures.vMarginThin),
                                      // Skills
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                                  const SizedBox(
                                                      width:
                                                          Measures.hMarginBig)
                                                ].cast<Widget>() +
                                                (e.defaultSkills.isEmpty
                                                    ? [
                                                        const RadioButton(
                                                          text: 'Nessuna',
                                                          color: Palette
                                                              .primaryYellow,
                                                          isSmall: true,
                                                          width: 100,
                                                        )
                                                      ]
                                                    : e.defaultSkills.entries
                                                        .map((e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          6.0),
                                                              child:
                                                                  RadioButton(
                                                                text:
                                                                    '${e.key.title} +${e.value}',
                                                                color: Palette
                                                                    .primaryYellow,
                                                                isSmall: true,
                                                                width: 100,
                                                              ),
                                                            ))
                                                        .toList()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Info button
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: Measures.hMarginSmall,
                                      right: Measures.hMarginSmall),
                                  child: 'info'.toIcon(
                                      onTap: () {
                                        context.popup(e.title,
                                            message: e.description,
                                            positiveText: 'Ok',
                                            backgroundColor: Palette.background
                                                .withOpacity(0.5));
                                      },
                                      padding: const EdgeInsets.all(12)),
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList()
                    .cast<Widget>() +
                [const SizedBox(height: Measures.vMarginBig)]),
      ]),
      // Select subRace
      Column(children: [
        // Page Title
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Seleziona la sottorazza', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginMed),
        // Legend
        const Legend(items: {
          'Punti caratteristica': Palette.primaryYellow,
          'Maestrie': Palette.primaryBlue
        }),
        const SizedBox(height: Measures.vMarginMed),
        // SubRaces cards
        Column(
            children: character.race.subRaces.isEmpty
                ? [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: Measures.vMarginSmall),
                      child: Text('Niente da mostrare',
                          style: Fonts.black(color: Palette.card2)),
                    )
                  ]
                : character.race.subRaces
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Measures.vMarginThin),
                              child: Stack(
                                children: [
                                  GlassCard(
                                    onTap: () async {
                                      // Set subRace fields
                                      character.subRace = e;
                                      character.skills += e.defaultSkills;
                                      character.masteries
                                          .addAll(e.defaultMasteries);
                                      Set<Language> backupLanguages =
                                          Set.from(character.languages);
                                      // Ask the possible choices before continuing
                                      if (e.numChoiceableLanguages > 0) {
                                        final languages = Language.values
                                            .where((language) => !character
                                                .languages
                                                .contains(language))
                                            .toList()
                                          ..sort((a, b) =>
                                              a.title.compareTo(b.title));
                                        character.languages.addAll(
                                            languages.sublist(
                                                0, e.numChoiceableLanguages));
                                        await context.checkList<Language>(
                                          'Scegli ${e.numChoiceableLanguages} linguaggio/i',
                                          dismissible: false,
                                          isRadio:
                                              e.numChoiceableLanguages == 1,
                                          values: languages,
                                          color: Palette.primaryGreen,
                                          onChanged: (value) {
                                            if (e.numChoiceableLanguages > 1 &&
                                                character.languages
                                                    .contains(value)) {
                                              character.languages.remove(value);
                                            } else if (e.numChoiceableLanguages ==
                                                    1 &&
                                                !character.languages
                                                    .contains(value)) {
                                              character.languages.clear();
                                              character.languages.addAll(
                                                  backupLanguages + {value});
                                            } else if (character
                                                        .languages.length -
                                                    backupLanguages.length <
                                                e.numChoiceableLanguages) {
                                              character.languages.add(value);
                                            }
                                          },
                                          value: (value) => character.languages
                                              .contains(value),
                                        );
                                      }
                                      next();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: Measures.hMarginMed),
                                      child: Column(
                                        children: [
                                          // Title, description and info button
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    Measures.hMarginBig),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(e.title,
                                                          style: Fonts.bold(
                                                              size: 16)),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                            e.race.title,
                                                            style: Fonts.light(
                                                                size: 14)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Measures.hMarginBig),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                              height: Measures.vMarginThin),
                                          // Skills
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                      const SizedBox(
                                                          width: Measures
                                                              .hMarginBig)
                                                    ].cast<Widget>() +
                                                    (e.defaultSkills.isEmpty
                                                        ? [
                                                            const RadioButton(
                                                              text: 'Nessuna',
                                                              color: Palette
                                                                  .primaryBlue,
                                                              isSmall: true,
                                                              width: 100,
                                                            )
                                                          ]
                                                        : e.defaultSkills
                                                            .entries
                                                            .map((e) => Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              6.0),
                                                                  child:
                                                                      RadioButton(
                                                                    text:
                                                                        '${e.key.title} +${e.value}',
                                                                    color: Palette
                                                                        .primaryYellow,
                                                                    isSmall:
                                                                        true,
                                                                    width: 100,
                                                                  ),
                                                                ))
                                                            .toList()),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              height: Measures.vMarginThin),
                                          // Masteries
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                      const SizedBox(
                                                          width: Measures
                                                              .hMarginBig)
                                                    ].cast<Widget>() +
                                                    (e.defaultMasteries.isEmpty
                                                        ? [
                                                            const RadioButton(
                                                              text: 'Nessuna',
                                                              color: Palette
                                                                  .primaryBlue,
                                                              isSmall: true,
                                                              width: 100,
                                                            )
                                                          ]
                                                        : e.defaultMasteries
                                                            .map((e) => Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              6.0),
                                                                  child:
                                                                      RadioButton(
                                                                    text:
                                                                        e.title,
                                                                    color: Palette
                                                                        .primaryBlue,
                                                                    isSmall:
                                                                        true,
                                                                    width: 100,
                                                                  ),
                                                                ))
                                                            .toList()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Info button
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: Measures.hMarginSmall,
                                          right: Measures.hMarginSmall),
                                      child: 'info'.toIcon(
                                          onTap: () {
                                            context.popup(e.title,
                                                message: e.description,
                                                positiveText: 'Ok',
                                                backgroundColor: Palette
                                                    .background
                                                    .withOpacity(0.5));
                                          },
                                          padding: const EdgeInsets.all(12)),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        .toList()
                        .cast<Widget>() +
                    [const SizedBox(height: Measures.vMarginBig)]),
      ]),
      // Select class
      Column(children: [
        // Page Title
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Seleziona la classe', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginMed),
        // Legend
        const Legend(items: {
          'Tiri salvezza': Palette.primaryYellow,
          'Maestrie': Palette.primaryBlue
        }),
        const SizedBox(height: Measures.vMarginMed),
        // Classes cards
        Column(
            children: Class.values
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: Measures.vMarginThin),
                          child: Stack(
                            children: [
                              GlassCard(
                                onTap: () async {
                                  // Set class fields
                                  character.class_ = e;
                                  character.masteries
                                      .addAll(e.defaultMasteries);
                                  character.savingThrows
                                      .addAll(e.savingThrowSkills);
                                  Map<Skill, int> backupSkills =
                                      Map.from(character.skills);
                                  Map<SubSkill, int> backupSubSkills =
                                      Map.from(character.subSkills);
                                  // Ask the possible choices before continuing
                                  if (e.numChoiceableSubSkills > 0) {
                                    character.skills+=Skill.values.sublist(0,e.numChoiceableSubSkills).map((e) => {e:1}).reduce((value, element) => value+element);
                                    await context.checkList<Skill>(
                                      'Scegli ${e.numChoiceableSubSkills} competenza/e',
                                      dismissible: false,
                                      isRadio: e.numChoiceableSubSkills == 1,
                                      values: Skill.values,
                                      color: Palette.primaryYellow,
                                      onChanged: (value) {

                                        /*TODO
                                        var selected =
                                            character.skills - e.defaultSkills;
                                        if (selected.containsKey(value)) {
                                          character.skills -= {value: 1};
                                        } else if (selected.isEmpty ||
                                            selected.values.toList().sum() <
                                                e.numChoiceableSkill) {
                                          character.skills += {value: 1};
                                        }
                                        */

                                        // if (e.numChoiceableSkills > 1 &&
                                        //     character.skills
                                        //         .contains(value)) {
                                        //   character.subSkills.remove(value);
                                        // } else if (e.numChoiceableSkills == 1 &&
                                        //     !character.subSkills
                                        //         .contains(value)) {
                                        //   character.subSkills.clear();
                                        //   character.subSkills.addAll(
                                        //       backupSkills + {value});
                                        // } else if (character.subSkills.length -
                                        //     backupSkills.length <
                                        //     e.numChoiceableSkills) {
                                        //   character.subSkills.add(value);
                                        // }
                                      },
                                      value: (value) =>
                                      character.skills[value] ==
                                          (backupSkills[value] ?? 0) + 1,
                                    );
                                  }
                                  next();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Measures.hMarginMed),
                                  child: Column(
                                    children: [
                                      // Title, description and info button
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Measures.hMarginBig),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.title,
                                                      style:
                                                          Fonts.bold(size: 16)),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(e.race.title,
                                                        style: Fonts.light(
                                                            size: 14)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                                width: Measures.hMarginBig),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height: Measures.vMarginThin),
                                      // Skills
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                                  const SizedBox(
                                                      width:
                                                          Measures.hMarginBig)
                                                ].cast<Widget>() +
                                                (e.defaultSkills.isEmpty
                                                    ? [
                                                        const RadioButton(
                                                          text: 'Nessuna',
                                                          color: Palette
                                                              .primaryBlue,
                                                          isSmall: true,
                                                          width: 100,
                                                        )
                                                      ]
                                                    : e.defaultSkills.entries
                                                        .map((e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          6.0),
                                                              child:
                                                                  RadioButton(
                                                                text:
                                                                    '${e.key.title} +${e.value}',
                                                                color: Palette
                                                                    .primaryYellow,
                                                                isSmall: true,
                                                                width: 100,
                                                              ),
                                                            ))
                                                        .toList()),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: Measures.vMarginThin),
                                      // Masteries
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                                  const SizedBox(
                                                      width:
                                                          Measures.hMarginBig)
                                                ].cast<Widget>() +
                                                (e.defaultMasteries.isEmpty
                                                    ? [
                                                        const RadioButton(
                                                          text: 'Nessuna',
                                                          color: Palette
                                                              .primaryBlue,
                                                          isSmall: true,
                                                          width: 100,
                                                        )
                                                      ]
                                                    : e.defaultMasteries
                                                        .map((e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          6.0),
                                                              child:
                                                                  RadioButton(
                                                                text: e.title,
                                                                color: Palette
                                                                    .primaryBlue,
                                                                isSmall: true,
                                                                width: 100,
                                                              ),
                                                            ))
                                                        .toList()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Info button
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: Measures.hMarginSmall,
                                      right: Measures.hMarginSmall),
                                  child: 'info'.toIcon(
                                      onTap: () {
                                        context.popup(e.title,
                                            message: e.description,
                                            positiveText: 'Ok',
                                            backgroundColor: Palette.background
                                                .withOpacity(0.5));
                                      },
                                      padding: const EdgeInsets.all(12)),
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList()
                    .cast<Widget>() +
                [const SizedBox(height: Measures.vMarginBig)]),
      ]),
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            const GradientBackground(topColor: Palette.backgroundBlue),
            // Page content
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _screens!
                  .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Measures.hPadding),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            top: Measures.vMarginBig * 2 +
                                Measures.vMarginSmall),
                        child: e,
                      )))
                  .toList(),
            ),
            // Chevron // Todo: all toIcon() with tap detection should be written as follows:
            Padding(
              padding: const EdgeInsets.only(
                  top: Measures.vMarginBig, left: Measures.hMarginMed),
              child: 'chevron_left'.toIcon(
                  height: 24,
                  onTap: previous,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
            ),
            // Bottom vignette
            const BottomVignette(height: 0, spread: 80),
            // Bottom points
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measures.hPadding, vertical: Measures.vMarginMed),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Continue button
                    if (_hasBottomButton[_index])
                      GlassButton(
                        'PROSEGUI',
                        color: Palette.primaryBlue,
                        onTap: () {
                          if (validate(
                              () => character.name = _nameController.text)) {
                            next();
                          }
                        },
                      ),
                    const SizedBox(height: Measures.vMarginMed),
                    // Bottom Progress
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                            (_screens?.length ?? 0) + 5,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.2),
                                  child: AnimatedContainer(
                                    height: _index == index ? 13 : 11,
                                    width: _index == index ? 13 : 11,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        color: _index == index
                                            ? Palette.onBackground
                                            : Palette.card),
                                    duration: Durations.medium3,
                                  ),
                                )))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  next({int step = 1}) {
    // Cloning the previous state
    for (var i = 1; i <= step; i++) {
      characters[_index + i] = Character.fromJson(character.toJSON());
    }
    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.animateToPage(_index + step,
        duration: Durations.medium1, curve: Curves.easeOutCubic);
    print(characters);
  }

  previous() {
    // Reset the current screen state
    int step = (_index == 3 && characters[2]!.race.subRaces.isEmpty)
        ? 2
        : 1; // Skipp-able screens
    if (_index > 0) {
      characters[_index - step] = _index > 1
          ? Character.fromJson(characters[_index - step - 1]!.toJSON())
          : Character();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (_index == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.animateToPage(_index - step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
    print(characters);
  }
}
