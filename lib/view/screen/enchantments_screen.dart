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
import 'package:scheda_dnd_5e/model/enchantment.dart' as enc show Level;
import 'package:scheda_dnd_5e/model/enchantment.dart' hide Level;
import 'package:scheda_dnd_5e/model/filter.dart';
import 'package:scheda_dnd_5e/view/partial/card/enchantment_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/layout/recycler_view.dart';
import 'package:scheda_dnd_5e/view/partial/page_header.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';

import '../../enum/class.dart';
import '../../interface/enum_with_title.dart';
import '../enchantments_page.dart';

class EnchantmentsScreen extends StatefulWidget {
  final EnchantmentsArgs? args;

  const EnchantmentsScreen({this.args, super.key});

  @override
  State<EnchantmentsScreen> createState() => _EnchantmentsScreenState();
}

class _EnchantmentsScreenState extends State<EnchantmentsScreen> {
  EnchantmentsArgs? get args => widget.args;
  late final TextEditingController _searchController;
  late final List<Filter> _filters;

  List<Enchantment> get _enchantments => DataManager()
      .cachedEnchantments
      .where((e) =>
          _filters.every((filter) => filter.checkFilter(e)) &&
          e.name.match(_searchController.text, contains: true))
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
    // Getting any args
    // args.addListener(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(args?.filterClasses);
      if (args?.filterClasses != null) {
        if (args!.filterClasses!.any((c) => _filters[0].values.contains(c))) {
          _filters[0].selectedValues.addAll(args!.filterClasses!);
        } else {
          context.snackbar('Le classi attuali non consentono gli incantesimi',
              backgroundColor: Palette.backgroundPurple);
          args?.filterClasses = null;
        }
      }
    });
    // });
    // Forcing shimmer effect
    final tmpEnchantments = DataManager().cachedEnchantments;
    DataManager().cachedEnchantments = [];
    Future.delayed(Durations.medium1,
        !mounted ? null : () => setState(() => DataManager().cachedEnchantments = tmpEnchantments));
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
    return RecyclerView(
        header: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
              child: PageHeader(
                  title: args?.title ?? 'Che incantesimo stai cercando?', isPage: args != null),
            ),

            // Search TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
              child: GlassTextField(
                iconPath: 'search_alt',
                hintText: 'Cerca un incantesimo',
                textController: _searchController,
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
              child: DynamicHeightGridView(
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
                      onPressed: () => e.selectedValues.isNotEmpty &&
                              !(args?.filterClasses != null && i == 0)
                          ? setState(() => e.selectedValues.clear())
                          : context.checkList(
                              'Filtro su ${e.title.toLowerCase()}',
                              name: (e) => EnumWithTitle.titles[[Class, enc.Level, Type][i]]!(e, context),
                              values: e.values,
                              color: e.color,
                              onChanged: args?.filterClasses != null && i == 0
                                  ? null
                                  : (value) => setState(() => e.selectedValues.toggle(value)),
                              value: (value) => e.selectedValues.contains(value),
                            ));
                },
              ),
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
            ? enchantments
                .map<Widget>((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                      child: EnchantmentCard(e, onTap: args != null ? () => context.pop(e.uid) : null),
                    ))
                .toList()
            : List.filled(
                10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                  child: const GlassCard(isShimmer: true, shimmerHeight: 75),
                )));
  }
}
