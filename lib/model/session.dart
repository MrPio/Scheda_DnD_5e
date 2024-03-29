import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/session.g.dart';

@JsonSerializable()
class Session implements JSONSerializable, Identifiable {
  final int regDateTimestamp;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  Session()
      : regDateTimestamp = DateTime.now().millisecondsSinceEpoch;

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$SessionToJson(this);
}
