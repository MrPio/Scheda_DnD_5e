import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/enum/character_alignment.localized.g.part';
import 'package:scheda_dnd_5e/enum/character_background.localized.g.part';
import 'package:scheda_dnd_5e/enum/class.localized.g.part';
import 'package:scheda_dnd_5e/enum/race.localized.g.part';
import 'package:scheda_dnd_5e/extension_function/map_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/mixin/comparable.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart' hide Type;
import 'package:tuple/tuple.dart';

import '../enum/character_alignment.dart';
import '../enum/character_background.dart';
import '../enum/class.dart';
import '../enum/dice.dart';
import '../enum/language.dart';
import '../enum/mastery.dart';
import '../enum/race.dart';
import '../enum/skill.dart';
import '../enum/status.dart';
import '../enum/subclass.dart';
import '../enum/subrace.dart';
import '../enum/subskill.dart';
import 'loot.dart';

part 'part/character.g.dart';









@JsonSerializable(constructor: 'jsonConstructor')
class Character with Comparable<Character> implements WithUID {
  int regDateTimestamp;
  String? campaignUID;
  String authorUID;
  @JsonKey(includeFromJson: true, includeToJson: true)
  String _name;
  @JsonKey(includeFromJson: true, includeToJson: true)
  int _hp, _maxHp;
  Class class_;
  SubClass subClass;
  Race race;
  SubRace? subRace;
  @JsonKey(includeFromJson: true, includeToJson: true)
  Map<Skill, int> _chosenSkills = {}; // The sum of any choice dictated by the race and subRace selections
  Map<Skill, int> rollSkills = {}; // The results of the dice thrown at the end of the character creation
  Map<Skill, int> customSkills = {}; // The custom skills values manually assigned by the user
  Map<SubSkill, int> subSkills = {};
  Map<Level, int> totalSlots = {};
  Map<Level, int> availableSlots = {};
  Set<Mastery> masteries = {};
  Set<Language> languages = {};
  Set<String> enchantmentUIDs = {};
  Status? status;
  CharacterAlignment alignment;
  int level, armorClass, initiative;
  Map<String, int> weaponsUIDs = {}, armorsUIDs = {}, itemsUIDs = {}, coinsUIDs = {};
  double speed;
  String? physical, history, traits, defects, ideals, bonds;

  Map<Type, Map<String, int>> get inventoryItems => {
        Weapon: weaponsUIDs,
        Armor: armorsUIDs,
        Item: itemsUIDs,
        Coin: coinsUIDs,
      };

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get name => _name;

