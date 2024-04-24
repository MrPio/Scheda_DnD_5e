import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/extension/function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension/function/list_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart' as ch show Alignment;
import 'package:scheda_dnd_5e/model/character.dart' hide Alignment;
import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/filter.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';

import '../enum/fonts.dart';
import '../enum/measures.dart';
import 'partial/radio_button.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late final TextEditingController _searchController;
  late final List<Filter> _filters;

  List<Character> get _characters => AccountManager().user.characters;

  bool get isDataReady => true; //DataManager().enchantments.value != null;

  @override
  void initState() {
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
              Align(alignment: Alignment.centerLeft,child: Text('I tuoi personaggi', style: Fonts.black())),
              const SizedBox(height: Measures.vMarginMed),
              // Search TextField
              GlassTextField(
                iconPath: 'search_alt',
                hintText: 'Cerca un personaggio',
                textController: _searchController,
              ),
              // Filters
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
                              ? setState(
                                  () => _filters[i].selectedValues.clear())
                              : context.checklist(
                                  'Filtro su ${_filters[i].title.toLowerCase()}',
                                  values: _filters[i].values,
                                  color: _filters[i].color,
                                  onChanged: (value) => setState(() =>
                                      _filters[i].selectedValues.toggle(value)),
                                  value: (value) => _filters[i]
                                      .selectedValues
                                      .contains(value),
                                )))),
              // Found enchantments
              const SizedBox(height: Measures.vMarginSmall),
              // Nothing to show
              if (isDataReady && characters.isEmpty)
                Align(
                    child: Text('Niente da mostrare',
                        style: Fonts.black(color: Palette.card2))),
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

  characterCard(Character model) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GlassCard(
          onTap: () =>
              Navigator.of(context).pushNamed('/character', arguments: model),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and type
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          child: Text(model.name, style: Fonts.bold(size: 18))),
                      Text(model.subRace?.title ?? model.race.title,
                          style: Fonts.light(size: 16)),
                    ],
                  ),
                ),
                const SizedBox(width: Measures.hMarginMed),
                // Level
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(BorderSide(
                            color: Color.lerp(Palette.primaryYellow,
                                Palette.primaryRed, model.level / 10.0)!,
                            width: 2))),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(model.level.toString(),
                          style: Fonts.regular(size: 16)),
                    )),
              ],
            ),
          ),
        ),
      );
}
