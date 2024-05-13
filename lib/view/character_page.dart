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
import 'package:scheda_dnd_5e/view/partial/card/alignment_card.dart';
import 'package:scheda_dnd_5e/view/partial/grid_column.dart';
import 'package:scheda_dnd_5e/view/partial/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/card/sheet_item_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
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

class _CharacterPageState extends State<CharacterPage>
    with TickerProviderStateMixin {
  List<Widget>? _screens;
  TabController? _tabController;
  late ScrollController _bodyController;
  bool _isSkillsExpanded = false;
  Character? _character, _oldCharacter;

  @override
  void initState() {
    _bodyController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    if (jsonEncode(_oldCharacter!.toJSON()) !=
        jsonEncode(_character!.toJSON())) {
      Future.delayed(Duration.zero, () async {
        await DataManager().save(_character!);
        print('⬆️ Character Saved');
      });
    }
    _tabController?.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _character ??= ModalRoute.of(context)!.settings.arguments as Character;
    final character = _character!;
    _oldCharacter ??= Character.fromJson(character.toJSON());
    var attributes = [
      SheetItemCard(
          iconPath: 'png/shield',
          text: 'CA',
          value: character.armorClass.toString()),
      SheetItemCard(
        iconPath: 'png/hp',
        text: 'HP',
        value: character.hp.toString(),
        subValue: character.maxHp.toString(),
      ),
      SheetItemCard(
          iconPath: 'png/bonus',
          text: 'BC',
          value: character.competenceBonus.toSignedString()),
      SheetItemCard(
          iconPath: 'png/speed',
          text: 'Speed',
          value: '${character.defaultSpeed.round()}m'),
      SheetItemCard(
        iconPath: 'png/status',
        text: 'Allineamento',
        value: character.alignment.initials ?? '-',
        popup: GridRow(
            columnsCount: 3,
            children: ch.Alignment.values
                .map((e) => AlignmentCard(
                      e,
                      onTap: (alignment) {
                        character.alignment = alignment;
                        Navigator.of(context).pop();
                      },
                      isSmall: e == ch.Alignment.nessuno,
                    ))
                .toList()),
      ),
      SheetItemCard(
          iconPath: 'png/initiative',
          text: 'Iniziativa',
          value: character.initiative.toSignedString()),
    ];
    var skills = [
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
              value: character.skillModifier(skill).toSignedString(),
              subValue: character.skillValue(skill).toString(),
              child: _isSkillsExpanded
                  ? Column(
                      children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Measures.hMarginMed,
                                          vertical: Measures.vMarginMoreThin),
                                      child: Row(children: [
                                        // SubSkill title
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            'Tiro salvezza',
                                            style: Fonts.regular(size: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // SubSkill value
                                        Text(
                                            character
                                                .savingThrowValue(skill)
                                                .toSignedString(),
                                            style: Fonts.black(size: 14)),
                                        const SizedBox(
                                            width: Measures.hMarginSmall),
                                        // Competenza
                                        Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                                color: character.savingThrows
                                                        .contains(skill)
                                                    ? Palette.onBackground
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: Palette.onBackground,
                                                    width: 0.65),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        999))),
                                      ]))),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Measures.vMarginMoreThin),
                              child: Rule(),
                            ),
                          ].cast<Widget>() +
                          skill.subSkills
                              .map((subSkill) => Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
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
                                            Text(
                                                character
                                                    .subSkillValue(subSkill)
                                                    .toSignedString(),
                                                style: Fonts.black(size: 14)),
                                            const SizedBox(
                                                width: Measures.hMarginSmall),
                                            // Competenza
                                            Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: (character.subSkills[
                                                                    subSkill] ??
                                                                0) >=
                                                            1
                                                        ? Palette.onBackground
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: Palette
                                                            .onBackground,
                                                        width: 0.65),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999))),
                                            const SizedBox(
                                                width: Measures.hMarginThin),
                                            // Maestria
                                            Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: (character.subSkills[
                                                                    subSkill] ??
                                                                0) >=
                                                            2
                                                        ? Palette.onBackground
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: Palette
                                                            .onBackground,
                                                        width: 0.65),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1.75)))
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
    _screens /*TODO ??*/ = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Measures.vMarginMed),
          // HP bar
          HpBar(character.hp, character.maxHp),
          const SizedBox(height: Measures.vMarginSmall),
          // Attributes
          Text('Attributi', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRow(
            columnsCount: 3,
            children: attributes,
          ),
          const SizedBox(height: Measures.vMarginThin),
          // Skills and subSkills
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() {
              _isSkillsExpanded = !_isSkillsExpanded;
            }),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: Measures.vMarginThin),
              child: Row(children: [
                Text('Caratteristiche', style: Fonts.black(size: 18)),
                const SizedBox(width: Measures.hMarginMed),
                'chevron_left'.toIcon(
                    height: 16, rotation: _isSkillsExpanded ? pi / 2 : -pi / 2)
              ]),
            ),
          ),
          _isSkillsExpanded
              ? GridColumn(
                  columnsCount: 2,
                  children: skills,
                )
              : GridRow(
                  columnsCount: 3,
                  children: skills,
                ),
          const SizedBox(height: Measures.vMarginSmall),
          // Masteries
          Text('Competenze', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRow(
              fill: true,
              columnsCount: 3,
              children: character.masteries
                      .map((e) => SheetItemCard(
                            text: e.title,
                            iconPath: e.masteryType.iconPath,
                          ))
                      .toList()
                      .cast<Widget>() +
                  [
                    GlassCard(
                        height: Measures.sheetCardSmallHeight,
                        isLight: true,
                        child: Center(child: 'add'.toIcon(height: 16)))
                  ]),
          const SizedBox(height: Measures.vMarginSmall),
          // Languages
          Text('Competenze', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRow(
              fill: true,
              columnsCount: 3,
              children: character.languages
                      .map((e) => SheetItemCard(
                            text: e.title,
                            iconPath: 'png/warrior',
                          ))
                      .toList()
                      .cast<Widget>() +
                  [
                    GlassCard(
                        height: Measures.sheetCardSmallHeight,
                        isLight: true,
                        child: Center(child: 'add'.toIcon(height: 16)))
                  ]),
          const SizedBox(height: Measures.vMarginBig),
        ],
      ),
    ];
    _tabController ??= TabController(length: _screens!.length, vsync: this)
      ..addListener(() {
        setState(() {});
      });
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
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
                            Text(character.name, style: Fonts.black(size: 18)),
                            Text(
                                character.subRace == null
                                    ? character.race.title
                                    : '${character.subRace!.title} (${character.race.title})',
                                style: Fonts.light(size: 16))
                          ]),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: Measures.hPadding),
                            child: Level(level: character.level, maxLevel: 20),
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
                                    (e.$2.value +
                                            (_tabController!.index == e.$1
                                                ? '_on'
                                                : '_off'))
                                        .toIcon(height: 20),
                                    const SizedBox(
                                        width: Measures.hMarginSmall),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Measures.hPadding),
                                child: e,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
