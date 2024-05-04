import 'package:flutter/material.dart';

import '../../enum/palette.dart';

class BottomVignette extends StatelessWidget {
  final double height,spread;

  const BottomVignette({this.height = 30,this.spread=70, super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/linear_vignette.png',
                color: Palette.background,
                fit: BoxFit.fill,
                height: spread,
                width: double.infinity),
            Container(
                height: height,
                width: double.infinity,
                color: Palette.background),
          ],
        ),
      ),
    );
  }
}
