import 'package:scheda_dnd_5e/enum/relationship.dart';
import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/npc.g.dart';

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
        name = name ?? 'Anonimo',
        description = description ?? '';

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory Npc.fromJson(Map<String, dynamic> json) => _$NpcFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$NpcToJson(this);
}
