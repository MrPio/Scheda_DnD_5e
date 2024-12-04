import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';

class GridColumn extends StatelessWidget {
  final double crossAxisSpacing, mainAxisSpacing;
  final int columnsCount;
  final List<Widget> children;

  const GridColumn(
      {super.key,
      this.crossAxisSpacing = Measures.vMarginMoreThin,
      this.mainAxisSpacing = Measures.vMarginMoreThin,
      required this.columnsCount,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnsCount, (i) {
        List<Widget> elements = [];
        final int colSize = children.length ~/ columnsCount +
            (i < children.length % columnsCount ? 1 : 0);
        for (var j = 0; j < colSize; j++) {
          elements.add(children[j * columnsCount + i]);
          if (j < colSize - 1) {
            elements.add(SizedBox(height: mainAxisSpacing));
          }
        }
        return Flexible(
          child: Padding(
            padding: EdgeInsets.only(
                right: i < columnsCount-1 ? crossAxisSpacing : 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start, children: elements),
          ),
        );
      }),
    );
  }
}
