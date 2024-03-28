import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/model/campaign.dart';
import 'package:scheda_dnd_5e/model/character.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements JSONSerializable, Identifiable {
  final String name;
  final String surname;
  final int regDateTimestamp;

  // Note: It is not needed to distinguish between created and joined campaigns
  final List<String> campaignsUIDs, charactersUIDs;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Campaign> campaigns = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Character> characters = [];

  User(
      {this.name = "Anonimo",
      this.surname = "Anonimo",
      int? regDateTimestamp,
      List<String>? campaignsUIDs,
      List<String>? charactersUIDs})
      : regDateTimestamp =
            regDateTimestamp ?? DateTime.now().millisecondsSinceEpoch,
        campaignsUIDs = campaignsUIDs ?? [],
        charactersUIDs = charactersUIDs ?? [];

  get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$UserToJson(this);
}
