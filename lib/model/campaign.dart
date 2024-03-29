import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/campaign.g.dart';

@JsonSerializable()
class Campaign implements JSONSerializable, Identifiable {
  final String? name;
  final String? authorUID;
  final String? password;
  final int regDateTimestamp;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  Campaign({this.name, this.authorUID, this.password})
      : regDateTimestamp = DateTime.now().millisecondsSinceEpoch;

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CampaignToJson(this);
}
