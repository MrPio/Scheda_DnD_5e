import 'dart:core' as core show Type;
import 'dart:core' hide Type;

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart' hide Alignment;
import 'package:scheda_dnd_5e/model/enchantment.dart' as enc show Level;
import 'package:scheda_dnd_5e/model/enchantment.dart' hide Level;
import 'package:scheda_dnd_5e/model/filter.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';
import 'package:scheda_dnd_5e/view/partial/recycler_view.dart';

class EnchantmentsPage extends StatefulWidget {
  const EnchantmentsPage({super.key});

  @override
  State<EnchantmentsPage> createState() => _EnchantmentsPageState();
}

class _EnchantmentsPageState extends State<EnchantmentsPage> {
  late final TextEditingController _searchController;
  late final List<Filter> _filters;

  List<Enchantment> get _enchantments => DataManager()
      .cachedEnchantments
      .where((e) =>
          _filters.every((filter) => filter.checkFilter(e)) && e.name.match(_searchController.text))
      .toList()
    ..sort();

  bool get isDataReady => DataManager().cachedEnchantments.isNotEmpty;

  @override
  void initState() {
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _filters = [
      Filter<Enchantment, Class>(
          'Classe',
          Palette.primaryGreen,
          Class.values.where((e) => e.isEnchanter).toList(),
          (enchantment, values) => enchantment.classes.any((c) => values.contains(c))),
      Filter<Enchantment, enc.Level>('Livello', Palette.primaryRed, enc.Level.values,
          (enchantment, values) => values.contains(enchantment.level)),
      Filter<Enchantment, Type>('Tipo', Palette.primaryBlue, Type.values,
          (enchantment, values) => values.contains(enchantment.type)),
    ];
    // Forcing shimmer effect
    final tmpEnchantments = DataManager().cachedEnchantments;
    DataManager().cachedEnchantments=[];
    Future.delayed(
        Durations.medium1, () => setState(() => DataManager().cachedEnchantments = tmpEnchantments));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enchantments = _enchantments;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
        child: RecyclerView(
            header: Column(
              children: [
                const SizedBox(height: Measures.vMarginBig + Measures.vMarginMed),
                // Page Title
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Che incantesimo stai cercando?', style: Fonts.black())),
                const SizedBox(height: Measures.vMarginMed),
                // Search TextField
                GlassTextField(
                  iconPath: 'search_alt',
                  hintText: 'Cerca un incantesimo',
                  textController: _searchController,
                ),
                const SizedBox(height: Measures.vMarginSmall),

                // Filters
                DynamicHeightGridView(
                  itemCount: _filters.length,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  builder: (context, i) {
                    final e = _filters[i];
                    return RadioButton(
                        selected: e.selectedValues.isNotEmpty,
                        text: e.title,
                        color: e.color,
                        onPressed: () => e.selectedValues.isNotEmpty
                            ? setState(() => e.selectedValues.clear())
                            : context.checkList(
                                'Filtro su ${e.title.toLowerCase()}',
                                values: e.values,
                                color: e.color,
                                onChanged: (value) => setState(() => e.selectedValues.toggle(value)),
                                value: (value) => e.selectedValues.contains(value),
                              ));
                  },
                ),
                const SizedBox(height: Measures.vMarginSmall),
                // Nothing to show
                if (isDataReady && enchantments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: Measures.vMarginSmall),
                    child: Text('Niente da mostrare', style: Fonts.black(color: Palette.card2)),
                  ),
              ],
            ),
            children: isDataReady
                ? enchantments.map<Widget>(enchantmentCard).toList()
                : List.filled(10, const GlassCard(isShimmer: true, shimmerHeight: 75))));
  }

  Widget enchantmentCard(Enchantment enchantment) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GlassCard(
          bottomSheetArgs: BottomSheetArgs(
              header: Row(
                children: [
                  Level(level: enchantment.level.num, maxLevel: 9),
                  const SizedBox(width: Measures.hMarginBig),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(enchantment.name, style: Fonts.bold()),
                      Text(enchantment.type.title, style: Fonts.light()),
                    ],
                  )
                ],
              ),
              items: [
                BottomSheetItem('png/open', 'Visualizza dettagli',
                    () => Navigator.of(context).pushNamed('/enchantment', arguments: enchantment)),
              ]),
          onTap: () => Navigator.of(context).pushNamed('/enchantment', arguments: enchantment),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and type
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(child: Text(enchantment.name, style: Fonts.bold())),
                      Text(enchantment.type.title, style: Fonts.light()),
                    ],
                  ),
                ),
                const SizedBox(width: Measures.hMarginMed),
                // Level
                Level(level: enchantment.level.num, maxLevel: 9),
              ],
            ),
          ),
        ),
      );
}
