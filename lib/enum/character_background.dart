import '../annotation/localized_annotation.dart';

@Localized(['title', 'hint'])
enum CharacterBackground {
  physical('png/physical', 8),
  history('png/history', 20),
  traits('png/traits', 10),
  defects('png/defects', 5),
  ideals('png/ideals', 5),
  bonds('png/bonds', 6);

  final String iconPath;
  final int maxLength;

  const CharacterBackground(this.iconPath, this.maxLength);
}
