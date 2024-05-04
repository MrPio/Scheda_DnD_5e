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
  Character character = Character();
  late final PageController _pageController;
  late final TextEditingController _nameController;

  List<Widget>? _screens;

  final _hasBottomButton = [true, false, false, false];
  var _index = 0;

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
    _screens = [
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
                                  // Set race and clear the fields to be set
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
                                      color: Palette.primaryRed,
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
                                        var selected=character.skills-e.defaultSkills;
                                        if(selected.containsKey(value)){
                                          character.skills -= {value: 1};
                                        }
                                        else if(selected.isEmpty || selected.values.toList().sum()<e.numChoiceableSkill){
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
                                        .forEach((subSkill) =>
                                    character.subSkills += {subSkill: 1});
                                    await context.checkList<SubSkill>(
                                      'Scegli ${e.numChoiceableSubSkill} sottocompetenza/e',
                                      dismissible: false,
                                      isRadio: e.numChoiceableSubSkill == 1,
                                      values: SubSkill.values,
                                      color: Palette.primaryYellow,
                                      onChanged: (value) {
                                        if(character.subSkills.containsKey(value)){
                                          character.subSkills -= {value: 1};
                                        }
                                        else if(character.subSkills.isEmpty || character.subSkills.values.toList().sum()<e.numChoiceableSubSkill){
                                          character.subSkills += {value: 1};
                                        }
                                      },
                                      value: (value) =>
                                      character.subSkills[value] == 1,
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
                                                e.defaultLanguages
                                                    .map((e) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 6.0),
                                                          child: RadioButton(
                                                            text: e.title,
                                                            color: Palette
                                                                .primaryGreen,
                                                            isSmall: true,
                                                            width: 100,
                                                          ),
                                                        ))
                                                    .toList() +
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
                                                e.defaultSkills.entries
                                                    .map((e) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 6.0),
                                                          child: RadioButton(
                                                            text:
                                                                '${e.key.title} +${e.value}',
                                                            color: Palette
                                                                .primaryYellow,
                                                            isSmall: true,
                                                            width: 100,
                                                          ),
                                                        ))
                                                    .toList(),
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
      Placeholder(),
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

  next() {
    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.nextPage(
        duration: Durations.medium1, curve: Curves.easeOutCubic);
  }

  previous() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_index == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.previousPage(
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }
}
