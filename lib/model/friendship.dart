import 'package:json_annotation/json_annotation.dart';

import '../interface/json_serializable.dart';
import '../interface/with_uid.dart';

part 'part/friendship.g.dart';

/// Represents the state of a friendship relationship.
enum FriendshipState {
  pending,
  accepted,
  refused,
}

@JsonSerializable()
class Friendship implements JSONSerializable, WithUID{
  final String senderUID;
  final String receiverUID;
  FriendshipState state;
  final int createdAt;
  int updatedAt;

  Friendship({
    required this.senderUID,
    required this.receiverUID,
    this.state = FriendshipState.pending,
    int? createdAt,
    int? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  /// Updates the state of the friendship and refreshes the `updatedAt` timestamp.
  void updateState(FriendshipState newState) {
    state = newState;
    updatedAt = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @override
  factory Friendship.fromJson(Map<String, dynamic> json) => _$FriendshipFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$FriendshipToJson(this);
}
