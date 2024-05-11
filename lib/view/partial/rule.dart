import 'package:flutter/material.dart';

import '../../enum/palette.dart';

class Rule extends StatelessWidget {
  const Rule({super.key});

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      height: 0.4,
      color: Palette.card,
    );
}
