import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/home_page.dart';
import 'package:scheda_dnd_5e/view/partial/card/dice_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class DiceArgs {
  final String title;
  final List<Dice>? dices;
  final int? modifier;
  final bool oneShot;

  DiceArgs(
      {this.title = 'Dadi', this.dices, this.modifier, this.oneShot = false});
}

class _DicePageState extends State<DicePage>
    with SingleTickerProviderStateMixin {
  late DiceArgs args;
  List<Dice> _selectedDice = [];
  List<int> _diceValues = List<int>.filled(maxSelection, 0);
  bool _isRolling = false;
  static const int maxSelection = 12,
      rollDuration = 1200,
      rollsCount = 3,
      minModifier = -20,
      maxModifier = 20;
  late final AnimationController _diceRotationController;
  final TextEditingController _modifierController =
      TextEditingController(text: '0');

  /// The integer value of the modifier
  int get modifier => int.parse(_modifierController.text);

  set modifier(int value) =>
      setState(() => _modifierController.text = value.toString());

  /// The number of columns of the selected dice grid is calculated according to the number of the dice
  int get numberOfCols {
    switch (_selectedDice.length) {
      case > 6:
        return 4;
      case > 3:
        return 3;
      default:
        return _selectedDice.length;
    }
  }

  /// The ratio of the selected dice is calculated according to their number.
  /// A height cover policy is then used to resize the icons
  double get ratio {
    switch (_selectedDice.length) {
      case > 8:
        return 1.2;
      case > 6:
        return 1;
      case > 2:
        return 1.2;
      case 2:
        return 1.425;
      case 1:
        return 3;
      default:
        return 1;
    }
  }

  @override
  void initState() {
    HomePage.onFabTaps[widget.runtimeType] = roll;
    _diceRotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: rollDuration));
    super.initState();
  }

  @override
  void dispose() {
    _diceRotationController.dispose();
    _modifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args =
        (ModalRoute.of(context)!.settings.arguments ?? DiceArgs()) as DiceArgs;
    _selectedDice = args.dices ?? [];
    var page = Padding(
      padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(
                top: Measures.vMarginBig,
                bottom: Measures.vMarginSmall,
                left: 10,
                right: 10),
            child: Stack(children: [
              Align(child: Text(args.title, style: Fonts.black(size: 20))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: 'chevron_left'.toIcon(height: 24),
                  ),
                  if ((args.dices == null && _selectedDice.isNotEmpty) ||
                      (args.modifier == null && modifier != 0))
                    GestureDetector(
                      onTap: () {
                        _selectedDice = [];
                        modifier = 0;
                        setState(() {});
                      },
                      child: 'close'.toIcon(),
                    ),
                ],
              ),
            ]),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Selected dice ===============================
                  const SizedBox(height: Measures.vMarginSmall),
                  GlassCard(
                      height: 240,
                      clickable: false,
                      child: Align(
                        child: _selectedDice.isEmpty
                            ? Text('Seleziona i dadi da lanciare',
                                style: Fonts.regular(color: Palette.hint))
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: numberOfCols,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: Measures.vMarginSmall,
                                  crossAxisSpacing: Measures.vMarginSmall,
                                  padding: const EdgeInsets.all(10.0),
                                  childAspectRatio: ratio,
                                  children:
                                      List.generate(_selectedDice.length, dice),
                                ),
                              ),
                      )),
                  const SizedBox(height: Measures.vMarginSmall),
                  Column(children: [
                    // D4, D6, D8 dice ===============================
                    Row(
                      children: [
                        Expanded(
                            child: DiceCard(
                          Dice.d4,
                          onTap: selectDice,
                          clickable: args.dices == null,
                        )),
                        const SizedBox(width: Measures.vMarginThin),
                        Expanded(
                            child: DiceCard(Dice.d6,
                                onTap: selectDice,
                                clickable: args.dices == null)),
                        const SizedBox(width: Measures.vMarginThin),
                        Expanded(
                            child: DiceCard(Dice.d8,
                                onTap: selectDice,
                                clickable: args.dices == null)),
                      ],
                    ),
                    const SizedBox(height: Measures.vMarginThin),
                    //  D10, D12, D100 dice
                    Row(
                      children: [
                        Expanded(
                            child: DiceCard(Dice.d10,
                                onTap: selectDice,
                                clickable: args.dices == null)),
                        const SizedBox(width: Measures.vMarginThin),
                        Expanded(
                            child: DiceCard(Dice.d12,
                                onTap: selectDice,
                                clickable: args.dices == null)),
                        const SizedBox(width: Measures.vMarginThin),
                        Expanded(
                            child: DiceCard(Dice.d100,
                                onTap: selectDice,
                                clickable: args.dices == null)),
                      ],
                    ),
                    const SizedBox(height: Measures.vMarginThin),
                    // D20 Dice ===============================
                    DiceCard(Dice.d20,
                        onTap: selectDice, clickable: args.dices == null),
                    const SizedBox(height: Measures.vMarginSmall),
                  ]),
                  // Modifier
                  args.modifier == null
                      ? GlassCard(
                          clickable: false,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Modificatore',
                                        style: Fonts.regular())),
                                const SizedBox(height: Measures.vMarginSmall),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(999)),
                                      color: Palette.card2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (modifier > minModifier) {
                                              setState(() {
                                                modifier--;
                                              });
                                            }
                                          },
                                          onLongPress: () {
                                            if (modifier > minModifier + 4) {
                                              setState(() {
                                                modifier -= 5;
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Palette.background,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 13),
                                            elevation: 0,
                                          ),
                                          child: const Icon(Icons.remove,
                                              color: Palette.onBackground,
                                              size: 26),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: Measures.hMarginMed),
                                      NumericInput(
                                        minModifier,
                                        maxModifier,
                                        controller: _modifierController,
                                        width: 60,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                4, 8, 4, 8),
                                        style: Fonts.black(size: 28),
                                      ),
                                      const SizedBox(
                                          width: Measures.hMarginMed),
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (modifier < maxModifier) {
                                              setState(() {
                                                modifier++;
                                              });
                                            }
                                          },
                                          onLongPress: () {
                                            if (modifier < maxModifier - 4) {
                                              setState(() {
                                                modifier += 5;
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Palette.background,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 13),
                                            elevation: 0,
                                          ),
                                          child: const Icon(Icons.add,
                                              color: Palette.onBackground,
                                              size: 26),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : GlassCard(
                          clickable: false,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              children: [
                                Text('Modificatore:',
                                    style: Fonts.regular()),
                                const SizedBox(width: Measures.hMarginMed),
                                Text('${modifier.toSignString()} ${modifier.abs()}',
                                    style: Fonts.black(size: 24)),
                              ],
                            ),
                          ),
                        ),

                  // Bottom button
                  // const SizedBox(height: Measures.vMarginMed),
                  // GlassButton(
                  //   'LANCIA',
                  //   color: Palette.primaryGreen,
                  //   onTap: roll,
                  // ),
                  const SizedBox(
                      height: Measures.vMarginBig + Measures.vMarginBig),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return page;
    } else {
      return Scaffold(
        backgroundColor: Palette.background,
        body: Stack(
          children: [
            const GradientBackground(topColor: Palette.backgroundGreen),
            page,
            // FAB
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: Measures.fABBottomMargin,
                      right: Measures.hPadding),
                  child: FloatingActionButton(
                    onPressed: roll,
                    elevation: 0,
                    foregroundColor: Palette.primaryGreen,
                    backgroundColor: Palette.primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                    child: 'refresh'.toIcon(height: 20),
                  ),
                )),
          ],
        ),
      );
    }
  }

  selectDice(Dice dice) {
    if (_selectedDice.length < maxSelection) {
      _diceValues = List<int>.filled(maxSelection, 0);
      setState(() => _selectedDice.add(dice));
    } else {
      context.snackbar(
        'Non puoi aggiungere altri dadi',
        backgroundColor: Palette.backgroundGreen,
        bottomMargin: 90,
      );
    }
  }

  Widget dice(int i) => GestureDetector(
        onTap: () {
          _diceValues = List<int>.filled(maxSelection, 0);
          setState(() => _selectedDice.removeAt(i));
        },
        child: Stack(
          children: [
            // Dice svg
            RotationTransition(
                turns: Tween(begin: 0.0, end: rollsCount.toDouble()).animate(
                    CurvedAnimation(
                        parent: _diceRotationController,
                        curve: Curves.easeOut)),
                child: SvgPicture.asset(_selectedDice[i].svgPath,
                    height: double.infinity)),
            // Dice number
            if (_diceValues[i] > 0)
              Align(
                alignment: Alignment(0, _selectedDice[i].yTextAlignment),
                child: Text(_diceValues[i].toString(),
                    style: Fonts.bold(size: 18)),
              )
          ],
        ),
      );

  roll() {
    if (_selectedDice.isNotEmpty && !_isRolling) {
      _isRolling = true;
      setState(() {
        _diceValues = List<int>.filled(maxSelection, 0);
      });
      _diceRotationController.forward(from: 0);
      Future.delayed(Duration(milliseconds: (rollDuration * 0.8).toInt()), () {
        for (var i = 0; i < _diceValues.length; i++) {
          _selectedDice.length > i ? _diceValues[i] = _selectedDice[i].roll : 0;
        }
        setState(() {});
      });
      Future.delayed(const Duration(milliseconds: (rollDuration)), () async{
        // Show result
        _isRolling = false;
        await context.popup('Risultato del lancio',
            backgroundColor: Palette.popup,
            dismissible: !args.oneShot,
            positiveText: args.oneShot ? 'Conferma' : 'Ok',
            child: Align(
              child: Column(
                children: [
                  Text(
                      '(${_diceValues.where((e) => e > 0).join(' + ')})${modifier != 0 ? ' ${modifier.toSignString()} ${modifier.abs()}' : ''} =',
                      style: Fonts.regular(size: 24)),
                  Text((_diceValues.sum() + modifier).toString(),
                      style: Fonts.black(size: 48))
                ],
              ),
            ));
        if (args.oneShot) {
          Navigator.of(context).pop(_diceValues.sum());
        }
      });
    } else if (_selectedDice.isEmpty) {
      context.snackbar(
        'Seleziona almeno un dado',
        backgroundColor: Palette.backgroundGreen,
        bottomMargin: 90,
      );
    }
  }
}
