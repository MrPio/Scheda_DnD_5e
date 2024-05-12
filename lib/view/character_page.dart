import 'dart:math';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/grid_rows.dart';
import 'package:scheda_dnd_5e/view/partial/card/sheet_item_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';

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
  bool _isSkillsExpanded = false;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context)!.settings.arguments as Character;
    var attributes = [
      const SheetItemCard(
          iconPath: 'png/shield', text: 'CA', value: '18', subValue: '20'),
      const SheetItemCard(
          iconPath: 'png/hp', text: 'HP', value: '18', subValue: '20'),
      const SheetItemCard(
          iconPath: 'png/max_hp', text: 'Max HP', value: '18', subValue: '20'),
      const SheetItemCard(
          iconPath: 'png/initiative',
          text: 'Iniziativa',
          value: '18',
          subValue: '20'),
      const SheetItemCard(
          iconPath: 'png/speed', text: 'Speed', value: '18', subValue: '20'),
      const SheetItemCard(
          iconPath: 'png/bonus', text: 'BC', value: '18', subValue: '20'),
    ];
    var skills = [Skill.forza,Skill.costituzione,Skill.destrezza,Skill.intelligenza,Skill.saggezza,Skill.carisma]
        .map((e) => SheetItemCard(
              iconPath: e.iconPath,
              text: e.title,
              iconColor: e.color,
              value: character.skillsModifier[e].toString(),
              subValue: character.skills[e].toString(),
              child: _isSkillsExpanded
                  ? Column(
                      children: e.subSkills
                          .map((e1) => Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Measures.hMarginMed,
                                        vertical: Measures.vMarginMoreThin),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(e1.title,
                                              style: Fonts.regular(size: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        ),
                                        Text(
                                            (character.subSkills[e1] ?? 0)
                                                .toString(),
                                            style: Fonts.regular(size: 14)),
                                        SizedBox(width: Measures.hMarginThin),
                                        Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                                color: Palette.onBackground,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        999))),
                                        SizedBox(width: Measures.hMarginThin),
                                        Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                                color: Palette.onBackground,
                                                borderRadius:
                                                    BorderRadius.circular(2)))
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  : null,
            ))
        .toList();
    _screens /*TODO ??*/ = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Measures.vMarginMed),
          HpBar(character.hp, character.maxHp),
          const SizedBox(height: Measures.vMarginSmall),
          Text('Attributi', style: Fonts.black(size: 18)),
          const SizedBox(height: Measures.vMarginThin),
          GridRows(
            crossAxisCount: 3,
            children: attributes,
          ),
          const SizedBox(height: Measures.vMarginThin),
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
          GridRows(
            crossAxisCount: _isSkillsExpanded ? 2 : 3,
            children: skills,
          ),
          const SizedBox(height: Measures.vMarginSmall),
          Text('Competenze', style: Fonts.black(size: 18)),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: Measures.vMarginBig),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    Text(character.name, style: Fonts.black(size: 18)),
                    Text(
                        character.subRace == null
                            ? character.race.title
                            : '${character.subRace!.title} (${character.race.title})',
                        style: Fonts.light(size: 16))
                  ]),
                ),
              ),
              const SizedBox(height: Measures.vMarginSmall),
              // TabBar
              TabBar(
                  controller: _tabController,
                  isScrollable: true,
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
                                    .toIcon(height: 22),
                                const SizedBox(width: Measures.hMarginSmall),
                                Text(
                                  e.$2.key,
                                  style: _tabController!.index == e.$1
                                      ? Fonts.bold(size: 16)
                                      : Fonts.light(size: 16),
                                ),
                              ],
                            ),
                          ))
                      .toList()
                      .cast<Widget>()),
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
          // Chevron + Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Chevron(),
              Padding(
                padding: const EdgeInsets.only(
                    top: Measures.vMarginBig, right: Measures.hPadding),
                child: Level(level: character.level, maxLevel: 10),
              ),
            ],
          )
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
