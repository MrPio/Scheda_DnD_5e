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
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/recycler_view.dart';

import '../constant/fonts.dart';
import '../constant/measures.dart';
import 'home_page.dart';
import 'partial/radio_button.dart';

/// The arguments to receive when CharacterPage navigates to this page
class CharacterPageToCharactersPageArgs {
  final bool noChanges;

  CharacterPageToCharactersPageArgs({this.noChanges = false});
}

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late final TextEditingController _searchController;
  late final List<Filter> _filters;

  List<Character> get _characters => (AccountManager().user.characters.value ?? [])
      .where((e) =>
          _filters.every((filter) => filter.checkFilter(e)) &&
          e.name.match(_searchController.text, contains: true))
      .toList()
    ..sort();

  bool get isDataReady => AccountManager().user.characters.value != null;

  @override
  void initState() {
    HomePage.onFabTaps[widget.runtimeType] =
        () => context.goto('/create_character', then: (_) => refresh());

    _filters = [
      Filter<Character, Class>('Classe', Palette.primaryGreen, Class.values,
          (character, values) => values.contains(character.class_)),
      Filter<Character, Race>('Razza', Palette.primaryRed, Race.values,
          (character, values) => values.contains(character.race)),
      Filter<Character, ch.Alignment>('Allineamento', Palette.primaryBlue, ch.Alignment.values,
          (character, values) => values.contains(character.alignment)),
    ];

    // Refresh UI when the search string changes
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    // Refresh UI when the user's characters list changes
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
    if (mounted) _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characters = _characters;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
        child: RecyclerView(
          header: Column(
            children: [
              const SizedBox(height: Measures.vMarginBig + Measures.vMarginMed),
              // Page Title
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('I tuoi personaggi', style: Fonts.black()),
                'png/settings'
                    .toIcon(padding: const EdgeInsets.all(6), onTap: () => context.goto('/settings')),
              ]),
              const SizedBox(height: Measures.vMarginMed),
              // Search TextField
              GlassTextField(
                iconPath: 'search_alt',
                hintText: 'Cerca un personaggio',
                textController: _searchController,
              ),
              // Filters
              if (AccountManager().user.charactersUIDs.length > 5)
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
                            onPressed: () => _filters[i].selectedValues.isNotEmpty
                                ? setState(() => _filters[i].selectedValues.clear())
                                : context.checkList(
                                    'Filtro su ${_filters[i].title.toLowerCase()}',
                                    values: _filters[i].values,
                                    color: _filters[i].color,
                                    onChanged: (value) =>
                                        setState(() => _filters[i].selectedValues.toggle(value)),
                                    value: (value) => _filters[i].selectedValues.contains(value),
                                  )))),
              const SizedBox(height: Measures.vMarginSmall),
              // Nothing to show
              if (isDataReady && characters.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: Measures.vMarginSmall),
                  child: Text('Niente da mostrare', style: Fonts.black(color: Palette.card2)),
                ),
            ],
          ),
          children: isDataReady
              ? characters.map<Widget>(characterCard).toList()
              : List.filled(10, const GlassCard(isShimmer: true, shimmerHeight: 75)),
        ));
  }

  /// The card for a character, made of name, race icon, hp bar and level.
  Widget characterCard(Character character) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GlassCard(
          onTap: () => gotoCharacter(character),
          bottomSheetArgs: BottomSheetArgs(
              header: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          character.class_.iconPath.toIcon(),
                          const SizedBox(width: Measures.hMarginBig),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(character.name, style: Fonts.bold()),
                              Text(character.subRace?.title ?? character.race.title,
                                  style: Fonts.light()),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: Measures.hMarginBig * 2),
                  // Flexible(child: HpBar(character.hp, character.maxHp,showText: false,))
                ],
              ),
              items: [
                BottomSheetItem('png/open', 'Visualizza scheda', () => gotoCharacter(character)),
                BottomSheetItem('png/delete_2', 'Elimina', () async {
                  context.popup('Stai per eliminare un personaggio',
                      message:
                          'Sei sicuro di voler eliminare **${character.name}**? (Potrai recuperarlo in seguito)',
                      positiveCallback: () async {
                    AccountManager().user.deleteCharacter(character.uid!);
                    setState(() {});
                    bool hasUndone = false;
                    await context.snackbar('Hai eliminato ${character.name}',
                        backgroundColor: Palette.backgroundBlue,
                        bottomMargin: Measures.bottomBarHeight, undoCallback: () {
                      hasUndone = true;
                      AccountManager().user.restoreCharacter(character.uid!);
                      setState(() {});
                    });
                    if (!hasUndone) {
                      print('⬆️ Ho salvato la rimozione del\'personaggio ${character.name}');
                      DataManager().save(AccountManager().user);
                    }
                  },
                      negativeCallback: () {},
                      positiveText: 'Si',
                      negativeText: 'No',
                      backgroundColor: Palette.background.withOpacity(0.5));
                })
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                              character.class_.iconPath.toIcon(),
                              const SizedBox(width: Measures.hMarginBig),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(character.name, style: Fonts.bold()),
                                  Text(character.subRace?.title ?? character.race.title,
                                      style: Fonts.light()),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Measures.hMarginSmall),
                    // Level
                    Level(level: character.level, maxLevel: 20),
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

  /// When returning from the character page, reload if any changes have been applied
  gotoCharacter(Character character) => context.goto('/character', arguments: character, then: (args) {
        ScaffoldMessenger.of(context).clearSnackBars();
        args is CharacterPageToCharactersPageArgs && !args.noChanges ? null : refresh();
      });

  /// Refresh the characters UIDs
  refresh() {
    // Trigger the shimmer effect through to the listener defined above
    AccountManager().user.characters.value = null;

    // Reload user without cache and characters with cache
    Future.delayed(Durations.medium1, () async {
      final startTime = DateTime.now();
      await AccountManager().reloadUser();
      await DataManager().loadUserCharacters(AccountManager().user);
      print('CharactersPage:refresh() --> ${DateTime.now().difference(startTime).inMilliseconds} millis');
    });
  }
}
