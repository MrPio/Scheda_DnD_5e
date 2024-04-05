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
import 'package:scheda_dnd_5e/extension/function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension/function/int_extensions.dart';
import 'package:scheda_dnd_5e/extension/function/list_extensions.dart';
import 'package:scheda_dnd_5e/view/partial/dice_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage>
    with SingleTickerProviderStateMixin {
  List<Dice> _selectedDice = [];
  List<int> _diceValues = List<int>.filled(maxSelection, 0);
  bool _isRolling = false;
  static const int maxSelection = 12,
      rollDuration = 1200,
      rollsCount = 3,
      minModifier = -20,
      maxModifier = 20;
  late final AnimationController _diceRotationController;
  late final TextEditingController _modifierController;

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

  /// The integer value of the modifier
  int get modifier => int.parse(_modifierController.text);

  set modifier(int value) =>
      setState(() => _modifierController.text = value.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundGreen),
          // Header + Body
          Padding(
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
                    Align(child: Text('Dadi', style: Fonts.black(size: 20))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                              'assets/images/icons/chevron_left.svg',
                              height: 24),
                        ),
                        if (_selectedDice.isNotEmpty || modifier != 0)
                          GestureDetector(
                            onTap: () {
                              _selectedDice = [];
                              modifier = 0;
                              setState(() {});
                            },
                            child: SvgPicture.asset(
                                'assets/images/icons/close.svg',
                                height: 22),
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        mainAxisSpacing: Measures.vMarginSmall,
                                        crossAxisSpacing: Measures.vMarginSmall,
                                        padding: const EdgeInsets.all(10.0),
                                        childAspectRatio: ratio,
                                        children: List.generate(
                                            _selectedDice.length, dice),
                                      ),
                                    ),
                            )),
                        const SizedBox(height: Measures.vMarginSmall),
                        // D4, D6, D8 dice ===============================
                        Row(
                          children: [
                            Expanded(
                                child: DiceCard(Dice.d4, onTap: selectDice)),
                            const SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: DiceCard(Dice.d6, onTap: selectDice)),
                            const SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: DiceCard(Dice.d8, onTap: selectDice)),
                          ],
                        ),
                        const SizedBox(height: Measures.vMarginThin),
                        //  D10, D12, D100 dice
                        Row(
                          children: [
                            Expanded(
                                child: DiceCard(Dice.d10, onTap: selectDice)),
                            const SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: DiceCard(Dice.d12, onTap: selectDice)),
                            const SizedBox(width: Measures.vMarginThin),
                            Expanded(
                                child: DiceCard(Dice.d100, onTap: selectDice)),
                          ],
                        ),
                        const SizedBox(height: Measures.vMarginThin),
                        // D20 Dice ===============================
                        DiceCard(Dice.d20, onTap: selectDice),
                        const SizedBox(height: Measures.vMarginSmall),
                        // Modifier
                        GlassCard(
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
                                        height: 54,
                                        width: 54,
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
                                              size: 30),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: Measures.hMarginMed),
                                      SizedBox(
                                        width: 70,
                                        child: TextField(
                                            keyboardAppearance: Brightness.dark,
                                            keyboardType: TextInputType.number,
                                            maxLength: 3,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 8, 4, 8),
                                                border: InputBorder.none,
                                                hintStyle: Fonts.light(
                                                    color: Palette.hint),
                                                hoverColor:
                                                    Palette.onBackground,
                                                focusColor:
                                                    Palette.onBackground,
                                                counterText: ''),
                                            controller: _modifierController,
                                            style: Fonts.black(size: 28)),
                                      ),
                                      const SizedBox(
                                          width: Measures.hMarginMed),
                                      SizedBox(
                                        height: 54,
                                        width: 54,
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
                                              size: 30),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom button
          Padding(
            padding: const EdgeInsets.only(bottom: Measures.bottomButtonMargin),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                  child: ElevatedButton(
                    onPressed: roll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primaryGreen,
                      padding: const EdgeInsets.symmetric(
                          vertical: Measures.vButtonPadding),
                      shadowColor: Palette.primaryGreen,
                      elevation: 12,
                    ),
                    child: Text('LANCIA', style: Fonts.button()),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
      Future.delayed(const Duration(milliseconds: (rollDuration)), () {
        // Show result
        _isRolling = false;
        context.popup('Risultato del lancio',
            backgroundColor: Palette.popup,
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
      });
    } else if (_selectedDice.isEmpty) {
      context.snackbar(
        'Seleziona almeno un dado',
        backgroundColor: Palette.backgroundGreen,
        bottomMargin: 90,
      );
    }
  }

  @override
  void initState() {
    _diceRotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: rollDuration));
    _modifierController = TextEditingController(text: '0');
    _modifierController.addListener(() {
      if (_modifierController.text.contains('--')) {
        _modifierController.text =
            _modifierController.text.replaceAll('--', '-');
      }
      if(_modifierController.text.contains('-') &&_modifierController.text.indexOf('-')!=0){
        _modifierController.text ='-${_modifierController.text.replaceAll('-', '')}';
      }
      if(_modifierController.text.contains('.') || _modifierController.text.contains(',')){
        _modifierController.text =_modifierController.text.replaceAll('.', '').replaceAll(',', '');
      }
      if (_modifierController.text.isEmpty) {
        modifier = 0;
      } else if (!_modifierController.text.contains('+') && modifier > 0) {
        _modifierController.text = '+$modifier';
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _diceRotationController.dispose();
    _modifierController.dispose();
    super.dispose();
  }
}
