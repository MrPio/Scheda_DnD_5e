// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      json['regDateTimestamp'] as int,
      json['campaignUID'] as String?,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'regDateTimestamp': instance.regDateTimestamp,
      'campaignUID': instance.campaignUID,
    };
