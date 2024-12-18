import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/extension_function/iterable_extensions.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/model/campaign.dart';
import 'package:scheda_dnd_5e/model/character.dart';

import '../constant/palette.dart';
import 'loot.dart';

part 'part/user.g.dart';

@JsonSerializable()
class User implements WithUID {
  final String email;
  String _username;
  String? picture;
  int pictureColor;
  final int regDateTimestamp;

  /// The items created by the user
  List<String> weaponsUIDs = [], armorsUIDs = [], itemsUIDs = [], coinsUIDs = [];

  // Note: There's no need to distinguish between created and joined campaigns
  List<String> charactersUIDs, deletedCharactersUIDs, campaignsUIDs;

  Map<Type, List<String>> get inventoryItems => {
        Weapon: weaponsUIDs,
        Armor: armorsUIDs,
        Item: itemsUIDs,
        Coin: coinsUIDs,
      };

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<List<Character>?> characters = ValueNotifier(null),
      deletedCharacters = ValueNotifier(null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<List<Campaign>?> campaigns = ValueNotifier(null);

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  User({
    username = 'Anonimo',
    this.picture,
    this.email = '',
    int? pictureColor,
    int? regDateTimestamp,
    List<String>? charactersUIDs,
    List<String>? deletedCharactersUIDs,
    List<String>? campaignsUIDs,
    List<String>? weaponsUIDs,
    List<String>? armorsUIDs,
    List<String>? itemsUIDs,
    List<String>? coinsUIDs,
  })  : _username = username,
        regDateTimestamp = regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        charactersUIDs = charactersUIDs ?? [],
        deletedCharactersUIDs = deletedCharactersUIDs ?? [],
        campaignsUIDs = campaignsUIDs ?? [],
        weaponsUIDs = weaponsUIDs ?? [],
        armorsUIDs = armorsUIDs ?? [],
        itemsUIDs = itemsUIDs ?? [],
        coinsUIDs = coinsUIDs ?? [],
        pictureColor = pictureColor ??
            [
              Palette.background,
              Palette.backgroundGreen,
              Palette.backgroundMagenta,
              Palette.backgroundGrey,
              Palette.backgroundPurple,
              Palette.backgroundBlue,
              Palette.primaryGreen,
              Palette.primaryRed,
              Palette.primaryBlue,
              Palette.primaryYellow,
            ].random.value;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get username => _username;

  set username(String value) {
    if (value.length < 5) {
      throw const FormatException('Il nome utente deve avere almeno 5 caratteri');
    }
    if(value==_username){
      throw const FormatException('Il nome utente è uguale a quello già in uso');
    }
    _username = value;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get inventoryItemsUIDs => weaponsUIDs + armorsUIDs + itemsUIDs + coinsUIDs;

  @override
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$UserToJson(this);

  /// Move a character from characters list to deletedCharacters list
  deleteCharacter(String uid) {
    deletedCharactersUIDs.add(uid);
    charactersUIDs.remove(uid);
    if (characters.value != null) {
      final character = characters.value!.firstWhere((e) => e.uid == uid);
      if (deletedCharacters.value == null) {
        deletedCharacters.value = [character];
      } else {
        deletedCharacters.value!.add(character);
      }
      characters.value!.removeWhere((e) => e.uid == uid);
    }
  }

  /// Move a deleted character from deletedCharacters list to characters list
  restoreCharacter(String uid) {
    charactersUIDs.add(uid);
    deletedCharactersUIDs.remove(uid);
    if (deletedCharacters.value != null) {
      final character = deletedCharacters.value!.firstWhere((e) => e.uid == uid);
      if (characters.value == null) {
        characters.value = [character];
      } else {
        characters.value!.add(character);
      }
      deletedCharacters.value!.removeWhere((e) => e.uid == uid);
    }
  }
}
