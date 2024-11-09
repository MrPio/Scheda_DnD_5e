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
import 'package:scheda_dnd_5e/view/characters_page.dart';
import 'package:scheda_dnd_5e/view/partial/bottom_vignette.dart';
import 'package:scheda_dnd_5e/view/partial/card/alignment_card.dart';
import 'package:scheda_dnd_5e/view/partial/card/sheet_item_card.dart';
import 'package:scheda_dnd_5e/view/partial/chevron.dart';
import 'package:scheda_dnd_5e/view/partial/clickable.dart';
import 'package:scheda_dnd_5e/view/partial/glass_card.dart';
import 'package:scheda_dnd_5e/view/partial/grid_column.dart';
import 'package:scheda_dnd_5e/view/partial/grid_row.dart';
import 'package:scheda_dnd_5e/view/partial/hp_bar.dart';
import 'package:scheda_dnd_5e/view/partial/level.dart';
import 'package:scheda_dnd_5e/view/partial/numeric_input.dart';
import 'package:scheda_dnd_5e/view/partial/rule.dart';

import '../model/character.dart' hide Alignment;
import 'partial/gradient_background.dart';

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

  List<InventoryItem>? get inventoryItems => _character?.inventory.value?.keys.toList()?..sort();

  bool _getIsInventoryItemExpanded(Type type) =>
      IOManager().get<bool>('character_page_isInventoryItemExpanded_$type') ?? true;

  _setIsInventoryItemExpanded(Type type, bool value) =>
      IOManager().set('character_page_isInventoryItemExpanded_$type', value);
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
    // Assign the EditTexts values to the character object fields
    _character!.armorClass = int.tryParse(_armorClassController.text) ?? _character!.armorClass;
    _character!.speed =
        double.tryParse(_speedController.text.replaceAll(_speedSuffix, '')) ?? _character!.speed;
    _character!.initiative = int.tryParse(_initiativeController.text) ?? _character!.initiative;

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
      _character!.inventory.addListener(() => setState(() {}));
    }
    final character = _character!;
    final hpBottomSheetArgs = BottomSheetArgs(
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
    var sheetAttributes = [
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
                  onSubmitted: (value) {
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
      SheetItemCard(iconPath: 'png/bonus', text: 'BC', value: character.competenceBonus.toSignedString()),
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
    var sheetSkills = [
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
                      onSubmitted: (value) {
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
                                    horizontal: Measures.hMarginMed, vertical: Measures.vMarginMoreThin),
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
                                          border: Border.all(color: Palette.onBackground, width: 0.65),
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
    _screens = [
      // Sheet
      Column(
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
                              },
                                  negativeCallback: () {},
                                  positiveText: 'Si',
                                  negativeText: 'No',
                                  backgroundColor: Palette.background.withOpacity(0.5));
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
                                                        .where((e) => !character.masteries.contains(e))
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
                                  backgroundColor: Palette.background.withOpacity(0.5));
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Measures.vMarginMed),
          // Inventory sections
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
                            height: 16, rotation: _getIsInventoryItemExpanded(type) ? pi / 2 : -pi / 2)
                    ]),
                  ),
                ),
                // List of inventory items
                if (character.inventory.value == null)
                  ...List.filled(2, const GlassCard(isShimmer: true, isFlat: true, shimmerHeight: 50)),
                if (character.inventory.value != null) ...[
                  if (!isEmpty && _getIsInventoryItemExpanded(type))
                    ...inventoryItems!
                        .where((e) => e.runtimeType == type)
                        .map((e) => inventoryItemCard(e, _character!.inventory.value![e]!)),
                  if (!_getIsInventoryItemExpanded(type))
                    const Padding(
                      padding: EdgeInsets.only(top: Measures.vMarginThin),
                      child: Rule(),
                    ),
                  if (isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Measures.vMarginMoreThin),
                      child: Text('Niente da mostrare', style: Fonts.black(color: Palette.card2)),
                    )
                ],
                const SizedBox(height: Measures.vMarginSmall),
              ],
            );
          }),
          const SizedBox(height: Measures.vMarginBig),
        ],
      ),
      // Enchantments
      const Placeholder(),
      // Background
      const Placeholder(),
      // Ability
      const Placeholder(),
    ];
    _tabController ??= TabController(length: _screens!.length, vsync: this)
      ..addListener(() {
        // Load character inventory
        if (_tabController?.index == 1) {
          character.inventory.value = null;
          DataManager().loadCharacterInventory(character);
        }
        setState(() {});
      });

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
                                    horizontal: _screens!.indexOf(e) == 1 ? 0 : Measures.hPadding),
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
        ],
      ),
    );
  }

  Widget inventoryItemCard(InventoryItem item, int amount) => GlassCard(
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
                                    : Palette.primaryBlue),
                            const SizedBox(width: Measures.hMarginSmall),
                            Text(item.title, style: Fonts.regular()),
                            if (amount > 1) Text(' (x$amount)', style: Fonts.black(size: 16)),
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
                          Text('  + ${item.fixedDamage}', style: Fonts.black(size: 18))
                        ],
                      ),
                    if (item is Armor)
                      // Disadvantage + Stringth
                      Row(
                        children: [
                          if (item.disadvantage) ...[
                            const SizedBox(width: Measures.hMarginMed),
                            'png/disadvantage'.toIcon(height: 22, color: Palette.primaryBlue),
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
                                TextSpan(
                                    text: '${item.CA.contains(' ') ? item.CA.split(' ')[0] : item.CA} ',
                                    style: Fonts.black(size: 18)),
                                TextSpan(
                                    text:
                                        '${item.CA.contains(' ') ? item.CA.split(' ').slice(1).join(' ') : ''} ',
                                    style: Fonts.light()),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Description
                      item.description == null
                          ? Container()
                          : Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(item.description!, style: Fonts.light()),
                              ),
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
      );
}
