// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friendship _$FriendshipFromJson(Map<String, dynamic> json) => Friendship(
      senderUID: json['senderUID'] as String,
      receiverUID: json['receiverUID'] as String,
      state: $enumDecodeNullable(_$FriendshipStateEnumMap, json['state']) ??
          FriendshipState.PENDING,
      createdAt: (json['createdAt'] as num?)?.toInt(),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FriendshipToJson(Friendship instance) =>
    <String, dynamic>{
      'senderUID': instance.senderUID,
      'receiverUID': instance.receiverUID,
      'state': _$FriendshipStateEnumMap[instance.state]!,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$FriendshipStateEnumMap = {
  FriendshipState.PENDING: 'PENDING',
  FriendshipState.ACCEPTED: 'ACCEPTED',
  FriendshipState.REFUSED: 'REFUSED',
};
