import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/iterable_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/model/loot.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/card/dice_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/loading_view.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../constant/dictionary.dart';
import '../constant/fonts.dart';
import '../constant/measures.dart';
import '../constant/palette.dart';
import '../enum/dice.dart';
import '../interface/json_serializable.dart';
import '../mixin/validable.dart';

class CreateItemArgs {
  final Type type;

  CreateItemArgs(this.type);
}

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> with Validable, Loadable {
  CreateItemArgs? args;
  List<InventoryItem?> items = [null, null, null];
  late final PageController _pageController;
  final _nameController = TextEditingController(), _propertyController = TextEditingController();
  final List<Dice> _selectedDice = [];
  static const int maxSelection = 9;
  final TextEditingController _fixedDamageController = TextEditingController(text: '0');
  final int fixedDamageMin = -99, fixedDamageMax = 99;

  /// The integer value of the modifier
  int get fixedDamage => int.parse(_fixedDamageController.text);

  set fixedDamage(int value) => setState(
      () => _fixedDamageController.text = max(fixedDamageMin, min(fixedDamageMax, value)).toString());

  InventoryItem get item => items[_index]!;

  Function get constructor => JSONSerializable.modelFactories[args!.type]!;

  List<Widget>? _screens;
  List<Function()?>? _bottomButtons;

  int _index = 0;

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
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = (ModalRoute.of(context)!.settings.arguments) as CreateItemArgs?;
    items[0] ??= constructor(<String, dynamic>{});
    _screens = [
      // Choose name
      Column(children: [
        // Title
        Row(
          children: [
            InventoryItem.icons[args!.type]!.toIcon(),
            const SizedBox(width: Measures.hMarginMed),
            Align(alignment: Alignment.centerLeft, child: Text('Assegna un nome', style: Fonts.black())),
          ],
        ),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Come vuoi chiamare il tuo nuovo oggetto?', style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Search TextField
        GlassTextField(
          iconPath: 'png/edit',
          hintText: 'Un nome  di ${InventoryItem.namesSingulars[args!.type]!.toLowerCase()}',
          secondaryIconPath: 'png/random',
          onSecondaryIconTap: () {
            _nameController.text =
                '${Dictionary.itemNames[args!.type]!.random} ${Dictionary.itemAdjectives.random}';
            setState(() {});
          },
          textController: _nameController,
          autofocus: true,
          onSubmitted: (text) {
            if (validate(() => item.title = text)) {
              next();
            }
          },
          textInputAction: TextInputAction.next,
        ),
      ]),
      // Roll + fixed damage
      if (args!.type == Weapon)
        Column(children: [
          // Title
          Row(
            children: [
              InventoryItem.icons[args!.type]!.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Specifica i danni dell\'arma', style: Fonts.black())),
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          // Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Quanti danni variabili e fissi infligge la tua arma?', style: Fonts.light()),
          ),
          const SizedBox(height: Measures.vMarginMed),
          // Variable damage
          Row(
            children: [
              'png/dice_on'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Danni variabli', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginSmall),
          // Selected dice list
          GlassCard(
              height: ((_selectedDice.length - 1) ~/ 3 + 1) * 88,
              clickable: false,
              child: Align(
                child: _selectedDice.isEmpty
                    ? Text('Seleziona i dadi di danno', style: Fonts.regular(color: Palette.hint))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: Measures.vMarginSmall,
                          crossAxisSpacing: Measures.vMarginSmall,
                          padding: const EdgeInsets.all(10.0),
                          childAspectRatio: 1.4,
                          children: List.generate(_selectedDice.length, dice),
                        ),
                      ),
              )),
          const SizedBox(height: Measures.vMarginSmall),
          // Selectable dices
          GridRow(
            crossAxisSpacing: Measures.vMarginThin,
            mainAxisSpacing: Measures.vMarginThin,
            columnsCount: 3,
            children: Dice.values.map((dice) => DiceCard(dice, onTap: selectDice)).toList(),
          ),
          const SizedBox(height: Measures.vMarginSmall),
          // Fixed damage
          Row(
            children: [
              'png/damage'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Danni fissi', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginSmall),
          // Fixed damage numeric input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(999)), color: Palette.card2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    onPressed: () => fixedDamage--,
                    onLongPress: () => fixedDamage -= 5,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.background,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.remove, color: Palette.onBackground, size: 26),
                  ),
                ),
                const SizedBox(width: Measures.hMarginMed),
                NumericInput(NumericInputArgs(
                  min: fixedDamageMin,
                  max: fixedDamageMax,
                  controller: _fixedDamageController,
                  width: 60,
                  contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  style: Fonts.black(),
                )),
                const SizedBox(width: Measures.hMarginMed),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    onPressed: () => fixedDamage++,
                    onLongPress: () => fixedDamage += 5,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.background,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.add, color: Palette.onBackground, size: 26),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: Measures.vMarginMed),
          // Fixed damage
          Row(
            children: [
              'png/property'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Proprietà aggiuntive', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginSmall + Measures.vMarginMoreThin),
          GlassTextField(
            hintText: 'Caratteristiche sul tipo di danno',
            secondaryIconPath: 'png/random',
            onSecondaryIconTap: () {
              _propertyController.text =
                  DataManager().appInventoryItems.whereType<Weapon>().map((e) => e.property).random;
              setState(() {});
            },
            lines: 3,
            textController: _propertyController,
            textInputAction: TextInputAction.none,
          ),

          const SizedBox(height: Measures.vMarginBig * 3),
        ]),
    ];
    _bottomButtons ??= [
      // Choose name page
      () {
        if (validate(() => item.title = _nameController.text)) {
          next();
        }
      },
      if (args!.type == Weapon)
        // Damage page
        () {
          if (validate(() => (item as Weapon).rollDamage = _selectedDice)) {
            (item as Weapon).fixedDamage = fixedDamage;
            (item as Weapon).property = _propertyController.text;
            next();
          }
        }
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: _index != 5,
        body: Stack(
          children: [
            // Background
            const GradientBackground(topColor: Palette.backgroundBlue),
            // Page content
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _screens!
                  .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.only(top: Measures.vMarginBig * 2 + Measures.vMarginSmall),
                        child: e,
                      )))
                  .toList(),
            ),
            // Chevron
            Chevron(onTap: previous),
            // Bottom vignette
            const BottomVignette(height: 0, spread: 80),
            // Bottom points
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measures.hPadding, vertical: Measures.vMarginMed),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Continue button
                    if (_bottomButtons?[_index] != null)
                      GlassButton(
                        'PROSEGUI',
                        color: Palette.primaryBlue,
                        onTap: _bottomButtons?[_index],
                      ),
                    const SizedBox(height: Measures.vMarginMed),
                    // Bottom Progress
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                            _screens?.length ?? 0,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3.2),
                                  child: AnimatedContainer(
                                    height: _index == index ? 13 : 11,
                                    width: _index == index ? 13 : 11,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(999),
                                        color: _index == index ? Palette.onBackground : Palette.card),
                                    duration: Durations.medium3,
                                  ),
                                )))
                  ],
                ),
              ),
            ),
            // LoadingView
            LoadingView(visible: isLoading)
          ],
        ),
      ),
    );
  }

  Widget dice(int i) => GestureDetector(
        onTap: () => setState(() => _selectedDice.removeAt(i)),
        child: SvgPicture.asset(_selectedDice[i].svgPath, height: double.infinity),
      );

  selectDice(Dice dice) {
    if (_selectedDice.length < maxSelection) {
      setState(() => _selectedDice.add(dice));
    } else {
      context.snackbar('Non puoi aggiungere altri dadi',
          backgroundColor: Palette.backgroundBlue,
          bottomMargin: args == null ? Measures.bottomBarHeight : Measures.vMarginSmall);
    }
  }

  next({int step = 1}) {
    if (_index + step >= (_screens?.length ?? 0)) {
      // The item creation is completed, save the item
      withLoading(() async {
        // item.uid = await DataManager().save(item, SaveMode.post);
        // AccountManager().user.itemsUIDs.add(item.uid!);
        // await DataManager().save(AccountManager().user);
        // Navigator.of(context).pop();
      });
    } else {
      // Cloning the previous state
      for (var i = 1; i <= step; i++) {
        items[_index + i] = constructor(item.toJSON());
      }
      FocusManager.instance.primaryFocus?.unfocus();
      _pageController.animateToPage(_index + step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }

  previous() {
    // Reset the current screen state
    int step = 1; // Skipp-able screens
    if (_index > 0) {
      items[_index - step] =
          _index > 1 ? constructor(items[_index - step - 1]!.toJSON()) : constructor(<String, dynamic>{});
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (_index == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.animateToPage(_index - step,
          duration: Durations.medium1, curve: Curves.easeOutCubic);
    }
  }
}
