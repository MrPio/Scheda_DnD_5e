import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
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
  late final TabController _tabController;
  List<Widget>? _screens;

  @override
  void initState() {
    _screens = [
      Column(
        children: [
          SizedBox(height: Measures.vMarginSmall),
        ],
      ),
      Column(
        children: [
          SizedBox(height: Measures.vMarginSmall),
        ],
      ),
      Column(
        children: [
          SizedBox(height: Measures.vMarginSmall),
        ],
      ),
    ];
    _tabController = TabController(length: _screens!.length, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context)!.settings.arguments as Character;

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
                                        (_tabController.index == e.$1
                                            ? '_on'
                                            : '_off'))
                                    .toIcon(height: 22),
                                const SizedBox(width: Measures.hMarginSmall),
                                Text(
                                  e.$2.key,
                                  style: _tabController.index == e.$1
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
