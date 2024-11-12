// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../loot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weapon _$WeaponFromJson(Map<String, dynamic> json) => Weapon.jsonConstructor(
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      fixedDamage: json['fixedDamage'] as int? ?? 0,
      property: json['property'] as String? ?? '',
    )
      .._title = json['_title'] as String? ?? ''
      .._rollDamage = (json['_rollDamage'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DiceEnumMap, e))
              .toList() ??
          [];

Map<String, dynamic> _$WeaponToJson(Weapon instance) => <String, dynamic>{
      '_title': instance._title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      '_rollDamage':
          instance._rollDamage.map((e) => _$DiceEnumMap[e]!).toList(),
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
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      ca: json['ca'] as int? ?? 0,
      strength: json['strength'] as int? ?? 0,
      skillModifiers: (json['skillModifiers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$SkillEnumMap, k), e as int),
      ),
      isHeavy: json['isHeavy'] as bool? ?? false,
      isPartial: json['isPartial'] as bool? ?? false,
    ).._title = json['_title'] as String? ?? '';

Map<String, dynamic> _$ArmorToJson(Armor instance) => <String, dynamic>{
      '_title': instance._title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      'ca': instance.ca,
      'skillModifiers': instance.skillModifiers
          .map((k, e) => MapEntry(_$SkillEnumMap[k]!, e)),
      'strength': instance.strength,
      'isHeavy': instance.isHeavy,
      'isPartial': instance.isPartial,
    };

const _$SkillEnumMap = {
  Skill.forza: 'forza',
  Skill.destrezza: 'destrezza',
  Skill.costituzione: 'costituzione',
  Skill.intelligenza: 'intelligenza',
  Skill.saggezza: 'saggezza',
  Skill.carisma: 'carisma',
};

Item _$ItemFromJson(Map<String, dynamic> json) => Item.jsonConstructor(
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
    ).._title = json['_title'] as String? ?? '';

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      '_title': instance._title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
    };

Coin _$CoinFromJson(Map<String, dynamic> json) => Coin.jsonConstructor(
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      value: json['value'] as int? ?? 0,
    )
      .._title = json['_title'] as String? ?? ''
      .._currency = json['_currency'] as String? ?? '';

Map<String, dynamic> _$CoinToJson(Coin instance) => <String, dynamic>{
      '_title': instance._title,
      'description': instance.description,
      'regDateTimestamp': instance.regDateTimestamp,
      'authorUID': instance.authorUID,
      'value': instance.value,
      '_currency': instance._currency,
    };

Equipment _$EquipmentFromJson(Map<String, dynamic> json) =>
    Equipment.jsonConstructor(
      authorUID: json['authorUID'] as String?,
      regDateTimestamp: json['regDateTimestamp'] as int?,
      description: json['description'] as String?,
      content: (json['content'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
    ).._title = json['_title'] as String? ?? '';

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      '_title': instance._title,
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
