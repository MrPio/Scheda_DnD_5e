// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickname: json['nickname'] as String? ?? 'Anonimo',
      email: json['email'] as String? ?? '',
      regDateTimestamp: json['regDateTimestamp'] as int?,
      charactersUIDs: (json['charactersUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      deletedCharactersUIDs: (json['deletedCharactersUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      campaignsUIDs: (json['campaignsUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      weaponsUIDs: (json['weaponsUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      armorsUIDs: (json['armorsUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      itemsUIDs: (json['itemsUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      coinsUIDs: (json['coinsUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'email': instance.email,
      'regDateTimestamp': instance.regDateTimestamp,
      'weaponsUIDs': instance.weaponsUIDs,
      'armorsUIDs': instance.armorsUIDs,
      'itemsUIDs': instance.itemsUIDs,
      'coinsUIDs': instance.coinsUIDs,
      'charactersUIDs': instance.charactersUIDs,
      'deletedCharactersUIDs': instance.deletedCharactersUIDs,
      'campaignsUIDs': instance.campaignsUIDs,
    };
