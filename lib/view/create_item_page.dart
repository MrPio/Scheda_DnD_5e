import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/iterable_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/mixin/loadable.dart';
import 'package:scheda_dnd_5e/model/loot.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/card/dice_card.dart';
import 'package:scheda_dnd_5e/view/partial/card/sheet_item_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/glass_button.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_checkbox.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/gradient_background.dart';
import 'package:scheda_dnd_5e/view/partial/grid_column.dart';
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
import '../manager/database_manager.dart';
import '../manager/io_manager.dart';
import '../mixin/validable.dart';
import '../model/character.dart' as ch;

class CreateItemArgs {
  final Type type;
  final ch.Character? character;

  CreateItemArgs(this.type, {this.character});
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
  final TextEditingController _caController = TextEditingController(text: '0');
  final int caMin = 0, caMax = 99;
  bool isPartialArmor = false, isHeavyArmor = false;
  Map<ch.Skill, int> armorSkillModifiers = {};
  Map<ch.Skill, TextEditingController> armorSkillModifiersControllers = Map.fromIterables(
      ch.Skill.values, List.generate(ch.Skill.values.length, (_) => TextEditingController(text: '0')));
  final TextEditingController _armorStrengthController = TextEditingController(text: '0');
  final int armorStrengthMin = 0, armorStrengthMax = 99;
  final TextEditingController _coinValueController = TextEditingController(text: '1');
  final int coinValueMin = 1, coinValueMax = 1e8.toInt();
  final TextEditingController _coinCurrencyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int get fixedDamage => int.parse(_fixedDamageController.text);

  set fixedDamage(int value) => setState(
      () => _fixedDamageController.text = max(fixedDamageMin, min(fixedDamageMax, value)).toString());

  int get caArmor => int.parse(_caController.text);

  set caArmor(int value) => setState(() => _caController.text = max(caMin, min(caMax, value)).toString());

  int get strengthArmor => int.parse(_armorStrengthController.text);

  set strengthArmor(int value) => setState(() =>
      _armorStrengthController.text = max(armorStrengthMin, min(armorStrengthMax, value)).toString());

  int get coinValue => int.parse(_coinValueController.text);

