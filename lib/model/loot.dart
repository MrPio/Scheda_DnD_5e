import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';

import '../enum/dice.dart';

part 'part/loot.g.dart';

/// Any item that can be part of a character's inventory
abstract class InventoryItem {
  String title = '';
  final int regDateTimestamp;
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

  InventoryItem({this.title = '', int? regDateTimestamp})
      : regDateTimestamp = regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch;
}

@JsonSerializable(constructor: 'jsonConstructor')
class Weapon extends InventoryItem implements WithUID {
  final List<Dice> rollDamage;
  final int fixedDamage;
  final String property;

  Weapon.jsonConstructor(
      {super.title,
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
class Armor extends InventoryItem implements WithUID {
  final String CA;
  final int strength;
  final bool disadvantage;

  Armor.jsonConstructor(
      {super.title, super.regDateTimestamp, this.CA = '', this.strength = 0, this.disadvantage = false});

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
class Item extends InventoryItem implements WithUID {
  Item.jsonConstructor({super.title, super.regDateTimestamp});

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
class Coin extends InventoryItem implements WithUID {
  final int value;
  final String currency;

  Coin.jsonConstructor({super.title, super.regDateTimestamp, this.currency = '', this.value = 0});

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
class Equipment extends InventoryItem implements WithUID {
  final Map<String, int> content;

  Equipment.jsonConstructor({super.title, super.regDateTimestamp, Map<String, int>? content})
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
  final Map<String, int> content;

  Loot.jsonConstructor(this._name, this.content);

  Loot(this.content, [this._name]) {
    for (var qta in content.values) {
      assert(qta > 0);
    }
  }

  String get name => _name ?? content.keys.toList()[0];

  // @JsonKey(includeFromJson: false, includeToJson: false)
  // Map<InventoryItem, int> get content => _content.cast<InventoryItem, int>();

  @override
  factory Loot.fromJson(Map<String, dynamic> json) => _$LootFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$LootToJson(this);
}
