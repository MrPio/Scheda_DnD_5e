import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/enum/race.localized.g.part';
import 'package:scheda_dnd_5e/enum/subrace.localized.g.part';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart';
// import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/filter.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/layout/recycler_view.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/page_header.dart';

import '../../constant/fonts.dart';
import '../../constant/measures.dart';
import '../../enum/character_alignment.dart';
import '../../enum/class.dart';
import '../../enum/race.dart';
import '../../interface/enum_with_title.dart';
import '../home_page.dart';
import '../partial/radio_button.dart';

/// The arguments to receive when CharacterPage navigates to this page
class CharacterPageToCharactersPageArgs {
  final bool noChanges;

  CharacterPageToCharactersPageArgs({this.noChanges = false});
}

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
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
    HomePage.onFabTaps[widget.runtimeType] = () async {
      await context.goto('/create_character');
      refresh();
    };

    _filters = [
      Filter<Character, Class>('Classe', Palette.primaryGreen, Class.values,
          (character, values) => character.classes.keys.any((c) => values.contains(c))),
      Filter<Character, Race>('Razza', Palette.primaryRed, Race.values,
          (character, values) => values.contains(character.race)),
      Filter<Character, CharacterAlignment>('Allineamento', Palette.primaryBlue,
          CharacterAlignment.values, (character, values) => values.contains(character.alignment)),
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
            // Page Title
            PageHeader(title: 'I tuoi personaggi', isPage: false),
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
                                  name: (e) => EnumWithTitle
                                      .titles[[Class, Race, CharacterAlignment][i]]!(e, context),
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
                child: Text('Crea il tuo primo personaggio!', style: Fonts.black(color: Palette.card2)),
              ),
          ],
        ),
        children: isDataReady
            ? characters.map<Widget>(characterCard).toList()
            : List.filled(10, const GlassCard(isShimmer: true, shimmerHeight: 75)),
      ),
    );
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
                          character.classes.entries.reduce((a, b) => a.value > b.value ? a : b).key.iconPath.toIcon(),
                          const SizedBox(width: Measures.hMarginBig),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(character.name, style: Fonts.bold()),
                              Text(character.subRace?.title(context) ?? character.race.title(context),
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
                      backgroundColor: Palette.backgroundGrey.withValues(alpha: 0.2));
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
                              character.classes.entries.reduce((a, b) => a.value > b.value ? a : b).key.iconPath.toIcon(),
                              const SizedBox(width: Measures.hMarginBig),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(character.name, style: Fonts.bold()),
                                  Text(character.subRace?.title(context) ?? character.race.title(context),
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
  gotoCharacter(Character character) async {
    final args = await context.goto('/character', args: character);
    ScaffoldMessenger.of(context).clearSnackBars();
    args is CharacterPageToCharactersPageArgs && !args.noChanges ? null : refresh();
  }

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