  set coinValue(int value) =>
      setState(() => _coinValueController.text = max(coinValueMin, min(coinValueMax, value)).toString());

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
        // Name TextField
        GlassTextField(
          iconPath: 'png/edit',
          hintText: 'Un nome di ${InventoryItem.namesSingulars[args!.type]!.toLowerCase()}',
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
      // Weapon page
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
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "I dadi che il giocatore deve tirare per determinare i danni di un attacco con quest'arma.",
                  style: Fonts.light())),
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
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("I danni fissi aggiuntivi che vanno sommati a quelli variabili.",
                  style: Fonts.light())),
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
          // Property
          Row(
            children: [
              'png/property'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Proprietà aggiuntive', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Le proprietà aggiuntive dell'arma. Possono includere ad esempio la gittata, il tipo di danno e di impugnatura.",
                  style: Fonts.light())),
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
      // Armor page
      if (args!.type == Armor)
        Column(children: [
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InventoryItem.icons[args!.type]!.toIcon(),
                  const SizedBox(width: Measures.hMarginMed),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Specifica le caratteristiche', style: Fonts.black())),
                ],
              ),
            ),
          ),
          const SizedBox(height: Measures.vMarginThin),
          // Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Quanta protezione fornisce l\'armatura?', style: Fonts.light()),
          ),
          const SizedBox(height: Measures.vMarginMed),
          // CA
          Row(
            children: [
              'png/partial_armor'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Tipo di armatura', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Le armature parziali, come scudi e accessori, aggiungono un contributo al valore finale della CA del personaggio.",
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
          // Is relative CA?
          GlassCard(
            onTap: () => setState(() => isPartialArmor = !isPartialArmor),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measures.hMarginMed, vertical: Measures.vMarginMoreThin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('È un\'armatura parziale?', style: Fonts.regular()),
                  GlassCheckbox(
                    onChanged: () => setState(() => isPartialArmor = !isPartialArmor),
                    value: isPartialArmor,
                    color: Palette.primaryBlue,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: Measures.vMarginSmall),
          // CA numeric input
          Row(
            children: [
              'png/shield'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Classe armatura', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('La CA misura la protezione che l\'armatura fornisce a chi la indossa.',
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
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
                    onPressed: () => caArmor--,
                    onLongPress: () => caArmor -= 5,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.background,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.remove, color: Palette.onBackground, size: 26),
                  ),
                ),
                const SizedBox(width: Measures.hMarginMed),
                if (isPartialArmor) Text('+', style: Fonts.black(size: 30)),
                NumericInput(NumericInputArgs(
                  min: caMin,
                  max: caMax,
                  controller: _caController,
                  width: isPartialArmor ? 42 : 60,
                  contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  style: Fonts.black(),
                )),
                const SizedBox(width: Measures.hMarginMed),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    onPressed: () => caArmor++,
                    onLongPress: () => caArmor += 5,
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
          // Skill modifiers
          Row(
            children: [
              'png/skill'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Modificatori alla CA', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "I modificatori incrementano il valore di CA dell'armatura in base al valore della relativa competenza. Puoi anche impostare un valore massimo a ciascun modificatore.",
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
          GridColumn(
            // fill: true,
            columnsCount: 3,
            children: [
              ...ch.Skill.values.map((skill) => SheetItemCard(
                    text: skill.title,
                    iconPath: skill.iconPath,
                    iconColor: skill.color,
                    isLight: !armorSkillModifiers.containsKey(skill),
                    child: armorSkillModifiers.containsKey(skill)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Max: ', style: Fonts.bold()),
                              NumericInput(NumericInputArgs(
                                min: 0,
                                max: 20,
                                remapping: {0: '-'},
                                defaultValue: 2,
                                initialValue: '-',
                                controller: armorSkillModifiersControllers[skill],
                                isDense: true,
                              ))
                            ],
                          )
                        : null,
                    onTap: () {
                      if (armorSkillModifiers.containsKey(skill)) {
                        armorSkillModifiers.remove(skill);
                      } else {
                        armorSkillModifiers[skill] = 2;
                      }
                      setState(() {});
                    },
                  ))
            ],
          ),
          const SizedBox(height: Measures.vMarginMed),
          // Strength requirement
          Row(
            children: [
              'png/strength'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Requisito di forza', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Il requisito minimo di forza che il personaggio deve soddisfare per poter equipaggiare questa armtura.",
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
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
                    onPressed: () => strengthArmor--,
                    onLongPress: () => strengthArmor -= 5,
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
                  min: armorStrengthMin,
                  max: armorStrengthMax,
                  controller: _armorStrengthController,
                  width: 60,
                  contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  style: Fonts.black(),
                )),
                const SizedBox(width: Measures.hMarginMed),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    onPressed: () => strengthArmor++,
                    onLongPress: () => strengthArmor += 5,
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
          // Disadvantage
          Row(
            children: [
              'png/heavy'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Svantaggio di pesantezza', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Alcune armaturi pesanti presentano uno svantaggio nei tiri di furtività.",
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
          GlassCard(
            onTap: () => setState(() => isHeavyArmor = !isHeavyArmor),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measures.hMarginMed, vertical: Measures.vMarginMoreThin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('È un\'armatura pesante?', style: Fonts.regular()),
                  GlassCheckbox(
                    onChanged: () => setState(() => isHeavyArmor = !isHeavyArmor),
                    value: isHeavyArmor,
                    color: Palette.primaryBlue,
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: Measures.vMarginBig * 3),
        ]),
      // Coin page
      if (args!.type == Coin)
        Column(children: [
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InventoryItem.icons[args!.type]!.toIcon(),
                  const SizedBox(width: Measures.hMarginMed),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Specifica il valore', style: Fonts.black())),
                ],
              ),
            ),
          ),
          const SizedBox(height: Measures.vMarginThin),
          // Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Che tipo di valuta vuoi creare?', style: Fonts.light()),
          ),
          const SizedBox(height: Measures.vMarginMed),
          // CA
          Row(
            children: [
              'png/value'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Valore della moneta', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Il valore di una valuta viene misurato in base a quante monete di bronzo corrisponde.",
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
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
                    onPressed: () =>
                        coinValue -= max(1, pow(10, (log(coinValue) * log10e).toInt()).toInt()),
                    onLongPress: () => coinValue ~/= 10,
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
                  min: coinValueMin,
                  max: coinValueMax,
                  controller: _coinValueController,
                  defaultValue: 1,
                  initialValue: '1',
                  width: 160,
                  valueRestriction: (value) =>
                      value < 100 ? value : value - value % pow(10, (log(value) * log10e).toInt()),
                  contentPadding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  style: Fonts.black(),
                )),
                const SizedBox(width: Measures.hMarginMed),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: ElevatedButton(
                    onPressed: () =>
                        coinValue += max(1, pow(10, (log(coinValue) * log10e).toInt()).toInt()),
                    onLongPress: () => coinValue *= 10,
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
          const SizedBox(height: Measures.vMarginSmall),
          // CA numeric input
          Row(
            children: [
              'png/currency'.toIcon(),
              const SizedBox(width: Measures.hMarginMed),
              Text('Sigla valuta', style: Fonts.bold(size: 18)),
              const SizedBox(width: Measures.hMarginBig),
              const Expanded(child: Rule())
            ],
          ),
          const SizedBox(height: Measures.vMarginThin),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('La sigla della valuta è un nome corto rappresentante la moneta.',
                  style: Fonts.light())),
          const SizedBox(height: Measures.vMarginSmall),
          GlassTextField(
            hintText: 'La sigla della valuta',
            secondaryIconPath: 'png/random',
            maxLength: 6,
            onSecondaryIconTap: () {
              _coinCurrencyController.text =
                  List.generate(3, (_) => 'qwertyuiopasdfghjklzxcvbnm'.split('').random)
                      .join()
                      .toUpperCase();
              setState(() {});
            },
            textController: _coinCurrencyController,
            autofocus: false,
            textInputAction: TextInputAction.none,
          ),

          const SizedBox(height: Measures.vMarginBig * 3),
        ]),
      // Description page
      Column(children: [
        // Title
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InventoryItem.icons[args!.type]!.toIcon(),
                const SizedBox(width: Measures.hMarginMed),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Aggiungi altri dettagli', style: Fonts.black())),
              ],
            ),
          ),
        ),
        const SizedBox(height: Measures.vMarginThin),
        // Subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'Hai altre informazioni che sull\'oggetto che stai creando che vuoi riportare? Potrebbero essere informazioni specifiche della campagna in cui l\'oggetto è stato creato.',
              style: Fonts.light()),
        ),
        const SizedBox(height: Measures.vMarginMed),
        // Description
        GlassTextField(
          iconPath: 'info',
          hintText: 'Descrizione di ${item.title}',
          lines: 10,
          textController: _descriptionController,
          autofocus: true,
          onSubmitted: (_) {
            item.description = _descriptionController.text;
            next();
          },
          textInputAction: TextInputAction.next,
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
      // Type-specific page
      if (args!.type == Weapon)
        () {
          if (validate(() => (item as Weapon).rollDamage = _selectedDice)) {
            (item as Weapon).fixedDamage = fixedDamage;
            (item as Weapon).property = _propertyController.text;
            next();
          }
        },
      if (args!.type == Armor)
        () {
          (item as Armor)
            ..isPartial = isPartialArmor
            ..ca = caArmor
            ..skillModifiers = armorSkillModifiers
            ..strength = strengthArmor
            ..isHeavy = isHeavyArmor;
          for(var key in armorSkillModifiers.keys) {
            (item as Armor).skillModifiers[key]=int.tryParse(armorSkillModifiersControllers[key]!.text)??0;
          }
          next();
        },
      if (args!.type == Coin)
        () {
          if (validate(() => (item as Coin).currency = _coinCurrencyController.text)) {
            (item as Coin).value = coinValue;
            next();
          }
        },
      // Description page
      () {
        item.description = _descriptionController.text;
        next();
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
    ScaffoldMessenger.of(context).clearSnackBars();
    if (_index + step >= (_screens?.length ?? 0)) {
      // The item creation is completed, save the item
      withLoading(() async {
        // Finalize the item and post it
        item.regDateTimestamp = DateTime.now().millisecondsSinceEpoch;
        item.authorUID = AccountManager().user.uid;
        item.uid = await DataManager().save(item, SaveMode.post);
        // Add to cache
        DataManager().caches[args!.type]!.add(item);
        IOManager().serializeObjects(
            DatabaseManager.collectionsPOST[args!.type]!, DataManager().caches[args!.type]!);
        // Add the item to the list of created items of the current user
        AccountManager().user.inventoryItems[args!.type]!.add(item.uid!);
        await DataManager().save(AccountManager().user);
        // Add the new item to the character if any
        if (args!.character != null) {
          args!.character!.inventoryItems[args!.type]!.addAll({item.uid!: 1});
          await DataManager().save(args!.character!);
        }
        Navigator.of(context).pop();
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
    ScaffoldMessenger.of(context).clearSnackBars();
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
