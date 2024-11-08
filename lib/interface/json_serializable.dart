import 'package:scheda_dnd_5e/model/campaign.dart';
import 'package:scheda_dnd_5e/model/character.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart' as enchantment;
import 'package:scheda_dnd_5e/model/user.dart' as user;
import 'package:scheda_dnd_5e/model/npc.dart';
import 'package:scheda_dnd_5e/model/session.dart';

import '../model/loot.dart';

abstract class JSONSerializable {
  static Map<Type, Function> modelFactories = {
    enchantment.Enchantment: enchantment.Enchantment.fromJson,
    user.User: user.User.fromJson,
    Character: Character.fromJson,
    Npc: Npc.fromJson,
    Session: Session.fromJson,
    Campaign: Campaign.fromJson,
    Weapon: Weapon.fromJson,
    Armor: Armor.fromJson,
    Item: Item.fromJson,
    Coin: Coin.fromJson,
    Equipment: Equipment.fromJson,
  };
  factory JSONSerializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
  Map<String, dynamic> toJSON();
}
