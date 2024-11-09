// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../loot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weapon _$WeaponFromJson(Map<String, dynamic> json) => Weapon.jsonConstructor(
      title: json['title'] as String? ?? '',
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      rollDamage: (json['rollDamage'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DiceEnumMap, e))
          .toList(),
      fixedDamage: json['fixedDamage'] as int? ?? 0,
      property: json['property'] as String? ?? '',
    );

Map<String, dynamic> _$WeaponToJson(Weapon instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      'rollDamage': instance.rollDamage.map((e) => _$DiceEnumMap[e]!).toList(),
      'fixedDamage': instance.fixedDamage,
      'property': instance.property,
    };

const _$DiceEnumMap = {
  Dice.d4: 'd4',
  Dice.d6: 'd6',
  Dice.d8: 'd8',
  Dice.d10: 'd10',
  Dice.d12: 'd12',
  Dice.d20: 'd20',
  Dice.d100: 'd100',
};

Armor _$ArmorFromJson(Map<String, dynamic> json) => Armor.jsonConstructor(
      title: json['title'] as String? ?? '',
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      CA: json['CA'] as String? ?? '',
      strength: json['strength'] as int? ?? 0,
      disadvantage: json['disadvantage'] as bool? ?? false,
    );

Map<String, dynamic> _$ArmorToJson(Armor instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      'CA': instance.CA,
      'strength': instance.strength,
      'disadvantage': instance.disadvantage,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item.jsonConstructor(
      title: json['title'] as String? ?? '',
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
    };

Coin _$CoinFromJson(Map<String, dynamic> json) => Coin.jsonConstructor(
      title: json['title'] as String? ?? '',
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      currency: json['currency'] as String? ?? '',
      value: json['value'] as int? ?? 0,
    );

Map<String, dynamic> _$CoinToJson(Coin instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      'value': instance.value,
      'currency': instance.currency,
    };

Equipment _$EquipmentFromJson(Map<String, dynamic> json) =>
    Equipment.jsonConstructor(
      title: json['title'] as String? ?? '',
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      content: (json['content'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
    );

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      'content': instance.content,
    };

Loot _$LootFromJson(Map<String, dynamic> json) => Loot.jsonConstructor(
      json['_name'] as String?,
      Map<String, int>.from(json['_content'] as Map),
    );

Map<String, dynamic> _$LootToJson(Loot instance) => <String, dynamic>{
      '_name': instance._name,
      '_content': instance._content,
    };
