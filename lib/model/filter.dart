import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';

/// Filters a collection of objects of K class with the values of an Enum V
class Filter<K, V extends Enum> {
  final String title;
  final Color color;
  final List<V> values;
  final bool Function(K, List<V>) filterCondition;
  final List<V> selectedValues = [];

  Filter(this.title, this.color, this.values, this.filterCondition);

  bool checkFilter(K enchantment) =>
      selectedValues.isEmpty || filterCondition(enchantment, selectedValues);
}