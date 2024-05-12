import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart' as ch show Alignment;
import 'package:scheda_dnd_5e/model/character.dart' hide Alignment;

// import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/filter.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';

import '../constant/fonts.dart';
import '../constant/measures.dart';
import 'home_page.dart';
import 'partial/radio_button.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late final TextEditingController _searchController;
  late final List<Filter> _filters;

  List<Character> get _characters =>
      (AccountManager().user.characters.value ?? [])
          .where((e) =>
              _filters.every((filter) => filter.checkFilter(e)) &&
              e.name.match(_searchController.text))
          .toList()
        ..sort()
        ..reversed;

  bool get isDataReady => AccountManager().user.characters.value != null;

  @override
  void initState() {
    HomePage.onFabTaps[widget.runtimeType] = () async {
      await Navigator.of(context).pushNamed('/create_character');
      refresh();
    };
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _filters = [
      Filter<Character, Class>('Classe', Palette.primaryGreen, Class.values,
          (character, values) => values.contains(character.class_)),
      Filter<Character, Race>('Razza', Palette.primaryRed, Race.values,
          (character, values) => values.contains(character.race)),
      Filter<Character, ch.Alignment>(
          'Allineamento',
          Palette.primaryBlue,
          ch.Alignment.values,
          (character, values) => values.contains(character.alignment)),
    ];
    AccountManager().user.characters.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characters = _characters;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Measures.vMarginBig),
          // Body
          Expanded(
            child: Column(children: [
              const SizedBox(height: Measures.vMarginMed),
              // Page Title
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('I tuoi personaggi', style: Fonts.black())),
              const SizedBox(height: Measures.vMarginMed),
              // Search TextField
              GlassTextField(
                iconPath: 'search_alt',
                hintText: 'Cerca un personaggio',
                textController: _searchController,
              ),
              // Filters
              if (characters.length > 5)
                GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    children: List.generate(
                        _filters.length,
                        (i) => RadioButton(
                            selected: _filters[i].selectedValues.isNotEmpty,
                            text: _filters[i].title,
                            color: _filters[i].color,
                            onPressed: () => _filters[i]
                                    .selectedValues
                                    .isNotEmpty
                                ? setState(
                                    () => _filters[i].selectedValues.clear())
                                : context.checkList(
                                    'Filtro su ${_filters[i].title.toLowerCase()}',
                                    values: _filters[i].values,
                                    color: _filters[i].color,
                                    onChanged: (value) => setState(() =>
                                        _filters[i]
                                            .selectedValues
                                            .toggle(value)),
                                    value: (value) => _filters[i]
                                        .selectedValues
                                        .contains(value),
                                  )))),
              // Found enchantments
              const SizedBox(height: Measures.vMarginSmall),
              // Nothing to show
              if (isDataReady && characters.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: Measures.vMarginSmall),
                  child: Text('Niente da mostrare',
                      style: Fonts.black(color: Palette.card2)),
                ),
              Expanded(
                child: ListView.builder(
                    itemCount: isDataReady ? characters.length : 10,
                    itemBuilder: (_, i) => isDataReady
                        ? characterCard(characters[i])
                        : const GlassCard(isShimmer: true, shimmerHeight: 75)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  characterCard(Character character) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GlassCard(
          onTap: () => Navigator.of(context)
              .pushNamed('/character', arguments: character),
          bottomSheetHeader: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  character.class_.iconPath.toIcon(height: 24),
                  const SizedBox(width: Measures.hMarginBig),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(character.name, style: Fonts.bold(size: 18)),
                      Text(character.subRace?.title ?? character.race.title,
                          style: Fonts.light(size: 16)),
                    ],
                  )
                ],
              ),
            ],
          ),
          bottomSheetItems: [
            BottomSheetItem('png/delete_2', 'Elimina', () async {
              AccountManager().user.deleteCharacter(character.uid!);
              setState(() {});
              bool hasUndone = false;
              await context.snackbar('Hai eliminato ${character.name}',
                  backgroundColor: Palette.backgroundBlue, bottomMargin: Measures.bottomBarHeight,undoCallback: () {
                hasUndone = true;
                AccountManager().user.restoreCharacter(character.uid!);
                setState(() {});
              });
              if (!hasUndone) {
                DataManager().save(AccountManager().user);
              }
            })
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              children: [
                // Class icon, name and race
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and type
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              character.class_.iconPath.toIcon(height: 24),
                              const SizedBox(width: Measures.hMarginBig),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(character.name,
                                      style: Fonts.bold(size: 18)),
                                  Text(
                                      character.subRace?.title ??
                                          character.race.title,
                                      style: Fonts.light(size: 16)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Measures.hMarginMed),
                    // Level
                    Level(level: character.level, maxLevel: 10),
                  ],
                ),
                const SizedBox(height: Measures.vMarginThin),
                // HP bar
                HpBar(character.hp, character.maxHp),
              ],
            ),
          ),
        ),
      );

  // Refreshing the characters UIDs
  refresh() {
    AccountManager().user.characters.value = null;
    Future.delayed(Durations.medium1, () async {
      final startTime = DateTime.now();
      await AccountManager().reloadUser();
      await DataManager().loadUserCharacters(AccountManager().user);
      print(
          'CharactersPage:refresh() --> ${DateTime.now().difference(startTime).inMilliseconds} millis');
    });
  }
}
