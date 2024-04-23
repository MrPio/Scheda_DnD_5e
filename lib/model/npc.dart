import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/npc.g.dart';

enum Relationship {
  alleato('Alleato'),
  amico('Amico'),
  animale('Animale'),
  base('Base'),
  boss('Boss'),
  divinita('Divinità'),
  famiglia('Famiglia'),
  locandiere('Locandiere'),
  maestro('Maestro'),
  mostriciattolo('Mostriciattolo'),
  nemesi('Nemesi'),
  nemico('Nemico'),
  patrono('Patrono');

  final String title;

  const Relationship(this.title);
}

@JsonSerializable()
class Npc implements JSONSerializable, WithUID {
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
  @override
  factory Npc.fromJson(Map<String, dynamic> json) => _$NpcFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$NpcToJson(this);
}
