import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/extension_function/string_extensions.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/manager/data_manager.dart';

import '../enum/dice.dart';
import '../interface/enum_with_title.dart';

part 'part/loot.g.dart';

/// Any item that can be part of a character's inventory
abstract class InventoryItem implements WithUID, WithTitle {
  @override
  String title = '';
  final int regDateTimestamp;
  final String? authorUID;
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

  static List<Type> get types => icons.keys.toList();

  InventoryItem({this.title = '', int? regDateTimestamp, this.authorUID})
      : regDateTimestamp = regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch;
}

@JsonSerializable(constructor: 'jsonConstructor')
class Weapon extends InventoryItem {
  final List<Dice> rollDamage;
  final int fixedDamage;
  final String property;

  Weapon.jsonConstructor(
      {super.title,
      super.authorUID,
      super.regDateTimestamp,
      List<Dice>? rollDamage,
      this.fixedDamage = 0,
      this.property = ''})
      : rollDamage = rollDamage ?? [];

  Weapon(title, this.rollDamage, this.fixedDamage, this.property)
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
  final String CA;
  final int strength;
  final bool disadvantage;

  Armor.jsonConstructor(
      {super.title,
      super.authorUID,
      super.regDateTimestamp,
      this.CA = '',
      this.strength = 0,
      this.disadvantage = false});

  Armor(title, this.CA, this.strength, this.disadvantage)
      : uid = title,
        super(title: title);

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
  final String description;

  Item.jsonConstructor({super.title, super.authorUID, super.regDateTimestamp, this.description = ''});

  Item(title)
      : uid = title,
        description = '',
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
  final int value;
  final String currency;

  Coin.jsonConstructor(
      {super.title, super.authorUID, super.regDateTimestamp, this.currency = '', this.value = 0});

  Coin(title, this.currency, this.value)
      : uid = title,
        super(title: title);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CoinToJson(this);
}

@JsonSerializable(constructor: 'jsonConstructor')
class Equipment extends InventoryItem {
  final Map<String, int> content;

  Equipment.jsonConstructor(
      {super.title, super.authorUID, super.regDateTimestamp, Map<String, int>? content})
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

  Loot(this._content, [this._name]) {
    for (var qta in _content.values) {
      assert(qta > 0);
    }
  }

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
