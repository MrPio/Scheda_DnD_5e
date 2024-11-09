import 'dart:core' as core show Type;
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';

import '../model/campaign.dart';
import '../model/character.dart';
import '../model/enchantment.dart';
import '../model/loot.dart';
import '../model/npc.dart';
import '../model/session.dart';
import '../model/user.dart';

abstract class WithUID implements JSONSerializable {
  static List<core.Type> implementations = [
    Enchantment,
    User,
    Character,
    Npc,
    Session,
    Campaign,
    Weapon,
    Armor,
    Item,
    Coin,
    Equipment,
  ];
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;
}
