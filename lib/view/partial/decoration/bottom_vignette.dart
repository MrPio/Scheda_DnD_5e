import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constant/palette.dart';

class BottomVignette extends StatelessWidget {
  final double height,spread;

  const BottomVignette({this.height = 30,this.spread=70, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment:  Alignment.bottomCenter,
            children: [
              IgnorePointer(
                child: Image.asset('assets/images/linear_vignette.png',
                    color: Palette.background,
                    fit: BoxFit.fill,
                    height: spread,
                    width: double.infinity),
              ),
              AbsorbPointer(child: Container(height:spread*.5))
            ],
          ),
          Container(
              height: height,
              width: double.infinity,
              color: Palette.background),
        ],
      ),
    );
  }
}
