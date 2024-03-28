import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements JSONSerializable {
  final String name;
  final String surname;
  final int regDateTimestamp;

  @JsonKey(includeFromJson: true, includeToJson: false)
  String? uid;

  User({this.name = "Anonimo", this.surname = "Anonimo", int? regDateTimestamp})
      : regDateTimestamp =
            regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch;

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$UserToJson(this);
}
