import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheda_dnd_5e/constant/palette.dart';

class Fonts {
  static light({color,double size=14}) => GoogleFonts.lato(
      color: color ??Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.w300);

  static regular({color,double size=16}) => GoogleFonts.lato(
      color: color ??Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.normal);

  static bold({color,double size=16}) => GoogleFonts.lato(
      color: color ?? Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.bold);

  static button({color,double size=16}) => GoogleFonts.lato(
      color: color ?? Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.bold);

  static buttonOutlined({color,double size=16}) => GoogleFonts.lato(
      color: color ?? Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.normal);

  static black({color,double size=24}) => GoogleFonts.lato(
      color: color ??Palette.onBackground,
      fontSize: size,
      fontWeight: FontWeight.w900).copyWith(height: 1.25);
}
