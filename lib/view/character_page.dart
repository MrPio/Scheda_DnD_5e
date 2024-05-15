import 'dart:convert';
import 'dart:math';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/card/alignment_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/grid_column.dart';
import 'package:scheda_dnd_5e/view/partial/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/card/sheet_item_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:scheda_dnd_5e/model/character.dart' as ch show Alignment;

import '../model/character.dart' hide Alignment;
import 'partial/gradient_background.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> with TickerProviderStateMixin {
  List<Widget>? _screens;
  late final TabController _tabController;
  late ScrollController _bodyController;
  bool _isSkillsExpanded = true;
  late final Character _character, _oldCharacter;
  late final TextEditingController _armorClassController,
      _speedController,
      _initiativeController,
      _hpController,
      _maxHpController;
  final List<TextEditingController> _skillsControllers =
      List.generate(Skill.values.length, (_) => TextEditingController());
  final List<TextEditingController> _subSkillsControllers =
      List.generate(SubSkill.values.length, (_) => TextEditingController());
  final String _speedSuffix = 'm';
  bool _isEditingHp = false, _isEditingMaxHp = false;
  Skill? _selectedSkill;

  @override
  void initState() {
    _character = ModalRoute.of(context)!.settings.arguments as Character;
    _oldCharacter = Character.fromJson(_character.toJSON());
    _tabController = TabController(length: _screens!.length, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(Duration.zero, () async {
      _isSkillsExpanded = await IOManager().get<bool>('character_page_isSkillsExpanded') ?? true;
      setState(() {});
    });
    _armorClassController = TextEditingController();
    _speedController = TextEditingController();
    _initiativeController = TextEditingController();
    _hpController = TextEditingController();
    _maxHpController = TextEditingController();
    _bodyController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _character.armorClass = int.tryParse(_armorClassController.text) ?? _character.armorClass;
    _character.speed =
        double.tryParse(_speedController.text.replaceAll(_speedSuffix, '')) ?? _character.speed;
    _character.initiative = int.tryParse(_initiativeController.text) ?? _character.initiative;
    if (jsonEncode(_oldCharacter!.toJSON()) != jsonEncode(_character.toJSON())) {
      Future.delayed(Duration.zero, () async {
        await DataManager().save(_character);
        print('⬆️ Character Saved');
      });
    }
    for (var e in [
          _armorClassController,
          _speedController,
          _initiativeController,
          _hpController,
          _maxHpController
        ] +
        _skillsControllers +
        _subSkillsControllers) {
      e.dispose();
    }
    _tabController?.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sheetAttributes = [
      SheetItemCard(
        iconPath: 'png/shield',
        text: 'CA',
        value: _character.armorClass.toString(),
        numericInputArgs: NumericInputArgs(min: 0, max: 99, controller: _armorClassController),
      ),
      SheetItemCard(
        iconPath: 'png/hp',
        text: _isEditingMaxHp ? 'Max HP' : 'HP',
        value: (_isEditingMaxHp ? _character.maxHp : _character.hp).toString(),
        subValue: _isEditingMaxHp || _isEditingHp ? null : _character.maxHp.toString(),
        numericInputArgs: (_isEditingHp || _isEditingMaxHp)
            ? NumericInputArgs(
                min: _isEditingHp ? -_character.maxHp : 0,
                max: _isEditingHp ? _character.maxHp : 999,
                controller: _isEditingHp ? _hpController : _maxHpController,
                defaultValue: (_isEditingHp ? _character.hp : _character.maxHp).toDouble(),
                onSubmitted: (value) {
                  if (_isEditingHp) {
                    _character.hp = value.toInt();
                  } else if (_isEditingMaxHp) {
                    _character.maxHp = value.toInt();
                  }
                },
                finalize: () {
                  setState(() {
                    _isEditingHp = false;
                    _isEditingMaxHp = false;
                  });
                },
                autofocus: true,
              )
            : null,
        bottomSheetItems: [
          BottomSheetItem('png/hp', 'Modifica HP', () {
            setState(() {
              _isEditingHp = true;
              _isEditingMaxHp = false;
            });
          }),
          BottomSheetItem('png/max_hp', 'Modifica HP Massimi', () {
            setState(() {
              _isEditingHp = false;
              _isEditingMaxHp = true;
            });
          }),
          if (_character.hp < _character.maxHp)
            BottomSheetItem('png/rest', 'Riposa', () {
              setState(() {
                _character.hp = _character.maxHp;
              });
              context.snackbar('La vita è stata ripristinata', backgroundColor: Palette.primaryBlue);
            }),
        ],
      ),
      SheetItemCard(
          iconPath: 'png/bonus', text: 'BC', value: _character.competenceBonus.toSignedString()),
      SheetItemCard(
          iconPath: 'png/speed',
          text: 'Speed',
          numericInputArgs: NumericInputArgs(
            min: 0,
            max: 99,
            controller: _speedController,
            decimalPlaces: 1,
            defaultValue: _character.defaultSpeed,
            suffix: _speedSuffix,
            valueRestriction: (value) =>
                value % 1.5 < 1.5 - value % 1.5 ? value - value % 1.5 : value + value % 1.5,
          ),
          value: '${_character.speed.toStringAsFixed(1)}m'),
      SheetItemCard(
        iconPath: 'png/status',
        text: 'Allineamento',
        value: _character.alignment.initials ?? '-',
        bottomSheetHeader: GridRow(
            columnsCount: 3,
            children: ch.Alignment.values
                .map((e) => AlignmentCard(
                      e,
                      onTap: (alignment) {
                        setState(() {
                          _character.alignment = alignment;
                        });

                        Navigator.of(context).pop();
                      },
                      isSmall: e == ch.Alignment.nessuno,
                    ))
                .toList()),
      ),
      SheetItemCard(
          iconPath: 'png/initiative',
          text: 'Iniziativa',
          numericInputArgs: NumericInputArgs(
            min: -20,
            max: 20,
            controller: _initiativeController,
            defaultValue: _character.skillModifier(Skill.destrezza).toDouble(),
          ),
          value: _character.initiative.toSignedString()),
    ];
    var sheetSkills = [
      Skill.forza,
      Skill.costituzione,
      Skill.destrezza,
      Skill.intelligenza,
      Skill.saggezza,
      Skill.carisma
    ]
        .map((skill) => SheetItemCard(
              iconPath: skill.iconPath,
              text: skill.title,
              iconColor: skill.color,
              value: _selectedSkill == skill
                  ? _character.skillValue(skill).toString()
                  : _character.skillModifier(skill).toSignedString(),
              subValue: _selectedSkill == skill ? null : _character.skillValue(skill).toString(),
              numericInputArgs: _selectedSkill == skill
                  ? NumericInputArgs(
                      min: 3,
                      max: 20,
                      controller: _skillsControllers[Skill.values.indexOf(skill)],
                      defaultValue: (_character.skillValue(skill)).toDouble(),
                      onSubmitted: (value) {
                        _character.customSkills[skill] = value.toInt();
                      },
                      finalize: () {
                        setState(() {
                          _selectedSkill = null;
                        });
                      },
                      autofocus: true)
                  : null,
              onTap: _isSkillsExpanded
                  ? null
                  : () {
                      setState(() {
                        _selectedSkill = skill;
                      });
                    },
              child: _isSkillsExpanded
                  ? Column(
                      children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Measures.hMarginMed, vertical: Measures.vMarginMoreThin),
                                child: Row(children: [
                                  // SavingThrow title
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      'Tiro salvezza',
                                      style: Fonts.regular(size: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // SavingThrow value
                                  Text(_character.savingThrowValue(skill).toSignedString(),
                                      style: Fonts.black(size: 14)),
                                  const SizedBox(width: Measures.hMarginSmall),
                                  // Saving Throw
                                  Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          color: _character.class_.savingThrows.contains(skill)
                                              ? Palette.onBackground
                                              : Colors.transparent,
                                          border: Border.all(color: Palette.onBackground, width: 0.65),
                                          borderRadius: BorderRadius.circular(999))),
                                ])),
                            if (skill.subSkills.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: Measures.vMarginMoreThin),
                                child: Rule(),
                              ),
                          ].cast<Widget>() +
                          skill.subSkills
                              .map((subSkill) => Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _character.subSkills[subSkill] =
                                              ((_character.subSkills[subSkill] ?? 0) + 1) % 3;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Measures.hMarginMed,
                                            vertical: Measures.vMarginMoreThin),
                                        child: Row(
                                          children: [
                                            // SubSkill title
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                subSkill.title,
                                                style: Fonts.regular(size: 13),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // SubSkill value
                                            Text(_character.subSkillValue(subSkill).toSignedString(),
                                                style: Fonts.black(size: 14)),
                                            const SizedBox(width: Measures.hMarginSmall),
                                            // Competenza
                                            Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: (_character.subSkills[subSkill] ?? 0) == 1
                                                        ? Palette.onBackground
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: Palette.onBackground, width: 0.65),
                                                    borderRadius: BorderRadius.circular(999))),
                                            const SizedBox(width: Measures.hMarginThin),
                                            // Maestria
                                            Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: (_character.subSkills[subSkill] ?? 0) >= 2
                                                        ? Palette.onBackground
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: Palette.onBackground, width: 0.65),
                                                    borderRadius: BorderRadius.circular(1.75)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()
                              .cast<Widget>(),
                    )
                  : null,
            ))
        .toList();
    _screens = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Measures.vMarginMed),
          // TODO here: class and multiclass
          // HP bar
          HpBar(_character.hp, _character.maxHp),
          const SizedBox(height: Measures.vMarginSmall),
          // Attributes
          Text('Attributi', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRow(
            columnsCount: 3,
            children: sheetAttributes,
          ),
          const SizedBox(height: Measures.vMarginThin),
          // Skills and subSkills
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() {
              _isSkillsExpanded = !_isSkillsExpanded;
              IOManager().set('character_page_isSkillsExpanded', _isSkillsExpanded);
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Measures.vMarginThin),
              child: Row(children: [
                Text('Caratteristiche', style: Fonts.black(size: 18)),
                const SizedBox(width: Measures.hMarginMed),
                'chevron_left'.toIcon(height: 16, rotation: _isSkillsExpanded ? pi / 2 : -pi / 2)
              ]),
            ),
          ),
          _isSkillsExpanded
              ? GridColumn(
                  columnsCount: 2,
                  children: sheetSkills,
                )
              : GridRow(
                  columnsCount: 3,
                  children: sheetSkills,
                ),
          const SizedBox(height: Measures.vMarginSmall),
          // Masteries
          Text('Competenze', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRow(
              fill: true,
              columnsCount: 3,
              children: _character.masteries
                      .map((e) => SheetItemCard(
                            text: e.title,
                            iconPath: e.masteryType.iconPath,
                            onTap: () {
                              context.popup('Stai per rimuovere una competenza',
                                  message: 'Sei sicuro di voler rimuovere **${e.title}**?',
                                  positiveCallback: () {
                                setState(() {
                                  _character.masteries.remove(e);
                                });
                              },
                                  negativeCallback: () {},
                                  positiveText: 'Si',
                                  negativeText: 'No',
                                  backgroundColor: Palette.background.withOpacity(0.5));
                            },
                          ))
                      .toList()
                      .cast<Widget>() +
                  [
                    GlassCard(
                        height: Measures.sheetCardSmallHeight,
                        isLight: true,
                        clickable: true,
                        onTap: () {
                          context.draggableBottomSheet(
                            body: Column(
                              children: [
                                const SizedBox(height: Measures.vMarginThin),
                                Text('Aggiungi una competenza', style: Fonts.bold(size: 18)),
                                const SizedBox(height: Measures.vMarginThin),
                                Column(
                                    children: MasteryType.values
                                        .map((masteryType) => Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: Measures.vMarginSmall),
                                                  child: Rule(),
                                                ),
                                                Text(masteryType.title, style: Fonts.regular()),
                                                const SizedBox(height: Measures.vMarginSmall),
                                                GridRow(
                                                    columnsCount: 3,
                                                    fill: true,
                                                    children: masteryType.masteries
                                                        .where((e) => !_character.masteries.contains(e))
                                                        .map((mastery) => SheetItemCard(
                                                              text: mastery.title,
                                                              iconPath: masteryType.iconPath,
                                                              onTap: () {
                                                                setState(() {
                                                                  _character.masteries.add(mastery);
                                                                });
                                                                Navigator.of(context).pop();
                                                              },
                                                            ))
                                                        .toList()),
                                              ],
                                            ))
                                        .toList()),
                                const SizedBox(height: Measures.vMarginMed),
                              ],
                            ),
                          );
                        },
                        child: Center(child: 'add'.toIcon(height: 16)))
                  ]),
          const SizedBox(height: Measures.vMarginSmall),
          // Languages
          Text('Linguaggi', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRow(
              fill: true,
              columnsCount: 3,
              children: _character.languages
                      .map((e) => SheetItemCard(
                            text: e.title,
                            iconPath: 'png/language',
                            onTap: () {
                              // if(e!=Language.comune)
                              context.popup('Stai per rimuovere un linguaggio',
                                  message: 'Sei sicuro di voler rimuovere **${e.title}**?',
                                  positiveCallback: () {
                                setState(() {
                                  _character.languages.remove(e);
                                });
                              },
                                  negativeCallback: () {},
                                  positiveText: 'Si',
                                  negativeText: 'No',
                                  backgroundColor: Palette.background.withOpacity(0.5));
                            },
                          ))
                      .toList()
                      .cast<Widget>() +
                  [
                    GlassCard(
                        height: Measures.sheetCardSmallHeight,
                        isLight: true,
                        clickable: true,
                        onTap: () {
                          context.bottomSheet(
                            header: Column(
                              children: [
                                const SizedBox(height: Measures.vMarginThin),
                                Text('Aggiungi un linguaggio', style: Fonts.bold(size: 18)),
                                const SizedBox(height: Measures.vMarginMed),
                                GridRow(
                                    columnsCount: 3,
                                    fill: true,
                                    children: Language.values
                                        .where((e) => !_character.languages.contains(e))
                                        .map((e) => SheetItemCard(
                                              text: e.title,
                                              iconPath: 'png/language',
                                              onTap: () {
                                                setState(() {
                                                  _character.languages.add(e);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ))
                                        .toList()),
                                const SizedBox(height: Measures.vMarginMed),
                              ],
                            ),
                          );
                        },
                        child: Center(child: 'add'.toIcon(height: 16)))
                  ]),
          // const SizedBox(height: Measures.vMarginSmall),
          // const GlassButton('Salva',color: Palette.primaryBlue,iconPath: 'png/save',),
          const SizedBox(height: Measures.vMarginBig),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundBlue),
          // Header + Body
          SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    flexibleSpace: // Header
                        Padding(
                      padding: const EdgeInsets.only(top: Measures.vMarginMed),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Chevron(
                            inAppBar: true,
                          ),
                          Column(children: [
                            Text(_character.name, style: Fonts.black(size: 18)),
                            Text(
                                _character.subRace == null
                                    ? _character.race.title
                                    : '${_character.subRace!.title} (${_character.race.title})',
                                style: Fonts.light(size: 16))
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(right: Measures.hPadding),
                            child: Level(level: _character.level, maxLevel: 20),
                          ),
                        ],
                      ),
                    ),
                    leading: Container(),
                    collapsedHeight: 80,
                    expandedHeight: 80,
                    backgroundColor: Colors.transparent,
                    floating: true,
                  ),
                ];
              },
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Measures.vMarginSmall),
                  // TabBar
                  TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: const EdgeInsets.only(right: Measures.hMarginMed),
                      dividerHeight: 0,
                      tabs: {
                        'Scheda': 'png/sheet',
                        'Inventario': 'png/inventory',
                        'Incantesimi': 'png/scepter',
                        'Background': 'png/background',
                      }
                          .entries
                          .indexed
                          .map((e) => Tab(
                                child: Row(
                                  children: [
                                    (e.$2.value + (_tabController!.index == e.$1 ? '_on' : '_off'))
                                        .toIcon(height: 20),
                                    const SizedBox(width: Measures.hMarginSmall),
                                    Text(
                                      e.$2.key,
                                      style: _tabController!.index == e.$1
                                          ? Fonts.bold()
                                          : Fonts.light(size: 16),
                                    ),
                                  ],
                                ),
                              ))
                          .toList()
                          .cast<Widget>()),
                  const SizedBox(height: Measures.vMarginThin),
                  // Body
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _screens!
                          .map((e) => SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                                child: e,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom vignette
          const BottomVignette(height: 0, spread: 50),
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
