import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/model/campaign.dart';
import 'package:scheda_dnd_5e/model/character.dart';

part 'part/user.g.dart';

@JsonSerializable()
class User implements  WithUID {
  final String nickname, email;
  final int regDateTimestamp;

  // Note: It is not needed to distinguish between created and joined campaigns
  List<String> charactersUIDs, deletedCharactersUIDs, campaignsUIDs;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<List<Character>?> characters = ValueNotifier(null),
      deletedCharacters = ValueNotifier(null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<List<Campaign>?> campaigns = ValueNotifier(null);

  User({
    this.nickname = 'Anonimo',
    this.email = '',
    int? regDateTimestamp,
    List<String>? charactersUIDs,
    List<String>? deletedCharactersUIDs,
    List<String>? campaignsUIDs,
  })  : regDateTimestamp =
            regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        charactersUIDs = charactersUIDs ?? [],
        deletedCharactersUIDs = deletedCharactersUIDs ?? [],
        campaignsUIDs = campaignsUIDs ?? [];

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  @override
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$UserToJson(this);

  // Move a character from characters list to deletedCharacters list
  deleteCharacter(String uid) {
    deletedCharactersUIDs.add(uid);
    charactersUIDs.remove(uid);
    if (characters.value != null) {
      final character = characters.value!.firstWhere((e) => e.uid == uid);
      if (deletedCharacters.value == null) {
        deletedCharacters.value=[character];
      } else {
        deletedCharacters.value!.add(character);
      }
      characters.value!.removeWhere((e) => e.uid == uid);
    }
  }
  // Move a deleted character from deletedCharacters list to characters list
  restoreCharacter(String uid) {
    charactersUIDs.add(uid);
    deletedCharactersUIDs.remove(uid);
    if (deletedCharacters.value != null) {
      final character = deletedCharacters.value!.firstWhere((e) => e.uid == uid);
      if (characters.value == null) {
        characters.value=[character];
      } else {
        characters.value!.add(character);
      }
      deletedCharacters.value!.removeWhere((e) => e.uid == uid);
    }
  }

}
