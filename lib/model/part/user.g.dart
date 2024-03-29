// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String? ?? "Anonimo",
      surname: json['surname'] as String? ?? "Anonimo",
      regDateTimestamp: json['regDateTimestamp'] as int?,
      campaignsUIDs: (json['campaignsUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      charactersUIDs: (json['charactersUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'regDateTimestamp': instance.regDateTimestamp,
      'campaignsUIDs': instance.campaignsUIDs,
      'charactersUIDs': instance.charactersUIDs,
    };
