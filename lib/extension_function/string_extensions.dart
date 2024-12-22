import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';
import 'package:scheda_dnd_5e/enum/localization.dart';

import '../constant/strings.dart';
import '../model/setting.dart';

extension StringExtensions on String {
  bool match(String other, {bool contains = false}) =>
      contains ? simplify.contains(other.simplify) : simplify == other.simplify;

  String get simplify => toLowerCase().trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

  bool get isEmail => RegExp(r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$').hasMatch(this);

  /// 'home' ==> 'assets/images/icons/home.svg'
  /// 'png/home' ==> 'assets/images/icons/png/home.png'
  Widget toIcon(
      {double? height = 24,
      double? width,
      Function()? onTap,
      padding = const EdgeInsets.all(8.0),
      margin = EdgeInsets.zero,
      color = Palette.onBackground,
      double rotation = 0}) {
    var icon = contains('png')
        ? Image.asset('assets/images/icons/$this.png', height: height, width: width, color: color)
        : SvgPicture.asset('assets/images/icons/$this.svg', height: height, width: width, color: color);
    if (onTap == null) {
      return Padding(
        padding: margin,
        child: Transform.rotate(angle: rotation, child: icon),
      );
    } else {
      return Padding(
        padding: margin,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Transform.rotate(angle: rotation, child: icon),
          ),
        ),
      );
    }
  }

  /// Translates a string starting with '%'.
  /// Assumes that every string starting with '%' has at least the italian version in the [strings] map in the Strings class.
  String translate(Localization? loc) => startsWith('%')
      ? Strings.strings[replaceFirst('%', '')]![loc ?? Setting.language.value] ??
          Strings.strings[replaceFirst('%', '')]![Localization.itIT]!
      : this;
}
