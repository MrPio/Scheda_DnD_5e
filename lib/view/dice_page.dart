import 'dart:async';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/enum/dice.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/view/home_page.dart';
import 'package:scheda_dnd_5e/view/partial/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/card/dice_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';

class DiceArgs {
  final String? title;
  final List<Dice>? dices;
  final int? modifier;
  final bool oneShot;

  DiceArgs({this.title, this.dices, this.modifier, this.oneShot = false});
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with SingleTickerProviderStateMixin {
  DiceArgs? args;
  List<Dice> _selectedDice = [];
  List<int> _diceValues = List<int>.filled(maxSelection, 0);
  bool _isRolling = false;
  static const int maxSelection = 12,
      rollDuration = 1200,
      rollsCount = 3,
      minModifier = -20,
      maxModifier = 20;
  late final AnimationController _diceRotationController;
  final TextEditingController _modifierController = TextEditingController(text: '0');

  /// The integer value of the modifier
  int get modifier => args?.modifier ?? int.parse(_modifierController.text);

  set modifier(int value) => setState(() => _modifierController.text = value.toString());

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
    _diceRotationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: rollDuration));
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
    args = (ModalRoute.of(context)!.settings.arguments) as DiceArgs?;
    _selectedDice = args?.dices ?? _selectedDice;
    var page = Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(
              top: Measures.vMarginBig + (args == null ? Measures.vMarginMed : -Measures.vMarginThin),
              bottom: Measures.vMarginSmall - Measures.vMarginThin,
              left: args == null ? Measures.hPadding : 0,
              right: args == null ? Measures.hPadding : 0),
          child: Stack(alignment: Alignment.center, children: [
            if (args != null)
              Align(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: Measures.vMarginThin,bottom: Measures.vMarginThin, left: Measures.hPadding*3, right: Measures.hPadding),
                child: Expanded(
                  child: Text(args?.title ?? 'Lanciatore dadi',
                      style: Fonts.black(size: 18),overflow: TextOverflow.ellipsis),
                ),
              ))
            else
              Align(
                  alignment: Alignment.centerLeft, child: Text('Lanciatore dadi', style: Fonts.black())),
            if ((args?.dices == null && _selectedDice.isNotEmpty) ||
                (args?.modifier == null && modifier != 0))
              Align(
                alignment: Alignment.centerRight,
                child: 'close'.toIcon(
                    height: 18,
                    padding: const EdgeInsets.all(6),
                    onTap: () {
                      _selectedDice = [];
                      modifier = 0;
                      setState(() {});
                    }),
              ),
            if (args != null)
              const Align(
                alignment: Alignment.centerLeft,
                child: Chevron(
                  inAppBar: true,
                ),
              )
          ]),
        ),
        // Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
            child: Column(
              children: [
                // Selected dice ===============================
                const SizedBox(height: Measures.vMarginSmall),
                GlassCard(
                    height: 224,
                    clickable: false,
                    child: Align(
                      child: _selectedDice.isEmpty
                          ? Text('Seleziona i dadi da lanciare',
                              style: Fonts.regular(color: Palette.hint))
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: numberOfCols,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: Measures.vMarginSmall,
                                crossAxisSpacing: Measures.vMarginSmall,
                                padding: const EdgeInsets.all(10.0),
                                childAspectRatio: ratio,
                                children: List.generate(_selectedDice.length, dice),
                              ),
                            ),
                    )),
                const SizedBox(height: Measures.vMarginSmall),
                GridRow(
                  crossAxisSpacing: Measures.vMarginThin,
                  mainAxisSpacing: Measures.vMarginThin,
                  columnsCount: 3,
                  children: Dice.values
                      .map((e) => DiceCard(
                            e,
                            onTap: selectDice,
                            clickable: args?.dices == null,
                          ))
                      .toList(),
                ),
                const SizedBox(height: Measures.vMarginSmall),
                // Modifier
                args?.modifier == null
                    ? GlassCard(
                        clickable: false,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Modificatore', style: Fonts.regular())),
                              const SizedBox(height: Measures.vMarginSmall),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(999)),
                                    color: Palette.card2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 48,
                                      width: 48,
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
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                          elevation: 0,
                                        ),
                                        child: const Icon(Icons.remove,
                                            color: Palette.onBackground, size: 26),
                                      ),
                                    ),
                                    const SizedBox(width: Measures.hMarginMed),
                                    NumericInput(NumericInputArgs(
                                      min: minModifier,
                                      max: maxModifier,
                                      controller: _modifierController,
                                      width: 60,
                                      contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                                      style: Fonts.black(),
                                    )),
                                    const SizedBox(width: Measures.hMarginMed),
                                    SizedBox(
                                      height: 48,
                                      width: 48,
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
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                          elevation: 0,
                                        ),
                                        child:
                                            const Icon(Icons.add, color: Palette.onBackground, size: 26),
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
                              Text('Modificatore:', style: Fonts.regular()),
                              const SizedBox(width: Measures.hMarginMed),
                              Text(modifier.toSignedString(), style: Fonts.black()),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: Measures.vMarginBig + Measures.vMarginBig),
              ],
            ),
          ),
        ),
      ],
    );
    if (args == null) {
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
                  padding:
                      const EdgeInsets.only(bottom: Measures.fABBottomMargin, right: Measures.hPadding),
                  child: FloatingActionButton(
                    onPressed: roll,
                    elevation: 0,
                    foregroundColor: Palette.primaryGreen,
                    backgroundColor: Palette.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
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
      context.snackbar('Non puoi aggiungere altri dadi',
          backgroundColor: Palette.backgroundGreen,
          bottomMargin: args == null ? Measures.bottomBarHeight : Measures.vMarginSmall);
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
                turns: Tween(begin: 0.0, end: rollsCount.toDouble())
                    .animate(CurvedAnimation(parent: _diceRotationController, curve: Curves.easeOut)),
                child: SvgPicture.asset(_selectedDice[i].svgPath, height: double.infinity)),
            // Dice number
            if (_diceValues[i] > 0)
              Align(
                alignment: Alignment(0, _selectedDice[i].yTextAlignment),
                child: Text(_diceValues[i].toString(), style: Fonts.bold(size: 18)),
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
      Future.delayed(const Duration(milliseconds: (rollDuration)), () async {
        // Show result
        _isRolling = false;
        await context.popup('Risultato del lancio',
            backgroundColor: Palette.popup,
            dismissible: !(args?.oneShot ?? false),
            positiveText: (args?.oneShot ?? false) ? 'Conferma' : 'Ok',
            child: Align(
              child: Column(
                children: [
                  Text(
                      '(${_diceValues.where((e) => e > 0).join(' + ')})${modifier != 0 ? ' ${modifier.toSignedString()}' : ''} =',
                      style: Fonts.regular(size: 24)),
                  Text((_diceValues.sum() + modifier).toString(), style: Fonts.black(size: 42))
                ],
              ),
            ));
        if (args?.oneShot ?? false) {
          Navigator.of(context).pop(_diceValues.sum());
        }
      });
    } else if (_selectedDice.isEmpty) {
      context.snackbar('Seleziona almeno un dado',
          backgroundColor: Palette.backgroundGreen,
          bottomMargin: args == null ? Measures.bottomBarHeight : Measures.vMarginSmall);
    }
  }
}