  set name(String value) {
    if (value.length < 3) {
      throw const FormatException('Il nome deve avere almeno 3 caratteri');
    }
    _name = value;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<Skill, int> get chosenSkills => _chosenSkills;

  set chosenSkills(Map<Skill, int> value) {
    _chosenSkills = value.map((key, value) => MapEntry(key, max(3, min(18, value))));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get hp => _hp;

  set hp(int value) {
    if (value < -_maxHp || value > _maxHp) {
      throw const FormatException('The HP must be greater than -maxHp and less than maxHP');
    }
    _hp = value;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get maxHp => _maxHp;

  set maxHp(int value) {
    if (value <= 0 || value > 99) {
      throw const FormatException('The max HP must be positive and less than 100');
    }
    if (_hp > value) {
      _hp = value;
    }
    _maxHp = value;
  }

  Character.jsonConstructor(
      this.regDateTimestamp,
      this.campaignUID,
      this.authorUID,
      this._name,
      int? _hp,
      int? _maxHp,
      Map<String, int>? weaponsUIDs,
      Map<String, int>? armorsUIDs,
      Map<String, int>? itemsUIDs,
      Map<String, int>? coinsUIDs,
      this.class_,
      this.subClass,
      this.race,
      this.subRace,
      Map<Skill, int>? _chosenSkills,
      Map<Skill, int>? rollSkills,
      Map<Skill, int>? customSkills,
      Map<SubSkill, int>? subSkills,
      Map<Level, int>? totalSlots,
      Map<Level, int>? availableSlots,
      Set<Mastery>? masteries,
      Set<Language>? languages,
      this.status,
      this.alignment,
      this.level,
      this.armorClass,
      this.initiative,
      this.speed,
      this.physical,
      this.history,
      this.traits,
      this.defects,
      this.ideals,
      this.bonds,
      Set<String>? enchantmentUIDs)
      : weaponsUIDs = weaponsUIDs ?? {},
        armorsUIDs = armorsUIDs ?? {},
        itemsUIDs = itemsUIDs ?? {},
        coinsUIDs = coinsUIDs ?? {},
        _chosenSkills = _chosenSkills ?? {},
        rollSkills = rollSkills ?? {},
        customSkills = customSkills ?? {},
        subSkills = subSkills ?? {},
        totalSlots = totalSlots ?? {},
        availableSlots = availableSlots ?? {},
        masteries = masteries ?? {},
        languages = languages ?? {},
        enchantmentUIDs = enchantmentUIDs ?? {},
        _hp = _hp ?? 10,
        _maxHp = _maxHp ?? 10 {
    // Assert that each inventory entry has at least 1 amount. Non owned items should not be in the inventory map.
    for (var qta in inventoryUIDs.values) {
      assert(qta > 0);
    }
    assert(level > 0);
    for (var key in this.subSkills.keys) {
      assert(0 <= this.subSkills[key]! && this.subSkills[key]! <= 2);
    }
  }

  Character()
      : _name = '',
        _hp = 10,
        _maxHp = 10,
        authorUID = AccountManager().user.uid!,
        level = 1,
        armorClass = 0,
        subClass = Class.barbaro.subClasses[0],
        regDateTimestamp = DateTime.now().millisecondsSinceEpoch,
        class_ = Class.barbaro,
        race = Race.umano,
        speed = Race.umano.defaultSpeed,
        alignment = CharacterAlignment.nessuno,
        initiative = 0;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<Map<InventoryItem, int>?> inventory = ValueNotifier(null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get defaultSpeed => (subRace?.defaultSpeed ?? race.defaultSpeed);

  // The following two getters are useful for the backend, which ignores some aspects needed for the calculation
  @JsonKey(includeFromJson: false, includeToJson: true)
  Map<Skill, int> get skills =>
      Map.fromIterable(Skill.values, value: (_) => 0).cast<Skill, int>() +
      customSkills +
      rollSkills +
      _chosenSkills +
      race.defaultSkills +
      (subRace?.defaultSkills ?? {});

  @JsonKey(includeFromJson: false, includeToJson: true)
  Map<Skill, int> get skillsModifier => skills.map((skill, value) => MapEntry(skill, (value ~/ 2) - 5));

  @JsonKey(includeFromJson: false, includeToJson: false)
  int get competenceBonus => (level - 1) ~/ 4 + 2;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, int> get inventoryUIDs => weaponsUIDs + armorsUIDs + itemsUIDs + coinsUIDs;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<Set<Enchantment>?> enchantments = ValueNotifier(null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<CharacterBackground, String?> get descriptions => {
        CharacterBackground.physical: physical,
        CharacterBackground.history: history,
        CharacterBackground.traits: traits,
        CharacterBackground.defects: defects,
        CharacterBackground.ideals: ideals,
        CharacterBackground.bonds: bonds,
      };

  set descriptions(Map<CharacterBackground, String?> value) {
    physical = value[CharacterBackground.physical];
    history = value[CharacterBackground.history];
    traits = value[CharacterBackground.traits];
    defects = value[CharacterBackground.defects];
    ideals = value[CharacterBackground.ideals];
    bonds = value[CharacterBackground.bonds];
  }

  // il max è 20
  int skillValue(Skill skill) =>
      customSkills[skill] ??
      ((rollSkills[skill] ?? 0) +
          (_chosenSkills[skill] ?? 0) +
          (race.defaultSkills[skill] ?? 0) +
          (subRace?.defaultSkills[skill] ?? 0));

  int skillModifier(Skill skill) => (skillValue(skill) ~/ 2) - 5;

  int subSkillValue(SubSkill subSkill) =>
      skillModifier(subSkill.skill) + (subSkills[subSkill] ?? 0) * competenceBonus;

  int savingThrowValue(Skill skill) =>
      skillModifier(skill) + (class_.savingThrows.contains(skill) ? 1 : 0) * competenceBonus;

  addLoot(Loot loot) {
    loot.content.forEach((item, qta) {
      if (qta > 0) {
        if (item is Equipment) {
          addLoot(Loot({for (var e in item.content.entries) e.key: e.value * qta}));
        } else {
          if (inventoryItems[item.runtimeType]!.containsKey(item.uid!)) {
            inventoryItems[item.runtimeType]![item.uid!] =
                inventoryItems[item.runtimeType]![item.uid!]! + qta;
          } else {
            inventoryItems[item.runtimeType]![item.uid!] = qta;
          }
          if (inventory.value != null) inventory.value = inventory.value! + {item: qta};
        }
      }
    });
  }

  editQuantity(InventoryItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItems([item]);
    } else if (item is! Equipment) {
      inventoryItems[item.runtimeType]![item.uid!] = newQuantity;
      if (inventory.value != null) {
        inventory.value![item] = newQuantity;
      }
    }
  }

  removeItems(List<InventoryItem> items) {
    for (var item in items) {
      if (item is! Equipment) {
        inventoryItems[item.runtimeType]!.removeWhere((key, value) => key.match(item.uid!));
        if (inventory.value != null) {
          inventory.value!.removeWhere((key, value) => key.uid!.match(item.uid!));
        }
      }
    }
  }

  @override
  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CharacterToJson(this);

  @override
  String toString() {
    return json.encode(toJSON());
  }

  @override
  // Compare by creation date in descending order
  int compareTo(Character other) => regDateTimestamp.compareTo(other.regDateTimestamp) * -1;

  String backgroundQuery(CharacterBackground background, BuildContext context) =>
      "I am playing Dungeon and Dragons. Generate a creative description of my character. ${background.hint(context)} of my character based on these characteristics: his name is $name, his class is ${class_.title(context)}, his race is ${race.title(context)}, his alignment is ${alignment.title(context)} and at the moment is level is $level.";
}
