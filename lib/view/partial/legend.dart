import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/constant/fonts.dart';

import '../../constant/measures.dart';

class Legend extends StatelessWidget {
  final Map<String, Color> items;

  const Legend({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.entries
              .map((entry) => Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: entry.value),
                      ),
                      const SizedBox(width: Measures.hMarginSmall),
                      Text(entry.key, style: Fonts.light(size: 15)),
                      const SizedBox(width: Measures.hMarginBig),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
