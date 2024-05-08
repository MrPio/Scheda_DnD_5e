import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/model/campaign.dart';
import 'package:scheda_dnd_5e/model/character.dart';

part 'part/user.g.dart';

@JsonSerializable()
class User implements JSONSerializable, WithUID {
  final String nickname, email;
  final int regDateTimestamp;

  // Note: It is not needed to distinguish between created and joined campaigns
  List<String> campaignsUIDs, charactersUIDs;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<List<Campaign>?> campaigns = ValueNotifier(null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<List<Character>?> characters = ValueNotifier(null);

  User(
      {this.nickname = 'Anonimo',
      this.email = '',
      int? regDateTimestamp,
      List<String>? campaignsUIDs,
      List<String>? charactersUIDs})
      : regDateTimestamp =
            regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        campaignsUIDs = campaignsUIDs ?? [],
        charactersUIDs = charactersUIDs ?? [];

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  @override
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$UserToJson(this);
}
