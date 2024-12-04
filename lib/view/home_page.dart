import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/view/characters_page.dart';
import 'package:scheda_dnd_5e/view/dice_page.dart';
import 'package:scheda_dnd_5e/view/enchantments_page.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/fab.dart';
import 'package:scheda_dnd_5e/view/user_page.dart';

import 'partial/glass_bottom_bar_icon.dart';
import 'partial/decoration/gradient_background.dart';

class HomePage extends StatefulWidget {
  static Map<Type, Function()> onFabTaps = {};

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
    const ProfilePage(),
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
    Palette.backgroundGrey
  ];
  final fabs = [
    FABArgs(
      color: Palette.primaryBlue,
      icon: 'add',
      onPress: () => HomePage.onFabTaps[CharactersPage]?.call(),
      bottomMargin: Measures.bottomBarHeight + Measures.vMarginThin,
    ),
    null,
    FABArgs(
      color: Palette.primaryGreen,
      icon: 'refresh',
      onPress: () => HomePage.onFabTaps[DicePage]?.call(),
      bottomMargin: Measures.bottomBarHeight + Measures.vMarginThin,
    ),
    null,
    null
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
            if (fabs[_index] != null) FAB(fabs[_index]!),
          ]),
          // Bottom bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding)
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
                      onTap: () => _pageController.animateToPage(i,
                          duration: Durations.medium3 * pow((_index - i).abs(), 0.7),
                          curve: Curves.easeOutCubic));
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
