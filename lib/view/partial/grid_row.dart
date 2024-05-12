import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';

class GridRow extends StatelessWidget {
  final double crossAxisSpacing, mainAxisSpacing;
  final int columnsCount;
  final List<Widget> children;
  final bool fill;

  const GridRow(
      {super.key,
      this.crossAxisSpacing = Measures.vMarginMoreThin,
      this.mainAxisSpacing = Measures.vMarginMoreThin,
      this.fill = false,
      required this.columnsCount,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(children.length ~/ columnsCount + 1, (i) {
        List<Widget> elements = [];
        final int rowSize = fill
            ? columnsCount
            : min(columnsCount, children.length - columnsCount * i);
        for (var j = 0; j < rowSize; j++) {
          elements.add(Flexible(child: (i * columnsCount + j<children.length)?children[i * columnsCount + j]:Container()));
          if (j < rowSize - 1) {
            elements.add(SizedBox(width: crossAxisSpacing));
          }
        }
        return Padding(
          padding: EdgeInsets.only(
              bottom:
                  i <= children.length ~/ columnsCount ? mainAxisSpacing : 0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: elements),
        );
      }),
    );
  }
}
