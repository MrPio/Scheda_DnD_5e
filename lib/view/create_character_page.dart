import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/dictionary.dart';
import 'package:scheda_dnd_5e/enum/language.localized.g.part';
import 'package:scheda_dnd_5e/enum/mastery.localized.g.part';
import 'package:scheda_dnd_5e/enum/race.localized.g.part';
import 'package:scheda_dnd_5e/enum/skill.localized.g.part';
import 'package:scheda_dnd_5e/enum/subrace.localized.g.part';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/iterable_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/map_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/set_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/model/loot.dart';
import 'package:scheda_dnd_5e/view/partial/card/alignment_card.dart';
import 'package:scheda_dnd_5e/view/partial/card/class_card.dart';
import 'package:scheda_dnd_5e/view/partial/card/skill_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/loading_view.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/layout/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/legend.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';

import '../constant/fonts.dart';
import '../constant/measures.dart';
import '../constant/palette.dart';
import '../enum/character_alignment.dart';
import '../enum/class.dart';
import '../enum/language.dart';
import '../enum/mastery.dart';
import '../enum/race.dart';
import '../enum/skill.dart';
import '../enum/subskill.dart';
import '../mixin/validable.dart';
import '../model/character.dart';

class CreateCharacterPage extends StatefulWidget {
  const CreateCharacterPage({super.key});

  @override
  State<CreateCharacterPage> createState() => _CreateCharacterPageState();
}

class _CreateCharacterPageState extends State<CreateCharacterPage> with Validable, Loadable {
  List<Character?> characters = [Character(), null, null, null, null, null];

  Character get character => characters[_index]!;

  late final PageController _pageController;
  late final TextEditingController _nameController;

  List<Widget>? _screens;
  List<Function()?>? _bottomButtons;

