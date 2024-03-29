import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/enum/palette.dart';

class GradientBackground extends StatelessWidget {
  final Color topColor, bottomColor;
  const GradientBackground({super.key, required this.topColor, this.bottomColor=Palette.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.75, -1.0),
          radius: 1.35,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      ),
    );
  }
}
