import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'character.dart';

part 'enchantment.g.dart';

enum Type {
  evocation('evocazione'),
  divination('divinazione'),
  invocation('invocazione'),
  transmutation('trasmutazione'),
  bewitchment('ammaliamento'),
  illusion('illusione'),
  abjuration('abiurazione'),
  necromancy('necromanzia');

  final String title;

  const Type(this.title);
}

@JsonSerializable()
class Enchantment implements JSONSerializable, Identifiable {
  final String name, description;
  final int level;
  final Type type;
  final List<Class> classes;

  // Tempo di lancio
  // Gittata
  // Componenti + info str
  // Durata

  Enchantment();

  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  factory Enchantment.fromJson(Map<String, dynamic> json) =>
      _$EnchantmentFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$EnchantmentToJson(this);
}
