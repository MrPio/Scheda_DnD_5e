import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/extension_function/context_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/date_time_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/list_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart' as ch show Alignment;
import 'package:scheda_dnd_5e/model/loot.dart';
import 'package:scheda_dnd_5e/view/create_item_page.dart';
import 'package:scheda_dnd_5e/view/dice_page.dart';
import 'package:scheda_dnd_5e/view/partial/card/alignment_card.dart';
import 'package:scheda_dnd_5e/view/partial/card/enchantment_card.dart';
import 'package:scheda_dnd_5e/view/partial/card/sheet_item_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/decoration/rule.dart';
import 'package:scheda_dnd_5e/view/partial/fab.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/glass_text_field.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/layout/grid_column.dart';
import 'package:scheda_dnd_5e/view/partial/layout/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/screen/characters_screen.dart';

import '../model/character.dart' hide Alignment;
import '../model/enchantment.dart' as en;
import 'enchantments_page.dart';
import 'partial/decoration/gradient_background.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> with TickerProviderStateMixin {
  List<Widget>? _screens;
  TabController? _tabController;
  late ScrollController _bodyController;

  bool get _isSkillsExpanded => IOManager().get<bool>('character_page_isSkillsExpanded') ?? false;

  set _isSkillsExpanded(bool value) => IOManager().set('character_page_isSkillsExpanded', value);

  List<InventoryItem>? inventoryItems(Type type) =>
      _character?.inventory.value?.keys.where((e) => e.runtimeType == type).toList()?..sort();

  bool _getIsInventoryItemExpanded(Type type) =>
      IOManager().get<bool>('character_page_isInventoryItemExpanded_$type') ?? true;

  _setIsInventoryItemExpanded(Type type, bool value) =>
      IOManager().set('character_page_isInventoryItemExpanded_$type', value);

  bool _getIsEnchantmentLevelExpanded(en.Level level) =>
      IOManager().get<bool>('character_page_isEnchantmentLevelExpanded_${level.num}') ?? true;

  _setIsEnchantmentLevelExpanded(en.Level level, bool value) =>
      IOManager().set('character_page_isEnchantmentLevelExpanded_${level.num}', value);

  bool _getIsBackgroundExpanded(Background background) =>
      IOManager().get<bool>('character_page_IsBackgroundExpanded_${background.name}') ?? true;

  _setIsBackgroundExpanded(Background background, bool value) =>
      IOManager().set('character_page_IsBackgroundExpanded_${background.name}', value);

  List<en.Enchantment>? enchantments(en.Level level) =>
      _character?.enchantments.value?.where((e) => e.level == level).toList()?..sort();

  Character? _character, _oldCharacter;
  late final TextEditingController _armorClassController,
      _speedController,
      _initiativeController,
      _hpController,
      _maxHpController;
  final List<TextEditingController> _skillsControllers =
      List.generate(Skill.values.length, (_) => TextEditingController());
  final List<TextEditingController> _subSkillsControllers =
      List.generate(SubSkill.values.length, (_) => TextEditingController());
  final String _speedSuffix = 'm';
  bool _isEditingHp = false, _isEditingMaxHp = false;
  Skill? _selectedSkill;
  final Map<en.Level, TextEditingController> _slotsControllers = {
    for (var level in en.Level.values) level: TextEditingController()
  };
  final double slotSizeSquare = 38, slotSizeCircle = 24;
  late final Map<Background, TextEditingController> _backgroundControllers;

  bool get hasChanges => jsonEncode(_oldCharacter!.toJSON()) != jsonEncode(_character!.toJSON());

  @override
  void initState() {
    _armorClassController = TextEditingController();
    _speedController = TextEditingController();
    _initiativeController = TextEditingController();
    _hpController = TextEditingController();
    _maxHpController = TextEditingController();
    _bodyController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _character!.armorClass = int.tryParse(_armorClassController.text) ?? _character!.armorClass;
    _character!.speed =
        double.tryParse(_speedController.text.replaceAll(_speedSuffix, '')) ?? _character!.speed;
    _character!.initiative = int.tryParse(_initiativeController.text) ?? _character!.initiative;
    _slotsControllers
        .forEach((key, value) => _character!.totalSlots[key] = int.tryParse(value.text) ?? 0);
    _character!.descriptions = _backgroundControllers.map((key, value) => MapEntry(key, value.text));

    // If the character is any different from `initState`, save it.
    if (hasChanges) {
      Future.delayed(Duration.zero, () async {
        await DataManager().save(_character!);
        print('⬆️ Character Saved');
      });
    }

    // Dispose the controllers
    for (var e in [
          _armorClassController,
          _speedController,
          _initiativeController,
          _hpController,
          _maxHpController,
          _tabController,
          _bodyController
        ] +
        _skillsControllers +
        _subSkillsControllers) {
      e?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_character == null) {
      _character = ModalRoute.of(context)!.settings.arguments as Character;
      _oldCharacter = Character.fromJson(_character!.toJSON());
      _character!.inventory.addListener(() => mounted ? setState(() {}) : null);
      _character!.enchantments.addListener(() => mounted ? setState(() {}) : null);
      _backgroundControllers = {
        for (var b in Background.values) b: TextEditingController(text: _character?.descriptions[b] ?? '')
      };
    }
    final character = _character!;

    BottomSheetArgs? hpBottomSheetArgs;
    List<Widget> sheetAttributes = [];
    List<Widget> sheetSkills = [];
    if ((_tabController?.index ?? 0) == 0) {
      hpBottomSheetArgs = BottomSheetArgs(
        items: [
          BottomSheetItem('png/hp', 'Modifica HP', () {
            setState(() {
              _isEditingHp = true;
              _isEditingMaxHp = false;
            });
          }),
          BottomSheetItem('png/max_hp', 'Modifica HP Massimi', () {
            setState(() {
              _isEditingHp = false;
              _isEditingMaxHp = true;
            });
          }),
          if (character.hp < character.maxHp)
            BottomSheetItem('png/rest', 'Riposa', () {
              setState(() {
                character.hp = character.maxHp;
              });
              context.snackbar('La vita è stata ripristinata', backgroundColor: Palette.primaryBlue);
            }),
        ],
      );
      sheetAttributes = [
        SheetItemCard(
          iconPath: 'png/shield',
          text: 'CA',
          value: character.armorClass.toString(),
          numericInputArgs: NumericInputArgs(min: 0, max: 99, controller: _armorClassController),
        ),
        SheetItemCard(
            iconPath: 'png/hp',
            text: _isEditingMaxHp ? 'Max HP' : 'HP',
            value: (_isEditingMaxHp ? character.maxHp : character.hp).toString(),
            subValue: _isEditingMaxHp || _isEditingHp ? null : character.maxHp.toString(),
            numericInputArgs: (_isEditingHp || _isEditingMaxHp)
                ? NumericInputArgs(
                    min: _isEditingHp ? -character.maxHp : 1,
                    max: _isEditingHp ? character.maxHp : 999,
                    controller: _isEditingHp ? _hpController : _maxHpController,
                    defaultValue: (_isEditingHp ? character.hp : character.maxHp).toDouble(),
                    onSubmit: (value) {
                      if (_isEditingHp) {
                        character.hp = value.toInt();
                      } else if (_isEditingMaxHp) {
                        character.maxHp = value.toInt();
                      }
                    },
                    finalize: () {
                      setState(() {
                        _isEditingHp = false;
                        _isEditingMaxHp = false;
                      });
                    },
                    autofocus: true,
                  )
                : null,
            bottomSheetArgs: hpBottomSheetArgs),
        SheetItemCard(
            iconPath: 'png/bonus', text: 'BC', value: character.competenceBonus.toSignedString()),
        // Note: the speed goes back to the default value on purpose
        SheetItemCard(
            iconPath: 'png/speed',
            text: 'Speed',
            numericInputArgs: NumericInputArgs(
              min: 0,
              max: 99,
              controller: _speedController,
              decimalPlaces: 1,
              defaultValue: character.defaultSpeed,
              suffix: _speedSuffix,
              valueRestriction: (value) =>
                  value % 1.5 < 1.5 - value % 1.5 ? value - value % 1.5 : value + value % 1.5,
            ),
            value: '${character.speed.toStringAsFixed(1)}m'),
        SheetItemCard(
          iconPath: 'png/status',
          text: 'Allineamento',
          value: character.alignment.initials ?? '-',
          bottomSheetArgs: BottomSheetArgs(
            header: GridRow(
                columnsCount: 3,
                children: ch.Alignment.values
                    .map((e) => AlignmentCard(
                          e,
                          onTap: (alignment) {
                            setState(() {
                              character.alignment = alignment;
                            });

                            Navigator.of(context).pop();
                          },
                          isSmall: e == ch.Alignment.nessuno,
                        ))
                    .toList()),
          ),
        ),
        SheetItemCard(
            iconPath: 'png/initiative',
            text: 'Iniziativa',
            numericInputArgs: NumericInputArgs(
              min: -20,
              max: 20,
              controller: _initiativeController,
              defaultValue: character.skillModifier(Skill.destrezza).toDouble(),
            ),
            value: character.initiative.toSignedString()),
      ];
      sheetSkills = [
        Skill.forza,
        Skill.costituzione,
        Skill.destrezza,
        Skill.intelligenza,
        Skill.saggezza,
        Skill.carisma
      ]
          .map((skill) => SheetItemCard(
                iconPath: skill.iconPath,
                text: skill.title,
                iconColor: skill.color,
                value: _selectedSkill == skill
                    ? character.skillValue(skill).toString()
                    : character.skillModifier(skill).toSignedString(),
                subValue: _selectedSkill == skill ? null : character.skillValue(skill).toString(),
                numericInputArgs: _selectedSkill == skill
                    ? NumericInputArgs(
                        min: 3,
                        max: 20,
                        controller: _skillsControllers[Skill.values.indexOf(skill)],
                        defaultValue: (character.skillValue(skill)).toDouble(),
                        onSubmit: (value) {
                          character.customSkills[skill] = value.toInt();
                        },
                        finalize: () {
                          setState(() {
                            _selectedSkill = null;
                          });
                        },
                        autofocus: true)
                    : null,
                onTap: _isSkillsExpanded
                    ? null
                    : () {
                        setState(() {
                          _selectedSkill = skill;
                        });
                      },
                child: _isSkillsExpanded
                    ? Column(
                        children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Measures.hMarginMed,
                                      vertical: Measures.vMarginMoreThin),
                                  child: Row(children: [
                                    // SavingThrow title
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        'Tiro salvezza',
                                        style: Fonts.regular(size: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // SavingThrow value
                                    Text(character.savingThrowValue(skill).toSignedString(),
                                        style: Fonts.black(size: 14)),
                                    const SizedBox(width: Measures.hMarginSmall),
                                    // Saving Throw
                                    Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                            color: character.class_.savingThrows.contains(skill)
                                                ? Palette.onBackground
                                                : Colors.transparent,
                                            border: Border.all(color: Palette.onBackground, width: 0.75),
                                            borderRadius: BorderRadius.circular(999))),
                                  ])),
                              if (skill.subSkills.isNotEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: Measures.vMarginMoreThin),
                                  child: Rule(),
                                ),
                            ].cast<Widget>() +
                            skill.subSkills
                                .map((subSkill) => Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            character.subSkills[subSkill] =
                                                ((character.subSkills[subSkill] ?? 0) + 1) % 3;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Measures.hMarginMed,
                                              vertical: Measures.vMarginMoreThin),
                                          child: Row(
                                            children: [
                                              // SubSkill title
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  subSkill.title,
                                                  style: Fonts.regular(size: 13),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // SubSkill value
                                              Text(character.subSkillValue(subSkill).toSignedString(),
                                                  style: Fonts.black(size: 14)),
                                              const SizedBox(width: Measures.hMarginSmall),
                                              // Competenza
                                              Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                      color: (character.subSkills[subSkill] ?? 0) >= 1
                                                          ? Palette.onBackground
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                          color: Palette.onBackground, width: 0.65),
                                                      borderRadius: BorderRadius.circular(999))),
                                              const SizedBox(width: Measures.hMarginThin),
                                              // Maestria
                                              Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                      color: (character.subSkills[subSkill] ?? 0) >= 2
                                                          ? Palette.onBackground
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                          color: Palette.onBackground, width: 0.65),
                                                      borderRadius: BorderRadius.circular(1.75)))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList()
                                .cast<Widget>(),
                      )
                    : null,
              ))
          .toList();
    }

    _screens = [
      // Sheet
      (_tabController?.index ?? 0) != 0
          ? Column(
              children: [
                const SizedBox(height: Measures.vMarginMed),
                GlassCard(isShimmer: true, shimmerHeight: 40),
                const SizedBox(height: Measures.vMarginMed),
                GridRow(
                  columnsCount: 3,
                  mainAxisSpacing: 0,
                  children: List.filled(6, GlassCard(isShimmer: true, shimmerHeight: 70)),
                ),
                const SizedBox(height: Measures.vMarginMed),
                GridRow(
                  columnsCount: 3,
                  mainAxisSpacing: 0,
                  children: List.filled(6, GlassCard(isShimmer: true, shimmerHeight: 70)),
                ),
                const SizedBox(height: Measures.vMarginMed),
                GridRow(
                  columnsCount: 3,
                  mainAxisSpacing: 0,
                  children: List.filled(9, GlassCard(isShimmer: true, shimmerHeight: 70)),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Measures.vMarginMed),
                // TODO here: class and multiclass +
                // TODO: info race,
                // HP bar
                HpBar(character.hp, character.maxHp, bottomSheetArgs: hpBottomSheetArgs),
                const SizedBox(height: Measures.vMarginSmall),
                // Attributes
                Text('Attributi', style: Fonts.black(size: 18)),
                const SizedBox(height: Measures.vMarginThin),
                GridRow(
                  columnsCount: 3,
                  children: sheetAttributes,
                ),
                const SizedBox(height: Measures.vMarginThin),
                // Skills and subSkills
                Clickable(
                  onTap: () => setState(() => _isSkillsExpanded = !_isSkillsExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Measures.vMarginThin),
                    child: Row(children: [
                      Text('Caratteristiche', style: Fonts.black(size: 18)),
                      const SizedBox(width: Measures.hMarginMed),
                      'chevron_left'.toIcon(height: 16, rotation: _isSkillsExpanded ? pi / 2 : -pi / 2)
                    ]),
                  ),
                ),
                _isSkillsExpanded
                    ? GridColumn(
                        columnsCount: 2,
                        children: sheetSkills,
                      )
                    : GridRow(
                        columnsCount: 3,
                        children: sheetSkills,
                      ),
                const SizedBox(height: Measures.vMarginSmall),
                // Masteries
                Text('Competenze', style: Fonts.black(size: 18)),
                const SizedBox(height: Measures.vMarginThin),
                GridRow(
                    fill: true,
                    columnsCount: 3,
                    children: character.masteries
                            .map((e) => SheetItemCard(
                                  text: e.title,
                                  iconPath: e.masteryType.iconPath,
                                  onTap: () {
                                    context.popup('Stai per rimuovere una competenza',
                                        message: 'Sei sicuro di voler rimuovere **${e.title}**?',
                                        positiveCallback: () {
                                      setState(() {
                                        character.masteries.remove(e);
                                      });
                                      return true;
                                    },
                                        negativeCallback: () {},
                                        positiveText: 'Si',
                                        negativeText: 'No',
                                        backgroundColor: Palette.backgroundGrey.withOpacity(0.2));
                                  },
                                ))
                            .toList()
                            .cast<Widget>() +
                        [
                          GlassCard(
                              height: Measures.sheetCardSmallHeight,
                              isLight: true,
                              clickable: true,
                              onTap: () {
                                context.draggableBottomSheet(
                                  body: Column(
                                    children: [
                                      const SizedBox(height: Measures.vMarginThin),
                                      Text('Aggiungi una competenza', style: Fonts.bold(size: 18)),
                                      const SizedBox(height: Measures.vMarginThin),
                                      Column(
                                          children: MasteryType.values
                                              .map((masteryType) => Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: Measures.vMarginSmall),
                                                        child: Rule(),
                                                      ),
                                                      Text(masteryType.title, style: Fonts.regular()),
                                                      const SizedBox(height: Measures.vMarginSmall),
                                                      GridRow(
                                                          columnsCount: 3,
                                                          fill: true,
                                                          children: masteryType.masteries
                                                              .where(
                                                                  (e) => !character.masteries.contains(e))
                                                              .map((mastery) => SheetItemCard(
                                                                    text: mastery.title,
                                                                    iconPath: masteryType.iconPath,
                                                                    onTap: () {
                                                                      setState(() {
                                                                        character.masteries.add(mastery);
                                                                      });
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ))
                                                              .toList()),
                                                    ],
                                                  ))
                                              .toList()),
                                      const SizedBox(height: Measures.vMarginMed),
                                    ],
                                  ),
                                );
                              },
                              child: Center(child: 'add'.toIcon(height: 16)))
                        ]),
                const SizedBox(height: Measures.vMarginSmall),
                // Languages
                Text('Linguaggi', style: Fonts.black(size: 18)),
                const SizedBox(height: Measures.vMarginThin),
                GridRow(
                    fill: true,
                    columnsCount: 3,
                    children: character.languages
                            .map((e) => SheetItemCard(
                                  text: e.title,
                                  iconPath: 'png/language',
                                  onTap: () {
                                    context.popup('Stai per rimuovere un linguaggio',
                                        message: 'Sei sicuro di voler rimuovere **${e.title}**?',
                                        positiveCallback: () {
                                      setState(() {
                                        character.languages.remove(e);
                                      });
                                    },
                                        negativeCallback: () {},
                                        positiveText: 'Si',
                                        negativeText: 'No',
                                        backgroundColor: Palette.backgroundGrey.withOpacity(0.2));
                                  },
                                ))
                            .toList()
                            .cast<Widget>() +
                        [
                          GlassCard(
                              height: Measures.sheetCardSmallHeight,
                              isLight: true,
                              clickable: true,
                              bottomSheetArgs: BottomSheetArgs(
                                  header: Column(
                                children: [
                                  const SizedBox(height: Measures.vMarginThin),
                                  Text('Aggiungi un linguaggio', style: Fonts.bold(size: 18)),
                                  const SizedBox(height: Measures.vMarginMed),
                                  GridRow(
                                      columnsCount: 3,
                                      fill: true,
                                      children: Language.values
                                          .where((e) => !character.languages.contains(e))
                                          .map((e) => SheetItemCard(
                                                text: e.title,
                                                iconPath: 'png/language',
                                                onTap: () {
                                                  setState(() {
                                                    character.languages.add(e);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ))
                                          .toList()),
                                  const SizedBox(height: Measures.vMarginMed),
                                ],
                              )),
                              child: Center(child: 'add'.toIcon(height: 16)))
                        ]),
                // const SizedBox(height: Measures.vMarginSmall),
                // const GlassButton('Salva',color: Palette.primaryBlue,iconPath: 'png/save',),
                const SizedBox(height: Measures.vMarginBig),
              ],
            ),
      // Inventory
      (_tabController?.index ?? 0) != 1
          ? Column(children: [
              const SizedBox(height: Measures.vMarginMed),
              ...List.filled(10, GlassCard(isShimmer: true, isFlat: true, shimmerHeight: 74))
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inventory sections
                const SizedBox(height: Measures.vMarginMoreThin),
                ...InventoryItem.types.slice(0, -1).map((type) {
                  final isEmpty = character.inventory.value != null &&
                      character.inventory.value!.entries.where((e) => e.key.runtimeType == type).isEmpty;
                  return Column(
                    children: [
                      // Header
                      Clickable(
                        active: !isEmpty,
                        onTap: () => setState(
                            () => _setIsInventoryItemExpanded(type, !_getIsInventoryItemExpanded(type))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Measures.hPadding, vertical: Measures.vMarginThin),
                          child: Row(children: [
                            Text(InventoryItem.names[type]!, style: Fonts.black(size: 18)),
                            const SizedBox(width: Measures.hMarginMed),
                            if (!isEmpty)
                              'chevron_left'.toIcon(
                                  height: 16,
                                  rotation: _getIsInventoryItemExpanded(type) ? pi / 2 : -pi / 2)
                          ]),
                        ),
                      ),
                      // List of inventory items
                      if (character.inventory.value == null)
                        ...List.filled(
                            2, const GlassCard(isShimmer: true, isFlat: true, shimmerHeight: 50)),
                      if (character.inventory.value != null) ...[
                        if (!isEmpty && _getIsInventoryItemExpanded(type))
                          ...inventoryItems(type)!
                              .map((e) => inventoryItemCard(e, _character!.inventory.value![e]!)),
                        if (!isEmpty && !_getIsInventoryItemExpanded(type))
                          const Padding(
                            padding: EdgeInsets.only(top: Measures.vMarginThin),
                            child: Rule(),
                          ),
                        // if (isEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: Measures.vMarginMoreThin),
                        //     child: Text('Niente da mostrare', style: Fonts.black(color: Palette.card2)),
                        //   )
                      ],
                      const SizedBox(height: Measures.vMarginSmall),
                    ],
                  );
                }),
                const SizedBox(height: Measures.vMarginBig * 2),
              ],
            ),
      // Enchantments
      (_tabController?.index ?? 0) != 2
          ? Column(children: [
              const SizedBox(height: Measures.vMarginMed),
              ...List.filled(
                  12,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                    child: GlassCard(isShimmer: true, shimmerHeight: 70),
                  ))
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Measures.vMarginThin),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                  child: Text('Slot disponibili', style: Fonts.black(size: 18)),
                ),
                const SizedBox(height: Measures.vMarginThin),
                // Level/Slot graphics
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text('Livello', style: Fonts.light(size: 16)),
                          ),
                          ...en.Level.values.map(
                            (level) => Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                width: slotSizeSquare,
                                height: slotSizeSquare,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Palette.onBackground, width: 0.45),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(level.num.toString(), style: Fonts.light(size: 18))),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: Measures.vMarginThinnest),
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text('Slot', style: Fonts.regular(size: 16)),
                          ),
                          ...en.Level.values.map(
                            (level) => Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                width: slotSizeSquare,
                                height: slotSizeSquare,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Palette.onBackground, width: 1),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: NumericInput(
                                      NumericInputArgs(
                                          min: 0,
                                          max: 9,
                                          controller: _slotsControllers[level],
                                          width: slotSizeSquare - 2,
                                          isDense: true,
                                          initialValue: character.totalSlots[level]?.toString() ?? '—',
                                          zeroEncoding: '—',
                                          finalize: () => setState(() => character.totalSlots[level] =
                                              int.tryParse(_slotsControllers[level]!.text) ?? 0),
                                          style: Fonts.regular(size: 18)),
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Measures.vMarginSmall),
                // Enchantment grouped by level
                ...en.Level.values.map((level) {
                  final isEmpty =
                      character.enchantments.value?.where((e) => e.level == level).isEmpty != false;
                  if (isEmpty && (character.totalSlots[level] ?? 0) <= 0) return Container();
                  return Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Measures.hPadding, vertical: Measures.vMarginThin),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Clickable(
                            active: !isEmpty,
                            onTap: () => setState(() => _setIsEnchantmentLevelExpanded(
                                level, !_getIsEnchantmentLevelExpanded(level))),
                            child: Row(children: [
                              Text(level.title, style: Fonts.black(size: 18)),
                              const SizedBox(width: Measures.hMarginMed),
                              if (!isEmpty)
                                'chevron_left'.toIcon(
                                    height: 16,
                                    rotation: _getIsEnchantmentLevelExpanded(level) ? pi / 2 : -pi / 2),
                              const SizedBox(width: Measures.hMarginBig)
                            ]),
                          ),
                          Expanded(
                            child: StatefulBuilder(
                              builder: (context, setState) => Clickable(
                                onTap: () => setState(() => character.availableSlots[level] =
                                    ((character.availableSlots[level] ?? 0) + 1) %
                                        ((character.totalSlots[level] ?? 0) + 1)),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: List.generate(
                                          character.totalSlots[level] ?? 0,
                                          (i) => Padding(
                                                padding:
                                                    const EdgeInsets.only(left: Measures.hMarginMoreThin),
                                                child: Container(
                                                  width: slotSizeCircle,
                                                  height: slotSizeCircle,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(999),
                                                      border: Border.all(
                                                          color: Palette.onBackground, width: 0.75),
                                                      color: i >=
                                                              (character.totalSlots[level] ?? 0) -
                                                                  (character.availableSlots[level] ?? 0)
                                                          ? Palette.onBackground
                                                          : Colors.transparent),
                                                ),
                                              ))),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                      // List of enchantments
                      if (character.enchantments.value == null)
                        ...List.filled(
                            2, const GlassCard(isShimmer: true, isFlat: true, shimmerHeight: 50)),
                      if (character.enchantments.value != null) ...[
                        if (!isEmpty && _getIsEnchantmentLevelExpanded(level))
                          ...enchantments(level)!.map((e) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                                child: EnchantmentCard(
                                  e,
                                  additionalBottomSheetItems: [
                                    BottomSheetItem('png/delete_2', 'Rimuovi', () {
                                      context.popup('Stai per rimuovere un incantesimo',
                                          message:
                                              "Sei sicuro di voler rimuovere l'incantesimo ${e.name}?",
                                          positiveText: 'Si',
                                          negativeText: 'No', positiveCallback: () {
                                        character.enchantmentUIDs.remove(e.uid);
                                        character.enchantments.value = null;
                                        DataManager().loadCharacterEnchantments(character);
                                      });
                                    })
                                  ],
                                  onTap: () => context.goto('/enchantment', args: e),
                                ),
                              )),
                        if (!isEmpty && !_getIsEnchantmentLevelExpanded(level))
                          const Padding(
                            padding: EdgeInsets.only(top: Measures.vMarginThin),
                            child: Rule(),
                          ),
                        // if (isEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: Measures.vMarginMoreThin),
                        //     child: Text('Niente da mostrare', style: Fonts.black(color: Palette.card2)),
                        //   )
                      ],
                      const SizedBox(height: Measures.vMarginSmall),
                    ],
                  );
                }),
                const SizedBox(height: Measures.vMarginBig * 2),
              ],
            ),
      // Background
      (_tabController?.index ?? 0) != 3
          ? Column(children: [
              const SizedBox(height: Measures.vMarginMed),
              ...List.filled(10, GlassCard(isShimmer: true, isFlat: true, shimmerHeight: 74))
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inventory sections
                const SizedBox(height: Measures.vMarginMoreThin),
                ...character.descriptions.entries.map((description) {
                  return Column(
                    children: [
                      // Header
                      Clickable(
                        onTap: () => setState(() => _setIsBackgroundExpanded(
                            description.key, !_getIsBackgroundExpanded(description.key))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Measures.hPadding, vertical: Measures.vMarginThin),
                          child: Row(children: [
                            Text(description.key.title, style: Fonts.black(size: 18)),
                            const SizedBox(width: Measures.hMarginMed),
                            'chevron_left'.toIcon(
                                height: 16,
                                rotation: _getIsBackgroundExpanded(description.key) ? pi / 2 : -pi / 2)
                          ]),
                        ),
                      ),
                      // List of background descriptions
                      if (_getIsBackgroundExpanded(description.key))
                        GlassTextField(
                          isFlat: true,
                          lines: 5,
                          iconPath: description.key.iconPath,
                          textInputAction: TextInputAction.done,
                          hintText: description.key.hint,
                          // secondaryIconPath: 'png/random',
                          // onSecondaryIconTap: (){},
                          clearable: true,
                          textController: _backgroundControllers[description.key],
                        ),
                      if (!_getIsBackgroundExpanded(description.key))
                        const Padding(
                          padding: EdgeInsets.only(top: Measures.vMarginThin),
                          child: Rule(),
                        ),
                      const SizedBox(height: Measures.vMarginSmall),
                    ],
                  );
                }),
                const SizedBox(height: Measures.vMarginBig * 2),
              ],
            ),
      // Ability
      const Placeholder(),
    ];
    _tabController ??= TabController(length: _screens!.length, vsync: this)
      ..addListener(() {
        // Load character inventory
        if (_tabController?.index == 1) {
          character.inventory.value = null;
          DataManager().loadCharacterInventory(character);
        } else if (_tabController?.index == 2) {
          character.enchantments.value = null;
          DataManager().loadCharacterEnchantments(character);
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        setState(() {});
      });
    final fabs = [
      null,
      FABArgs(
          color: Palette.primaryBlue,
          icon: 'add',
          onPress: () {
            context.bottomSheet(BottomSheetArgs(
                header: Row(
                  children: [
                    'add'.toIcon(),
                    const SizedBox(width: Measures.hMarginBig),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aggiungi un oggetto all\'inventario', style: Fonts.bold()),
                        Text('Che tipo di oggetto vuoi aggiungere?', style: Fonts.light()),
                      ],
                    )
                  ],
                ),
                items: [
                  BottomSheetItem('png/common_item', 'Un\'oggetto comune', () {
                    // await Future.delayed(Durations.short3);
                    unknown(Type type) => DataManager().cachedInventoryItems.where(
                        (e) => e.runtimeType == type && !character.inventoryUIDs.containsKey(e.uid!));
                    context.draggableBottomSheet(
                      body: Column(
                        children: [
                          const SizedBox(height: Measures.vMarginThin),
                          Text('Aggiungi un oggetto all\'inventario', style: Fonts.bold(size: 18)),
                          const SizedBox(height: Measures.vMarginThin),
                          Column(
                              children: InventoryItem.types
                                  .where((e) => unknown(e).isNotEmpty)
                                  .map((type) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.symmetric(vertical: Measures.vMarginSmall),
                                            child: Rule(),
                                          ),
                                          Text(InventoryItem.names[type]!, style: Fonts.regular()),
                                          const SizedBox(height: Measures.vMarginSmall),
                                          GridRow(
                                              columnsCount: type == Equipment ? 1 : 3,
                                              fill: true,
                                              children: unknown(type)
                                                  .map((item) => SheetItemCard(
                                                        text: item.title,
                                                        iconPath: InventoryItem.icons[type]!,
                                                        onTap: () {
                                                          setState(() {
                                                            character.addLoot(Loot({item.uid!: 1}));
                                                          });
                                                          Navigator.of(context).pop();
                                                        },
                                                      ))
                                                  .toList()),
                                        ],
                                      ))
                                  .toList()),
                          const SizedBox(height: Measures.vMarginMed),
                        ],
                      ),
                    );
                  }),
                  BottomSheetItem('png/custom_item', 'Un\'oggetto personalizzato', () {
                    // await Future.delayed(Durations.short3);
                    context.bottomSheet(BottomSheetArgs(
                        header: Row(
                          children: [
                            'png/edit'.toIcon(),
                            const SizedBox(width: Measures.hMarginBig),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Crea un oggetto personalizzato', style: Fonts.bold()),
                                Text('Che tipo di oggetto vuoi creare?', style: Fonts.light()),
                              ],
                            )
                          ],
                        ),
                        items: [
                          ...InventoryItem.types.slice(0, -1).map((type) => BottomSheetItem(
                                InventoryItem.icons[type]!,
                                InventoryItem.namesSingulars[type]!,
                                () async {
                                  await context.goto('/create_item',
                                      args: CreateItemArgs(type, character: character));
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  character.inventory.value = null;
                                  await DataManager().loadCharacterInventory(character);
                                },
                              ))
                        ]));
                  }),
                ]));
          }),
      FABArgs(
          color: Palette.primaryBlue,
          icon: 'add',
          onPress: () async {
            var uid = await context.goto('/enchantments',
                args: EnchantmentsArgs(
                    title: 'Seleziona l\'incantesimo da aggiungere', filterClasses: [character.class_]));
            if (uid is String) {
              character.enchantmentUIDs.add(uid);
              character.enchantments.value = null;
              await DataManager().loadCharacterEnchantments(character);
            }
          }),
      null,
      null,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          const GradientBackground(topColor: Palette.backgroundBlue),
          // Header + Body
          SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    flexibleSpace: // Header
                        Padding(
                      padding: const EdgeInsets.only(top: Measures.vMarginMed),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chevron(
                            inAppBar: true,
                            popArgs: CharacterPageToCharactersPageArgs(noChanges: hasChanges),
                          ),
                          Column(children: [
                            Text(character.name, style: Fonts.black(size: 18)),
                            Text(
                                character.subRace == null
                                    ? character.race.title
                                    : '${character.subRace!.title} (${character.race.title})',
                                style: Fonts.light(size: 16))
                          ]),
                          Padding(
                            padding: const EdgeInsets.only(right: Measures.hPadding),
                            child: Level(level: character.level, maxLevel: 20),
                          ),
                        ],
                      ),
                    ),
                    leading: Container(),
                    collapsedHeight: 80,
                    expandedHeight: 80,
                    backgroundColor: Colors.transparent,
                    floating: true,
                  ),
                ];
              },
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Measures.vMarginSmall),
                  // TabBar
                  TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: const EdgeInsets.only(right: Measures.hMarginMed),
                      dividerHeight: 0,
                      tabs: {
                        'Scheda': 'png/sheet',
                        'Inventario': 'png/inventory',
                        'Incantesimi': 'png/scepter',
                        'Background': 'png/background',
                        'Abilità': 'png/ability',
                      }
                          .entries
                          .indexed
                          .map((e) => Tab(
                                child: Row(
                                  children: [
                                    (e.$2.value + (_tabController!.index == e.$1 ? '_on' : '_off'))
                                        .toIcon(height: 20),
                                    const SizedBox(width: Measures.hMarginSmall),
                                    Text(
                                      e.$2.key,
                                      style: _tabController!.index == e.$1
                                          ? Fonts.bold()
                                          : Fonts.light(size: 16),
                                    ),
                                  ],
                                ),
                              ))
                          .toList()
                          .cast<Widget>()),
                  const SizedBox(height: Measures.vMarginThin),
                  // Body
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _screens!
                          .map((e) => SingleChildScrollView(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        [1, 2, 3].contains(_screens!.indexOf(e)) ? 0 : Measures.hPadding),
                                child: e,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom vignette
          const BottomVignette(height: 0, spread: 50),
          // FAB
          if (fabs[_tabController!.index] != null) FAB(fabs[_tabController!.index]!),
        ],
      ),
    );
  }

  Widget inventoryItemCard(InventoryItem item, int quantity) => Padding(
        padding: const EdgeInsets.only(bottom: Measures.vMarginThinnest),
        child: GlassCard(
          isLight: item.regDateTimestamp != null,
          bottomSheetArgs: BottomSheetArgs(
              header: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InventoryItem.icons[item.runtimeType]!.toIcon(
                          height: 22,
                          color: item.regDateTimestamp == null
                              ? item is Coin
                                  ? Coin.iconColors[item.title]
                                  : null
                              : Palette.primaryYellow),
                      const SizedBox(width: Measures.hMarginMed),
                      Text(item.title,
                          style: Fonts.regular(
                              color: item.regDateTimestamp == null ? null : Palette.primaryYellow)),
                      if (quantity > 1) Text(' (x$quantity)', style: Fonts.black(size: 16)),
                    ],
                  ),
                ),
              ),
              items: [
                // Roll damage dice
                if (item is Weapon)
                  BottomSheetItem(
                      'png/dice_on',
                      'Tira i danni',
                      () => context.goto('/dice',
                          args: DiceArgs(
                              title: 'Lancio di danni per ${item.title}',
                              dices: item.rollDamage,
                              modifier: item.fixedDamage,
                              oneShot: true))),
                // Edit quantity
                BottomSheetItem('png/quantity', 'Modifica quantità', () {
                  onSubmit(int value) {
                    if (value == quantity) return;
                    _character!.editQuantity(item, value);
                    setState(() {});
                    print('⬆️ Ho salvato la modifica della quantità dell\'item ${item.title}');
                    DataManager().save(_character!);
                  }

                  final numericInput = NumericInput(NumericInputArgs(
                      min: 1,
                      max: 999,
                      defaultValue: quantity.toDouble(),
                      onSubmit: (value) {
                        onSubmit(value.toInt());
                        Navigator.of(context).pop();
                      },
                      autofocus: true));
                  context.popup(
                    'Inserisci la nuova quantità di ${item.title}',
                    message: 'Al momento ne hai $quantity.',
                    child: Align(alignment: Alignment.center, child: numericInput),
                    positiveCallback: () async => onSubmit(numericInput.value),
                    negativeCallback: () {},
                    positiveText: 'Conferma',
                    negativeText: 'Annulla',
                  );
                }),
                // Sell item
                if (item is! Coin)
                  BottomSheetItem('png/coin', 'Vendi', () async {
                    final coins = DataManager()
                        .cachedInventoryItems
                        .whereType<Coin>()
                        .where((coin) => coin.authorUID == null)
                        .toList()
                      ..sort();
                    final coinNumericInputs = List.generate(
                        coins.length,
                        (i) => NumericInput(NumericInputArgs(
                            min: 0,
                            max: 99,
                            initialValue: i == coins.length - 1 ? '1' : '0',
                            isDense: false)));
                    var quantityToSell = 1.0;
                    context.popup('Stai per vendere ${item.title}',
                        message: 'A quanto vuoi vendere un\'unità di **${item.title}**?',
                        noContentHPadding: true,
                        positiveCallback: () async {
                          _character?.editQuantity(item, (quantity - quantityToSell).round());
                          _character?.addLoot(Loot({
                            for (var (i, coin) in coins.indexed)
                              coin.uid!: (coinNumericInputs[i].value * quantityToSell).round()
                          }));
                          setState(() {});
                          bool hasUndone = false;
                          await context.snackbar('Hai venduto ${item.title} (x${quantityToSell.round()})',
                              backgroundColor: Palette.backgroundBlue, undoCallback: () {
                            if (!mounted) return;
                            hasUndone = true;
                            _character?.addLoot(Loot({item.uid!: quantityToSell.round()}));
                            for (var (i, coin) in coins.indexed) {
                              _character?.editQuantity(
                                  coin,
                                  (_character!.inventoryUIDs[coin.uid!] ?? 0) -
                                      (coinNumericInputs[i].value * quantityToSell).round());
                            }
                            setState(() {});
                          });
                          if (!hasUndone) {
                            print('⬆️ Ho salvato la vendita dell\'item ${item.title}');
                            DataManager().save(_character!);
                          }
                        },
                        negativeCallback: () {},
                        positiveText: 'Si',
                        negativeText: 'No',
                        backgroundColor: Palette.backgroundGrey.withOpacity(0.9),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            for (var numericInput in coinNumericInputs) {
                              numericInput.args.onSubmit = (_) => setState(() {});
                            }
                            return Column(
                              children: [
                                // Unity sell price
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                                  child: GridRow(
                                    fill: true,
                                    columnsCount: 3,
                                    children: [
                                      ...coins.map((coin) => Row(
                                            children: [
                                              'png/coin'.toIcon(color: Coin.iconColors[coin.title]),
                                              coinNumericInputs[coins.indexOf(coin)],
                                            ],
                                          ))
                                    ],
                                  ),
                                ),

                                // Quantity
                                GlassCard(
                                  isFlat: true,
                                  clickable: false,
                                  isLight: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: Measures.vMarginThin),
                                        Text('Unità da vendere:', style: Fonts.bold()),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Slider(
                                                value: quantityToSell,
                                                onChanged: (value) {
                                                  setState(() => quantityToSell = value);
                                                  if (quantityToSell == 0) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                min: 0,
                                                max: quantity.toDouble(),
                                                activeColor: Palette.primaryBlue,
                                                label: quantityToSell.round().toString(),
                                                divisions: quantity,
                                              ),
                                            ),
                                            Text('x${quantityToSell.round()}',
                                                style: Fonts.black(size: 18)),
                                            const SizedBox(width: Measures.hMarginBig)
                                          ],
                                        ),
                                        const SizedBox(height: Measures.vMarginMoreThin),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Measures.vMarginThin),
                                const Rule(),
                                const SizedBox(height: Measures.vMarginThin),

                                // Summary
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Measures.hPadding),
                                  child: Column(
                                    children: [
                                      // Total income
                                      Text('Ricavi totali:', style: Fonts.bold()),
                                      const SizedBox(height: Measures.vMarginThin),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ...coins.map((coin) => Row(
                                                children: [
                                                  'png/coin'.toIcon(
                                                      height: 18, color: Coin.iconColors[coin.title]),
                                                  const SizedBox(width: Measures.hMarginThin),
                                                  Text(
                                                      (coinNumericInputs[coins.indexOf(coin)].value *
                                                              quantityToSell)
                                                          .round()
                                                          .toString(),
                                                      style: Fonts.black(size: 18)),
                                                ],
                                              ))
                                        ],
                                      ),
                                      const SizedBox(height: Measures.vMarginSmall),
                                      // After sale
                                      Text('Monete dopo la vedita:', style: Fonts.bold()),
                                      const SizedBox(height: Measures.vMarginThin),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ...coins.map((coin) => Row(
                                                children: [
                                                  'png/coin'.toIcon(
                                                      height: 18, color: Coin.iconColors[coin.title]),
                                                  const SizedBox(width: Measures.hMarginThin),
                                                  Text(
                                                      ((_character!.coinsUIDs[coin.uid!] ?? 0) +
                                                              (coinNumericInputs[coins.indexOf(coin)]
                                                                          .value *
                                                                      quantityToSell)
                                                                  .round())
                                                          .toString(),
                                                      style: Fonts.black(size: 18)),
                                                ],
                                              ))
                                        ],
                                      ),
                                      const SizedBox(height: Measures.vMarginSmall),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ));
                  }),
                // Remove item
                BottomSheetItem('png/delete_2', 'Scarta', () async {
                  var quantityToDiscard = 1.0;
                  context.popup('Stai per scartare delle unità di ${item.title}',
                      message: 'Quante unità di **${item.title}** vuoi scartare dal tuo inventario?',
                      child: Column(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) => Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: quantityToDiscard,
                                    onChanged: (value) {
                                      setState(() => quantityToDiscard = value);
                                      if (quantityToDiscard == 0) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    min: 0,
                                    max: quantity.toDouble(),
                                    activeColor: Palette.primaryBlue,
                                    label: quantityToDiscard.round().toString(),
                                    divisions: quantity,
                                  ),
                                ),
                                Text('x${quantityToDiscard.round()}', style: Fonts.black(size: 18)),
                                const SizedBox(width: Measures.hMarginBig)
                              ],
                            ),
                          ),
                          const SizedBox(height: Measures.vMarginMoreThin),
                        ],
                      ), positiveCallback: () async {
                    _character?.editQuantity(
                        item, (_character!.inventoryUIDs[item.uid!]! - quantityToDiscard).round());
                    setState(() {});
                    bool hasUndone = false;
                    await context.snackbar('Hai scartato ${item.title} (x${quantityToDiscard.round()})',
                        backgroundColor: Palette.backgroundBlue, undoCallback: () {
                      if (!mounted) return;
                      hasUndone = true;
                      _character?.addLoot(Loot({item.uid!: quantityToDiscard.round()}));
                      setState(() {});
                    });
                    if (!hasUndone) {
                      print('⬆️ Ho salvato la rimozione dell\'item ${item.title}');
                      DataManager().save(_character!);
                    }
                  },
                      negativeCallback: () {},
                      positiveText: 'Conferma',
                      negativeText: 'Annulla',
                      backgroundColor: Palette.backgroundGrey.withOpacity(0.2));
                }),
                // Read full description
                if (item.description != null && item.description!.length > 30)
                  BottomSheetItem('info', 'Leggi descrizione', () {
                    context.popup(item.title,
                        message: item.description,
                        positiveText: 'Ok',
                        backgroundColor: Palette.backgroundGrey.withOpacity(0.2));
                  }),
              ]),
          isFlat: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: Measures.hPadding),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon + Title + Amount
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InventoryItem.icons[item.runtimeType]!.toIcon(
                                  height: 22,
                                  color: item.regDateTimestamp == null
                                      ? item is Coin
                                          ? Coin.iconColors[item.title]
                                          : null
                                      : Palette.primaryYellow),
                              const SizedBox(width: Measures.hMarginSmall),
                              Text(item.title,
                                  style: Fonts.regular(
                                      color:
                                          item.regDateTimestamp == null ? null : Palette.primaryYellow)),
                              if (quantity > 1) Text(' (x$quantity)', style: Fonts.black(size: 16)),
                            ],
                          ),
                        ),
                      ),
                      if (item is Weapon)
                        // Roll damage + Fixed damage
                        Row(
                          children: [
                            const SizedBox(width: Measures.hMarginMed),
                            ...item.rollDamage.map((e) => SvgPicture.asset(e.svgPath, height: 28)),
                            Text('  + ${item.fixedDamage}', style: Fonts.black(size: 18)),
                          ],
                        ),
                      if (item is Armor)
                        // Disadvantage + Stringth
                        Row(
                          children: [
                            if (item.isHeavy) ...[
                              const SizedBox(width: Measures.hMarginMed),
                              'png/heavy'.toIcon(height: 22, color: Palette.primaryGreen),
                            ],
                            const SizedBox(width: Measures.hMarginMed),
                            'png/strength'.toIcon(height: 22, color: Skill.forza.color),
                            Text('  ${item.strength}', style: Fonts.black(size: 18)),
                          ],
                        ),
                    ],
                  ),
                  // Type-based properties
                  if (item is Weapon || item is Armor) ...[
                    const SizedBox(height: Measures.vMarginMoreThin),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (item is Weapon) Text(item.property, style: Fonts.light()),
                            if (item is Armor) ...[
                              'png/shield'.toIcon(height: 18, color: Palette.primaryBlue),
                              const SizedBox(width: Measures.hMarginSmall),
                              RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(text: '${item.caString.item1} ', style: Fonts.black(size: 18)),
                                  TextSpan(text: '+ ${item.caString.item2}', style: Fonts.light()),
                                ],
                              )),
                            ],
                          ],
                        ),
                      ),
                    )
                  ],
                  // Description
                  if (item.description != null || item.regDateTimestamp != null) ...[
                    const SizedBox(height: Measures.vMarginMoreThin),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Description
                        item.description == null
                            ? Container()
                            : Expanded(
                                child: SingleChildScrollView(
                                    child: Text(
                                  item.description!,
                                  style: Fonts.regular(size: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ),
                        // How long ago it was added (if added by the user)
                        if (item.regDateTimestamp != null) ...[
                          const SizedBox(width: Measures.hMarginMed),
                          Text(item.dateReg!.toPostStr(), style: Fonts.light()),
                        ]
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
