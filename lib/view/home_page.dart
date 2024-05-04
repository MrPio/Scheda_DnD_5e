import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/characters_page.dart';
import 'package:scheda_dnd_5e/view/dice_page.dart';
import 'package:scheda_dnd_5e/view/enchantments_page.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:tuple/tuple.dart';

import 'partial/glass_bottom_bar_icon.dart';
import 'partial/gradient_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _screens = [
    const CharactersPage(),
    const Placeholder(),
    const DicePage(),
    const EnchantmentsPage(),
    const Placeholder(),
  ];
  final _screenNames = [
    'Personaggi',
    'Campagne',
    'Dadi',
    'Incantesimi',
    'Profilo',
  ];
  final _screenIconPaths = [
    'png/manuscript',
    'png/tower',
    'png/dice',
    'png/scepter',
    'png/user',
  ];
  final _colors = [
    Palette.backgroundBlue,
    Palette.backgroundPurple,
    Palette.backgroundGreen,
    Palette.backgroundPurple,
    Palette.backgroundBlue
  ];

  late final PageController _pageController;
  var _index = 0;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _index = _pageController.page?.toInt() ?? 0;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fabs = [
      Tuple3(() => Navigator.of(context).pushNamed('/create_character'),
          Palette.primaryBlue, 'add'),
      null, null, null, null
    ];
    return Scaffold(
      backgroundColor: Palette.background,
      body: Stack(
        children: [
          // Background
          GradientBackground(topColor: _colors[_index]),
          // Foreground
          Stack(children: [
            // Page content
            PageView(
              controller: _pageController,
              children: _screens,
            ),
            // Bottom vignette
            const BottomVignette(),
            // FAB
            if(fabs[_index] != null)
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: Measures.fABBottomMargin,right: Measures.hPadding),
                    child: FloatingActionButton(
                      onPressed: fabs[_index]!.item1,
                      elevation: 0,
                      foregroundColor: fabs[_index]!.item2,
                      backgroundColor: fabs[_index]!.item2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999)),
                      child: fabs[_index]!.item3.toIcon(height: 20),
                    ),
                  )),
          ]),
          // Bottom bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: Measures.hPadding)
                  .copyWith(top: Measures.vMarginThin)
                  .copyWith(bottom: Measures.vMarginThin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _screens.map((e) {
                  final i = _screens.indexOf(e);
                  return GlassBottomBarIcon(
                    title: _screenNames[i],
                    iconPathOn: '${_screenIconPaths[i]}_on',
                    iconPathOff: '${_screenIconPaths[i]}_off',
                    active: _index == i,
                    onTap: () =>
                        setState(() =>
                            _pageController.animateToPage(i,
                                duration: Durations.medium3 *
                                    pow((_index - i).abs(), 0.7),
                                curve: Curves.easeOutCubic)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
