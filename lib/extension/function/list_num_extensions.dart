import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/fonts.dart';
import 'package:scheda_dnd_5e/enum/measures.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

extension ListNumExtensions<T extends num> on List<T> {
  T sum()=>
    reduce((value, element) => value + element as T);

}
