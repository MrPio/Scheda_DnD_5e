import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';

abstract class WithUID implements JSONSerializable {

  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;
}