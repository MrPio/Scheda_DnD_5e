import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';

@Localized(['title', 'description'])
enum CharacterAlignment implements EnumWithTitle {
  legaleBuono('LB'),
  neutraleBuono('NB'),
  caoticoBuono('CB'),
  legaleNeutrale('LN'),
  neutralePuro('NN'),
  caoticoNeutrale('CN'),
  legaleMalvagio('LM'),
  neutraleMalvagio('NM'),
  caoticoMalvagio('CM'),
  nessuno(null);

  final String? initials;

  const CharacterAlignment(this.initials);

  static const _initials = {
    'L': 'Legale',
    'N': 'Neutrale',
    'C': 'Caotico',
    'B': 'Buono',
    'M': 'Malvagio'
  };

  List<String> get fullInitials => switch (this) {
        CharacterAlignment.nessuno => ['Nessuno'],
        CharacterAlignment.neutralePuro => ['Neutrale', 'Puro'],
        _ => initials!.split('').map((e) => _initials[e]!).toList(),
      };
}
