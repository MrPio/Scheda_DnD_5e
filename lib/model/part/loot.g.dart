// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../loot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loot _$LootFromJson(Map<String, dynamic> json) => Loot.jsonConstructor(
      json['_name'] as String?,
      Map<String, int>.from(json['_content'] as Map),
    );

Map<String, dynamic> _$LootToJson(Loot instance) => <String, dynamic>{
      '_name': instance._name,
      '_content': instance._content,
    };
