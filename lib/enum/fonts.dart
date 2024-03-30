import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class Fonts {
  static light({color,double size=18}) => GoogleFonts.lato(
      color: color ??Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.w300);

  static regular({color,double size=18}) => GoogleFonts.lato(
      color: color ??Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.normal);

  static bold({color,double size=20}) => GoogleFonts.lato(
      color: color ?? Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.bold);

  static button({color,double size=16}) => GoogleFonts.lato(
      color: color ?? Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.bold);

  static black({color,double size=28}) => GoogleFonts.lato(
      color: color ??Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.w900).copyWith(height: 1.25);
}
