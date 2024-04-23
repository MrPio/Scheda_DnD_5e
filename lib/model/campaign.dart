import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'part/campaign.g.dart';

@JsonSerializable()
class Campaign implements JSONSerializable, WithUID {
  final String? name;
  final String? authorUID;
  final String? password;
  final int regDateTimestamp;

// Note: It is not needed to distinguish between created and joined campaigns
  final List<String> npcsUIDs, sessionsUIDs, charactersUIDs;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  Campaign(
      {this.name,
      this.authorUID,
      this.password,
      npcsUIDs,
      sessionsUIDs,
      charactersUIDs})
      : regDateTimestamp = DateTime.now().millisecondsSinceEpoch,
        npcsUIDs = npcsUIDs ?? [],
        sessionsUIDs = sessionsUIDs ?? [],
        charactersUIDs = charactersUIDs ?? [];

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  @override
  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CampaignToJson(this);
}
