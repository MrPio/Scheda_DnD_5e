import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

extension StringExtensions on String {
  bool match(String other) => toLowerCase()
      .trim()
      .replaceAll(' ', '')
      .contains(other.toLowerCase().trim());

  bool get isEmail =>
      RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$').hasMatch(this);
}
