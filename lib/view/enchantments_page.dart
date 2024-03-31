import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/radio_button.dart';

import 'partial/gradient_background.dart';

enum EnchantmentFilter {
  charmer('Incantatore', Palette.primaryGreen),
  level('Livello', Palette.primaryRed),
  type('Tipo', Palette.primaryBlue);

  final String title;
  final Color color;

  const EnchantmentFilter(this.title, this.color);
}

class EnchantmentsPage extends StatefulWidget {
  const EnchantmentsPage({super.key});

  @override
  State<EnchantmentsPage> createState() => _EnchantmentsPageState();
}

class _EnchantmentsPageState extends State<EnchantmentsPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundMagenta),
          // Header + Body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(
                      top: Measures.vMarginBig, bottom: Measures.vMarginSmall),
                  child: GestureDetector(
                    onTap: () {
                      throw UnimplementedError();
                    },
                    child: SvgPicture.asset('assets/images/icons/menu.svg',
                        height: 24),
                  ),
                ),
                // Body
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: Measures.vMarginMed),
                        Text('Che incantesimo stai cercando?',
                            style: Fonts.black()),
                        const SizedBox(height: Measures.vMarginMed),
                        // Search TextField
                        GlassTextField(
                          iconPath: 'search_alt',
                          hintText: 'Cerca un incantesimo',
                          textController: _searchController,
                        ),
                        // Filters
                        GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            shrinkWrap: true,
                            crossAxisSpacing: 10,
                            children: List.generate(
                                EnchantmentFilter.values.length,
                                (i) => RadioButton(
                                    text: EnchantmentFilter.values[i].title,
                                    color: EnchantmentFilter.values[i].color))),
                        // Found enchantments
                        const SizedBox(height: Measures.vMarginMed),
                        Column(
                            children: List.generate(
                                DataManager().enchantments.length,
                                (i) => enchantmentCard(
                                    DataManager().enchantments[i])))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  enchantmentCard(Enchantment model) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: GlassCard(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name, style: Fonts.bold(size: 18)),
                    Text(model.type.title, style: Fonts.light(size: 16)),
                  ],
                ),
                // Level
                Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(BorderSide(
                            color: Palette.primaryYellow, width: 1))),
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
