

extension IntExtensions on int {
  String toModifierString() => '${this < 0 ? ' ' : '+'}$this ';

  String toSignString() => this == 0?'':this < 0 ? '-' : '+';
  String toSignedString() => '${toSignString()} ${abs()}';



  Duration elapsedTime() =>
      DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this));
}
