import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'character.dart';

part 'part/enchantment.g.dart';

enum Type {
  evocazione('Evocazione'),
  divinazione('Divinazione'),
  invocazione('Invocazione'),
  trasmutazione('Trasmutazione'),
  ammaliamento('Ammaliamento'),
  illusione('Illusione'),
  abiurazione('Abiurazione'),
  necromanzia('Necromanzia');

  final String title;

  const Type(this.title);
}

enum Range {
  metri1_5('1,5 metri'),
  metri3('3 metri'),
  metri4_5('4,5 metri'),
  metri9('9 metri'),
  metri18('18 metri'),
  metri27('27 metri'),
  metri30('30 metri'),
  metri36('36 metri'),
  metri45('45 metri'),
  metri90('90 metri'),
  metri150('150 Metri'),
  km7_5('7,5 km'),
  km750('750 km'),
  personale('personale'),
  vista('vista'),
  contatto('contatto'),
  illimitata('illimitata'),
  speciale('speciale');

  final String title;

  const Range(this.title);
}

enum RangeType {
  punto,
  raggio,
  semisfera,
  linea,
  cono,
  cubo;
}

enum LaunchTime {
  reazione('1 reazione'),
  azione('1 azione'),
  azioneBonus('1 azione bonus'),
  azioneO8Ore('1 azione o 8 ore'),
  minuto1('1 minuto'),
  minuti10('10 minuti'),
  ora1('1 ora'),
  ore8('8 ore'),
  ore12('12 ore'),
  ore24('24 ore');

  final String title;

  const LaunchTime(this.title);
}

enum Duration {
  round1('1 round'),
  finoA1Minuto('fino a 1 minuto'),
  minuto1('1 minuto'),
  minuti10('10 minuti'),
  ora1('1 ora'),
  finoA1Ora('fino a 1 ora'),
  finoA8Ore('fino a 8 ore'),
  ore8('8 ore'),
  ore24('24 ore'),
  giorno1('1 giorno'),
  giorni7('7 giorni'),
  giorni10('10 giorni'),
  giorni30('30 giorni'),
  finoA1Round('fino a 1 round'),
  finoA6Round('fino a 6 round'),
  finoA10Minuti('fino a 10 minuti'),
  finoA2Ore('fino a 2 ore'),
  finoA1Giorno('fino a 1 giorno'),
  istantanea('istantanea'),
  fincheNonVieneDissolto('finché non viene dissolto'),
  fincheNonVieneDissoltoOInnescato('finché non viene dissolto o innescato'),
  speciale('speciale');

  final String title;

  const Duration(this.title);
}

enum Component {
  v('verbale'),
  s('somatica'),
  m('materiale');

  final String title;

  const Component(this.title);
}

@JsonSerializable()
class Enchantment implements JSONSerializable {
  final String name, description;
  final int level;
  final Type type;
  final List<Class> classes;

  // Range
  final Range range;
  final RangeType rangeType;
  final bool isCharmer;

  // LaunchTime
  final LaunchTime launchTime;
  final String launchCondition;

  // Duration
  final Duration duration;
  final bool concentration;

  // Components
  final List<Component> components;
  final String componentsDescription;


  Enchantment(
      this.name,
      this.level,
      this.type,
      this.classes,
      this.range,
      this.rangeType,
      this.isCharmer,
      this.launchTime,
      this.launchCondition,
      this.duration,
      this.concentration,
      this.components,
      this.componentsDescription,
      this.description,
      );

  @override
  factory Enchantment.fromJson(Map<String, dynamic> json) =>
      _$EnchantmentFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$EnchantmentToJson(this);
}
