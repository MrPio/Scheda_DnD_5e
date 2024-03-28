// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Campaign _$CampaignFromJson(Map<String, dynamic> json) => Campaign(
      name: json['name'] as String?,
      authorUID: json['authorUID'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$CampaignToJson(Campaign instance) => <String, dynamic>{
      'name': instance.name,
      'authorUID': instance.authorUID,
      'password': instance.password,
    };
