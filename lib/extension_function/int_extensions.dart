import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

extension IntExtensions on int {
  String toModifierString() => '${this < 0 ? ' ' : '+'}$this ';

  String toSignString() => this < 0 ? '-' : '+';

  Duration elapsedTime() =>
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this));
}
