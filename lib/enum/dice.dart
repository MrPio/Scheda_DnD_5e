import 'dart:math';

enum Dice {
  d4(yTextAlignment: 0.2),
  d6,
  d8,
  d10,
  d12,
  d20(yTextAlignment: 0.25),
  d100;

  final double yTextAlignment;

  const Dice({this.yTextAlignment = 0});

  String get title => name.toUpperCase();

  String get svgPath => 'assets/images/dice/$name.svg';

  int get size => int.parse(title.substring(1));

  int get roll => Random().nextInt(size) + 1;
}
