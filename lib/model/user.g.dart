// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

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
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'email': instance.email,
      'regDateTimestamp': instance.regDateTimestamp,
      'charactersUIDs': instance.charactersUIDs,
      'deletedCharactersUIDs': instance.deletedCharactersUIDs,
      'campaignsUIDs': instance.campaignsUIDs,
    };
