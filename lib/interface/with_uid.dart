import 'package:scheda_dnd_5e/interface/json_serializable.dart';

abstract class WithUID implements JSONSerializable {
  late final String? uid;
}