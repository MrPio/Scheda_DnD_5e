import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/npc.g.dart';

enum Relationship {
  ally('Alleato'),
  friend('Amico'),
  animal('Animale'),
  basic('Base'),
  boss('Boss'),
  divinity('Divinità'),
  family('Famiglia'),
  innkeeper('Locandiere'),
  master('Maestro'),
  monster('Mostriciattolo'),
  nemesis('Nemesi'),
  enemy('Nemico'),
  patron('Patrono');

  final String title;

  const Relationship(this.title);
}

@JsonSerializable()
class Npc implements JSONSerializable, Identifiable {
  final int regDateTimestamp;
  final String name, description;
  final Relationship? relationship;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  Npc({name, description, this.relationship})
      : regDateTimestamp = DateTime.now().millisecondsSinceEpoch,
        name = name ?? 'Anonymous',
        description = description ?? '';

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory Npc.fromJson(Map<String, dynamic> json) => _$NpcFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$NpcToJson(this);
}