  int _index = 0;
  final List<TextEditingController> _skillControllers =
      List.generate(Skill.values.length, (_) => TextEditingController(text: '3'));

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
        // Title
        Align(alignment: Alignment.centerLeft, child: Text('Assegna un nome', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Come vuoi chiamare il tuo nuovo personaggio?', style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Search TextField
        GlassTextField(
          iconPath: 'png/edit',
          hintText: 'Il nome del personaggio',
          secondaryIconPath: 'png/random',
          onSecondaryIconTap: () {
            _nameController.text = Dictionary.names.random;
            setState(() {});
          },
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
        // Title
        Align(alignment: Alignment.centerLeft, child: Text('Seleziona la razza', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text('La Razza rappresenta il popolo e l’etnia di cui farà parte il personaggio.',
              style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Legend
        const Legend(
            items: {'Linguaggi': Palette.primaryGreen, 'Punti caratteristica': Palette.primaryYellow}),
        const SizedBox(height: Measures.vMarginMed),
        // Races cards
        Column(
            children: Race.values
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: Measures.vMarginThin),
                          child: GlassCard(
                            onTap: () async {
                              // Set race fields
                              character.race = e;
                              character.languages = e.defaultLanguages.toSet();
                              character.masteries.clear();
                              character.chosenSkills.clear();
                              character.subSkills.clear();
                              // Ask the possible choices before continuing
                              if (e.canChoiceLanguage) {
                                final languages = Language.values
                                    .where((language) => !e.defaultLanguages.contains(language))
                                    .toList()
                                  ..sort((a, b) => a.title(context).compareTo(b.title(context)));
                                character.languages.add(languages[0]);
                                await context.checkList<Language>(
                                  'Scegli un linguaggio',
                                  dismissible: false,
                                  isRadio: true,
                                  values: languages,
                                  color: Palette.primaryGreen,
                                  selectionRequirement: 1,
                                  onChanged: (value) =>
                                      character.languages = (e.defaultLanguages + [value]).toSet(),
                                  value: (value) => character.languages.contains(value),
                                );
                              }
                              if (e.choiceableMasteries.isNotEmpty) {
                                character.masteries = {e.choiceableMasteries[0]};
                                await context.checkList<Mastery>(
                                  'Scegli una competenza',
                                  dismissible: false,
                                  isRadio: true,
                                  values: e.choiceableMasteries,
                                  color: Palette.primaryBlue,
                                  selectionRequirement: 1,
                                  onChanged: (value) => character.masteries = {value},
                                  value: (value) => character.masteries.contains(value),
                                );
                              }
                              if (e.numChoiceableSkills > 0) {
                                Skill.values
                                    .sublist(0, e.numChoiceableSkills)
                                    .forEach((skill) => character.chosenSkills += {skill: 1});
                                await context.checkList<Skill>(
                                  'Scegli ${e.numChoiceableSkills} competenza/e a cui assegnare +1',
                                  dismissible: false,
                                  isRadio: e.numChoiceableSkills == 1,
                                  values: Skill.values,
                                  color: Palette.primaryYellow,
                                  selectionRequirement: e.numChoiceableSkills,
                                  onChanged: (value) {
                                    var selected = character.chosenSkills;
                                    if (selected.containsKey(value)) {
                                      character.chosenSkills -= {value: 1};
                                    } else if (selected.isEmpty ||
                                        selected.values.toList().sum() < e.numChoiceableSkills) {
                                      character.chosenSkills += {value: 1};
                                    } else if (e.numChoiceableSkills == 1 &&
                                        !selected.containsKey(value)) {
                                      character.chosenSkills.clear();
                                      character.chosenSkills.addAll({value: 1});
                                    }
                                  },
                                  value: (value) => character.chosenSkills[value] == 1,
                                );
                              }
                              if (e.numChoiceableSubSkills > 0) {
                                SubSkill.values
                                    .sublist(0, e.numChoiceableSkills)
                                    .forEach((subSkill) => character.subSkills += {subSkill: 1});
                                await context.checkList<SubSkill>(
                                  'Scegli ${e.numChoiceableSubSkills} sottocompetenza/e',
                                  dismissible: false,
                                  isRadio: e.numChoiceableSubSkills == 1,
                                  values: SubSkill.values,
                                  color: Palette.primaryYellow,
                                  selectionRequirement: e.numChoiceableSubSkills,
                                  onChanged: (value) {
                                    if (character.subSkills.containsKey(value)) {
                                      character.subSkills -= {value: 1};
                                    } else if (character.subSkills.isEmpty ||
                                        character.subSkills.values.toList().sum() <
                                            e.numChoiceableSubSkills) {
                                      character.subSkills += {value: 1};
                                    } else if (e.numChoiceableSubSkills == 1 &&
                                        !character.subSkills.containsKey(value)) {
                                      character.subSkills.clear();
                                      character.subSkills.addAll({value: 1});
                                    }
                                  },
                                  value: (value) => character.subSkills[value] == 1,
                                );
                              }
                              next(step: e.subRaces.isEmpty ? 2 : 1);
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Measures.hMarginMed),
                                  child: Column(
                                    children: [
                                      // Title, description and info button
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: Measures.hMarginBig),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.title(context), style: Fonts.bold()),
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(e.subRacesInfo,
                                                        style: Fonts.light(size: 14)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: Measures.hMarginBig),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: Measures.vMarginThin),
                                      // Languages
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [const SizedBox(width: Measures.hMarginBig)]
                                                    .cast<Widget>() +
                                                (e.defaultLanguages.isEmpty
                                                    ? [
                                                        const RadioButton(
                                                          text: 'Nessuna',
                                                          color: Palette.primaryGreen,
                                                          isSmall: true,
                                                          width: 100,
                                                        )
                                                      ]
                                                    : e.defaultLanguages
                                                        .map((e) => Padding(
                                                              padding: const EdgeInsets.only(right: 6.0),
                                                              child: RadioButton(
                                                                text: e.title(context),
                                                                color: Palette.primaryGreen,
                                                                isSmall: true,
                                                                width: 100,
                                                              ),
                                                            ))
                                                        .toList()) +
                                                (e.canChoiceLanguage
                                                    ? [
                                                        const Padding(
                                                          padding: EdgeInsets.only(right: 6.0),
                                                          child: RadioButton(
                                                            text: '+ 1 a scelta',
                                                            color: Palette.primaryGreen,
                                                            isSmall: true,
                                                            width: 100,
                                                          ),
                                                        )
                                                      ]
                                                    : []),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: Measures.vMarginThin),
                                      // Skills
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [const SizedBox(width: Measures.hMarginBig)]
                                                    .cast<Widget>() +
                                                (e.defaultSkills.isEmpty
                                                    ? [
                                                        const RadioButton(
                                                          text: 'Nessuna',
                                                          color: Palette.primaryYellow,
                                                          isSmall: true,
                                                          width: 100,
                                                        )
                                                      ]
                                                    : e.defaultSkills.entries
                                                        .map((e) => Padding(
                                                              padding: const EdgeInsets.only(right: 6.0),
                                                              child: RadioButton(
                                                                text:
                                                                    '${e.key.title(context)} +${e.value}',
                                                                color: Palette.primaryYellow,
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
                                // Info button
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: Measures.hMarginSmall, right: Measures.hMarginSmall),
                                    child: 'info'.toIcon(
                                        onTap: () {
                                          context.popup(e.title(context),
                                              message: e.description(context),
                                              positiveText: 'Ok',
                                              backgroundColor:
                                                  Palette.backgroundGrey.withValues(alpha: 0.2));
                                        },
                                        padding: const EdgeInsets.all(12)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList()
                    .cast<Widget>() +
                [const SizedBox(height: Measures.vMarginBig)]),
      ]),
      // Select subRace
      Column(children: [
        // Title
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Seleziona la sottorazza', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'I membri di una sottorazza hanno i tratti della razza genitrice in aggiunta ai tratti specificati per la loro sottorazza.',
              style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Legend
        const Legend(
            items: {'Punti caratteristica': Palette.primaryYellow, 'Maestrie': Palette.primaryBlue}),
        const SizedBox(height: Measures.vMarginMed),
        // SubRaces cards
        Column(
            children: character.race.subRaces.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.only(top: Measures.vMarginSmall),
                      child: Text('Niente da mostrare', style: Fonts.black(color: Palette.card2)),
                    )
                  ]
                : character.race.subRaces
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: Measures.vMarginThin),
                              child: GlassCard(
                                onTap: () async {
                                  // Set subRace fields
                                  character.subRace = e;
                                  character.masteries.addAll(e.defaultMasteries);
                                  Set<Language> backupLanguages = Set.from(character.languages);
                                  // Ask the possible choices before continuing
                                  if (e.numChoiceableLanguages > 0) {
                                    final languages = Language.values
                                        .where((language) => !character.languages.contains(language))
                                        .toList()
                                      ..sort((a, b) => a.title(context).compareTo(b.title(context)));
                                    character.languages
                                        .addAll(languages.sublist(0, e.numChoiceableLanguages));
                                    await context.checkList<Language>(
                                      'Scegli ${e.numChoiceableLanguages} linguaggio/i',
                                      dismissible: false,
                                      isRadio: e.numChoiceableLanguages == 1,
                                      values: languages,
                                      color: Palette.primaryGreen,
                                      selectionRequirement: e.numChoiceableLanguages,
                                      onChanged: (value) {
                                        if (e.numChoiceableLanguages > 1 &&
                                            character.languages.contains(value)) {
                                          character.languages.remove(value);
                                        } else if (e.numChoiceableLanguages == 1 &&
                                            !character.languages.contains(value)) {
                                          character.languages.clear();
                                          character.languages.addAll(backupLanguages + {value});
                                        } else if (character.languages.length - backupLanguages.length <
                                            e.numChoiceableLanguages) {
                                          character.languages.add(value);
                                        }
                                      },
                                      value: (value) => character.languages.contains(value),
                                    );
                                  }
                                  next();
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: Measures.hMarginMed),
                                      child: Column(
                                        children: [
                                          // Title, description and info button
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Measures.hMarginBig),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(e.title(context), style: Fonts.bold(size: 16)),
                                                      SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Text(e.race.title(context),
                                                            style: Fonts.light(size: 14)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: Measures.hMarginBig),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: Measures.vMarginThin),
                                          // Skills
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [const SizedBox(width: Measures.hMarginBig)]
                                                        .cast<Widget>() +
                                                    (e.defaultSkills.isEmpty
                                                        ? [
                                                            const RadioButton(
                                                              text: 'Nessuna',
                                                              color: Palette.primaryBlue,
                                                              isSmall: true,
                                                              width: 100,
                                                            )
                                                          ]
                                                        : e.defaultSkills.entries
                                                            .map((e) => Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(right: 6.0),
                                                                  child: RadioButton(
                                                                    text: '${e.key.title} +${e.value}',
                                                                    color: Palette.primaryYellow,
                                                                    isSmall: true,
                                                                    width: 100,
                                                                  ),
                                                                ))
                                                            .toList()),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: Measures.vMarginThin),
                                          // Masteries
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [const SizedBox(width: Measures.hMarginBig)]
                                                        .cast<Widget>() +
                                                    (e.defaultMasteries.isEmpty
                                                        ? [
                                                            const RadioButton(
                                                              text: 'Nessuna',
                                                              color: Palette.primaryBlue,
                                                              isSmall: true,
                                                              width: 100,
                                                            )
                                                          ]
                                                        : e.defaultMasteries
                                                            .map((e) => Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(right: 6.0),
                                                                  child: RadioButton(
                                                                    text: e.title(context),
                                                                    color: Palette.primaryBlue,
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
                                    // Info button
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: Measures.hMarginSmall, right: Measures.hMarginSmall),
                                        child: 'info'.toIcon(
                                            onTap: () {
                                              context.popup(e.title(context),
                                                  message: e.description(context),
                                                  positiveText: 'Ok',
                                                  backgroundColor:
                                                      Palette.backgroundGrey.withValues(alpha: 0.2));
                                            },
                                            padding: const EdgeInsets.all(12)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList()
                        .cast<Widget>() +
                    [const SizedBox(height: Measures.vMarginBig)]),
      ]),
      // Select class
      Column(children: [
        // Title
        Align(alignment: Alignment.centerLeft, child: Text('Seleziona la classe', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'La Classe rappresenta la vocazione del personaggio, e determina la sua abilità nel combattimento e nell\'uso della magia.',
              style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Legend
        const Legend(items: {'Tiri salvezza': Palette.primaryYellow, 'Maestrie': Palette.primaryBlue}),
        const SizedBox(height: Measures.vMarginMed),
        // Classes cards
        Column(
            children: Class.values
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: Measures.vMarginThin),
                          child: ClassCard(
                            e,
                            onTap: () async {
                              // Set class fields
                              character.classes = {e: 1};
                              character.masteries.addAll(e.defaultMasteries);
                              Map<SubSkill, int> backupSubSkills = Map.from(character.subSkills);
                              Set<Mastery> backupMasteries = Set.from(character.masteries);
                              // Ask the possible choices before continuing
                              if (e.subClasses[0].abilities.map((e) => e.item1).toList().reduce(min) <=
                                  1) {
                                // TODO ask for subclass
                              }
                              if (e.numChoiceableSubSkills > 0) {
                                character.subSkills += e.choiceableSubSkills
                                    .sublist(0, e.numChoiceableSubSkills)
                                    .map((e) => {e: 1})
                                    .reduce((value, element) => value + element);
                                await context.checkList<SubSkill>(
                                  'Scegli ${e.numChoiceableSubSkills} sottocompetenza/e',
                                  dismissible: false,
                                  isRadio: e.numChoiceableSubSkills == 1,
                                  values: e.choiceableSubSkills,
                                  color: Palette.primaryYellow,
                                  selectionRequirement: e.numChoiceableSubSkills,
                                  onChanged: (value) {
                                    var selected = character.subSkills - backupSubSkills;
                                    if (selected.containsKey(value)) {
                                      character.subSkills -= {value: 1};
                                    } else if (selected.isEmpty ||
                                        selected.values.toList().sum() < e.numChoiceableSubSkills) {
                                      character.subSkills += {value: 1};
                                    } else if (e.numChoiceableSubSkills == 1 &&
                                        !selected.containsKey(value)) {
                                      character.subSkills.clear();
                                      character.subSkills.addAll(backupSubSkills + {value: 1});
                                    }
                                  },
                                  value: (value) =>
                                      character.subSkills[value] == (backupSubSkills[value] ?? 0) + 1,
                                );
                              }
                              if (e.numChoiceableMasteries > 0) {
                                final masteries =
                                    e.choiceableMasteryTypes.map((e) => e.masteries).flatten;
                                character.masteries +=
                                    masteries.sublist(0, e.numChoiceableMasteries).toSet();
                                await context.checkList<Mastery>(
                                  'Scegli ${e.numChoiceableMasteries} competenza/e',
                                  dismissible: false,
                                  isRadio: e.numChoiceableMasteries == 1,
                                  values: masteries,
                                  color: Palette.primaryBlue,
                                  selectionRequirement: e.numChoiceableMasteries,
                                  onChanged: (value) {
                                    var selected = character.masteries - backupMasteries;
                                    if (selected.contains(value)) {
                                      character.masteries -= {value};
                                    } else if (selected.length < e.numChoiceableMasteries) {
                                      character.masteries += {value};
                                    } else if (e.numChoiceableMasteries == 1 &&
                                        !selected.contains(value)) {
                                      character.masteries.clear();
                                      character.masteries.addAll(backupMasteries + {value});
                                    }
                                  },
                                  value: (value) => character.masteries.contains(value),
                                );
                              }
                              if (e.choiceableItems.isNotEmpty) {
                                List<Map<String, int>> selected =
                                    List.generate(e.choiceableItems.length, (_) => {});
                                var count = 0;
                                for (var itemsUIDs in e.choiceableItems) {
                                  var items = {
                                    for (var entry in itemsUIDs.entries)
                                      DataManager()
                                          .cachedInventoryItems
                                          .firstWhere((e) => e.uid!.match(entry.key)): entry.value
                                  };
                                  selected[count][items.keys.first.uid!] = items.values.first;
                                  print(selected[count]);
                                  if (itemsUIDs.length > 1) {
                                    await context.checkList<InventoryItem>(
                                      'Scegli un oggetto (${count + 1}/${e.choiceableItems.where((e) => e.length > 1).length})',
                                      dismissible: false,
                                      isRadio: true,
                                      values: items.keys.toList(),
                                      color: Palette.primaryRed,
                                      selectionRequirement: 1,
                                      onChanged: (value) => selected[count] = {value.uid!: items[value]!},
                                      value: (value) => selected[count].containsKey(value.uid),
                                    );
                                    count++;
                                  }
                                }
                                for (var items in selected) {
                                  print(items);
                                  character.addLoot(Loot(items));
                                }
                              }
                              next();
                            },
                          ),
                        ))
                    .toList()
                    .cast<Widget>() +
                [const SizedBox(height: Measures.vMarginBig)]),
      ]),
      // Select alignment
      Column(children: [
        // Title
        Align(
            alignment: Alignment.centerLeft, child: Text('Scegli l’allineamento', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Text(
            'L’allineamento è dato dalla moralità (buono, malvagio o neutrale) e dal  comportamento nei confronti della società (legale, caotico o neutrale).',
            style: Fonts.light()),
        const SizedBox(height: Measures.vMarginMed),
        // Alignments =============================
        GridRow(
            columnsCount: 3,
            children: CharacterAlignment.values
                .map((e) => AlignmentCard(
                      e,
                      onTap: selectAlignment,
                      isSmall: e == CharacterAlignment.nessuno,
                    ))
                .toList()),
      ]),
      // Set skills
      Column(children: [
        // Title
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Completa le statistiche', style: Fonts.black())),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Text(
            'Per ogni competenza, lancia 4 D6, scarta il minore e calcola somma dei rimanenti. Puoi lanciare i dadi direttamente dall’app!',
            style: Fonts.light()),
        const SizedBox(height: Measures.vMarginThin),
        // Skill cards =============================
        GridRow(
            columnsCount: 2,
            children: Skill.values
                .map((e) => SkillCard(
                      e,
                      raceSkill: character.skillValue(e),
                      skillInputController: _skillControllers[e.index],
                    ))
                .toList()),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom + Measures.vMarginBig),
        // <-- This is essential, as it is dynamic based on the keyboard status.
      ]),
    ];
    _bottomButtons ??= [
      () {
        if (validate(() => character.name = _nameController.text)) {
          next();
        }
      },
      null,
      null,
      null,
      null,
      () {
        character.rollSkills =
            _skillControllers.asMap().map((i, e) => MapEntry(Skill.values[i], int.parse(e.text)));
        next();
      },
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: _index != 5,
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
                      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.only(top: Measures.vMarginBig * 2 + Measures.vMarginSmall),
                        child: e,
                      )))
                  .toList(),
            ),
            // Chevron
            Chevron(onTap: previous),
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
                    if (_bottomButtons?[_index] != null)
                      GlassButton(
                        'PROSEGUI',
                        color: Palette.primaryBlue,
                        onTap: _bottomButtons?[_index],
                      ),
                    const SizedBox(height: Measures.vMarginMed),
                    // Bottom Progress
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                            _screens?.length ?? 0,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3.2),
                                  child: AnimatedContainer(
                                    height: _index == index ? 13 : 11,
                                    width: _index == index ? 13 : 11,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(999),
                                        color: _index == index ? Palette.onBackground : Palette.card),
                                    duration: Durations.medium3,
                                  ),
                                )))
                  ],
                ),
              ),
            ),
            // LoadingView
            LoadingView(visible: isLoading)
          ],
        ),
      ),
    );
  }

  selectAlignment(CharacterAlignment alignment) {
    character.alignment = alignment;
    next();
  }

  next({int step = 1}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (_index + step >= (_screens?.length ?? 0)) {
      // The character creation is completed, save the character
      withLoading(() async {
        character.initiative = character.skillModifier(Skill.destrezza);
        character.speed = character.defaultSpeed;
        character.maxHp =
            character.classes.keys.first.maxHpDice.size + character.skillModifier(Skill.costituzione);
        character.hp = character.maxHp;
        character.uid = await DataManager().save(character, SaveMode.post);
        AccountManager().user.charactersUIDs.add(character.uid!);
        await DataManager().save(AccountManager().user);
        Navigator.of(context).pop();
      });
    } else {
      // Cloning the previous state
      for (var i = 1; i <= step; i++) {
        characters[_index + i] = Character.fromJson(character.toJSON());
      }
      FocusManager.instance.primaryFocus?.unfocus();
      _pageController.animateToPage(_index + step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }

  previous() {
    ScaffoldMessenger.of(context).clearSnackBars();
    // Reset the current screen state
    int step = (_index == 3 && characters[2]!.race.subRaces.isEmpty) ? 2 : 1; // Skipp-able screens
    if (_index > 0) {
      characters[_index - step] =
          _index > 1 ? Character.fromJson(characters[_index - step - 1]!.toJSON()) : Character();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (_index == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.animateToPage(_index - step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }
}
