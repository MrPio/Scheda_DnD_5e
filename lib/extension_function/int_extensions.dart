import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';

extension IntExtensions on int {
  String toModifierString() => '${this < 0 ? ' ' : '+'}$this ';

  String toSignString() => this < 0 ? '-' : '+';

  Duration elapsedTime() =>
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this));
}
