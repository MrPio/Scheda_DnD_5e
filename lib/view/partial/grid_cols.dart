import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/measures.dart';

class GridCols extends StatelessWidget {
  final double crossAxisSpacing, mainAxisSpacing;
  final int crossAxisCount;
  final List<Widget> children;

  const GridCols(
      {super.key,
      this.crossAxisSpacing = Measures.vMarginMoreThin,
      this.mainAxisSpacing = Measures.vMarginMoreThin,
      required this.crossAxisCount,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(children.length ~/ crossAxisCount + 1, (i) {
        List<Widget> elements = [];
        for (var j = 0;
            j < min(crossAxisCount, children.length - crossAxisCount * i);
            j++) {
          elements.add(Flexible(child: children[i * crossAxisCount + j]));
          if (j <
              min(crossAxisCount, children.length - crossAxisCount * i) - 1) {
            elements.add(SizedBox(width: crossAxisSpacing));
          }
        }
        return Padding(
          padding: EdgeInsets.only(
              bottom:
                  i <= children.length ~/ crossAxisCount ? mainAxisSpacing : 0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: elements),
        );
      }),
    );
  }
}
