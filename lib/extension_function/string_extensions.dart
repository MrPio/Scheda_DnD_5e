import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  bool get isUsername =>
      length >= 3 && RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(this);

  /// 'home' ==> 'assets/images/icons/home.svg'
  /// 'png/home' ==> 'assets/images/icons/png/home.png'
  Widget toIcon(
      {double height = 22, Function()? onTap, padding = const EdgeInsets.all(12.0)}) {
    var icon = contains('png')
        ? Image.asset('assets/images/icons/$this.png', height: height)
        : SvgPicture.asset('assets/images/icons/$this.svg', height: height);
    if (onTap == null) {
      return icon;
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          splashColor: Palette.onBackground.withOpacity(0.5),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: icon,
          ),
        ),
      );
    }
  }
}
