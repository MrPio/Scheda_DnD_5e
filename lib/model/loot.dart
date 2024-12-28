import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/enum/skill.localized.g.part';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';
import 'package:scheda_dnd_5e/mixin/comparable.dart';
import 'package:tuple/tuple.dart';

import '../enum/dice.dart';
import '../enum/skill.dart';
import '../interface/enum_with_title.dart';
import 'character.dart';

part 'part/loot.g.dart';

/// Any item that can be part of a character's inventory
abstract class InventoryItem with Comparable<InventoryItem> implements WithUID, WithTitle {
  @JsonKey(includeFromJson: true, includeToJson: true, defaultValue: '')
  String _title = '';

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get title => _title;

  set title(value) {
    if (value.length < 3) {
      throw const FormatException('Il nome deve avere almeno 3 caratteri');
    }
    if (DataManager().cachedInventoryItems.where((e) => e.title.match(value)).isNotEmpty) {
      throw const FormatException('Un oggetto con questo nome già esiste. Provane un altro');
    }
    _title = value;
  }

  String? description;
  int? regDateTimestamp; // null if not added by user
  String? authorUID; // null if not added by user
  static const Map<Type, String> icons = {
    Weapon: 'png/weapon',
    Armor: 'png/armor',
    Item: 'png/item',
    Coin: 'png/coin',
    Equipment: 'png/equipment',
  };
  static const Map<Type, String> names = {
    Weapon: 'Armi',
    Armor: 'Armature',
    Item: 'Oggetti',
    Coin: 'Monete',
    Equipment: 'Dotazioni',
  };
  static const Map<Type, String> namesSingulars = {
    Weapon: 'Arma',
    Armor: 'Armatura',
    Item: 'Oggetto',
    Coin: 'Moneta',
    Equipment: 'Dotazione',
  };

  static List<Type> get types => icons.keys.toList();

  DateTime? get dateReg =>
      regDateTimestamp == null ? null : DateTime.fromMillisecondsSinceEpoch(regDateTimestamp!);

  InventoryItem({title = '', this.regDateTimestamp, this.authorUID, this.description}) {
    _title = title;
  }

  @override
  int compareTo(InventoryItem other) {
    if (regDateTimestamp != null && other.regDateTimestamp != null) {
      return -regDateTimestamp!.compareTo(other.regDateTimestamp!);
    }
    if (regDateTimestamp != null) return -1;
    if (other.regDateTimestamp != null) return 1;
    return title.compareTo(other.title);
  }
}

@JsonSerializable(constructor: 'jsonConstructor')
class Weapon extends InventoryItem {
  @JsonKey(includeFromJson: true, includeToJson: true, defaultValue: [])
  List<Dice> _rollDamage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Dice> get rollDamage => _rollDamage;

  set rollDamage(value) {
    if (value.isEmpty) {
      throw const FormatException('Devi selezionare almeno un dado');
    }
    _rollDamage = value;
  }

  int fixedDamage;
  String property;

  Weapon.jsonConstructor(
      {super.title,
      super.authorUID,
      super.regDateTimestamp,
      super.description,
      List<Dice>? rollDamage,
      this.fixedDamage = 0,
      this.property = ''})
      : _rollDamage = rollDamage ?? [];

  Weapon(title, this._rollDamage, this.fixedDamage, this.property)
      : uid = title,
        super(title: title);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Weapon.fromJson(Map<String, dynamic> json) => _$WeaponFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$WeaponToJson(this);
}

@JsonSerializable(constructor: 'jsonConstructor')
class Armor extends InventoryItem {
  int ca;

  /// Bonus on skill values. The value of each entry represents the maximum bonus for that skill
  Map<Skill, int> skillModifiers;

  /// The strength requirement to equip the armor
  int strength;

  /// Heavy armors have a disadvantage on stealth rolls
  bool isHeavy;

  /// Partial armors don't give an absolute CA, but a CA bonus
  bool isPartial;

  Armor.jsonConstructor(
      {super.title,
      super.authorUID,
      super.regDateTimestamp,
      super.description,
      this.ca = 0,
      this.strength = 0,
      Map<Skill, int>? skillModifiers,
      this.isHeavy = false,
      this.isPartial = false})
      : skillModifiers = skillModifiers ?? {};

  Armor(title, this.ca, this.strength, this.isHeavy, this.skillModifiers, this.isPartial)
      : uid = title,
        super(title: title);

  Tuple2<String, String> caString(BuildContext context)=> Tuple2(
      "${isPartial ? '+' : ''}$ca",
      skillModifiers.entries
          .map((e) => '${e.key.title(context)}${e.value > 0 ? ' (max ${e.value})' : ''}')
          .join(', '));
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Armor.fromJson(Map<String, dynamic> json) => _$ArmorFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$ArmorToJson(this);
}

@JsonSerializable(constructor: 'jsonConstructor')
class Item extends InventoryItem {
  Item.jsonConstructor({super.title, super.authorUID, super.regDateTimestamp, super.description});

  Item(title)
      : uid = title,
        super(title: title);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$ItemToJson(this);
}

@JsonSerializable(constructor: 'jsonConstructor')
class Coin extends InventoryItem {
  int value;
  @JsonKey(includeFromJson: true, includeToJson: true, defaultValue: '')
  String _currency;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get currency => _currency;

  set currency(String value) {
    if (value.isEmpty) {
      throw const FormatException('La sigla deve essere lunga almeno 1 carattere');
    }
    if (DataManager().cachedCoins.where((e) => e.title.match(value)).isNotEmpty) {
      throw const FormatException('Una valuta con questa sigla già esiste. Provane un\'altra');
    }
    _currency = value;
  }

  static const Map<String, Color> iconColors = {
    'Platino': Color(0xFFffffff),
    'Oro': Color(0xFFe5e573),
    'Electrum': Color(0xFF64ace1),
    'Argento': Color(0xFFa3a3a3),
    'Rame': Color(0xFFe5737c),
  };

  Coin.jsonConstructor(
      {super.title,
      super.authorUID,
      super.regDateTimestamp,
      super.description,
      currency = '',
      this.value = 0})
      : _currency = currency;

  Coin(title, this._currency, this.value)
      : uid = title,
        super(title: title);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CoinToJson(this);

  @override
// Compare by value in descending order
  int compareTo(InventoryItem other) => other is Coin ? -value.compareTo(other.value) : 0;
}

@JsonSerializable(constructor: 'jsonConstructor')
class Equipment extends InventoryItem {
  final Map<String, int> content;

  Equipment.jsonConstructor(
      {super.title,
      super.authorUID,
      super.regDateTimestamp,
      super.description,
      Map<String, int>? content})
      : content = content ?? {};

  Equipment(title, this.content)
      : uid = title,
        super(title: title);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Equipment.fromJson(Map<String, dynamic> json) => _$EquipmentFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$EquipmentToJson(this);

  Loot get loot => Loot(content, title);
}

@JsonSerializable(constructor: 'jsonConstructor')
class Loot implements JSONSerializable {
  @JsonKey(includeFromJson: true, includeToJson: true)
  final String? _name;
  @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<String, int> _content;

  Loot.jsonConstructor(this._name, this._content);

  Loot(this._content, [this._name]);

  String get name => _name ?? _content.keys.toList()[0];

  /// This requires that DataManager.fetchData() has been called
  Map<InventoryItem, int> get content => {
        for (var entry in _content.entries)
          DataManager().cachedInventoryItems.firstWhere((e) => e.uid!.match(entry.key)): entry.value
      };

  @override
  factory Loot.fromJson(Map<String, dynamic> json) => _$LootFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$LootToJson(this);
}
