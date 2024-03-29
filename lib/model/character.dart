import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/character.g.dart';

@JsonSerializable()
class Character implements JSONSerializable, Identifiable {
  final int regDateTimestamp;


  Character(this.regDateTimestamp);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CharacterToJson(this);
}
