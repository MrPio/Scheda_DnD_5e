import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/mixin/comparable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../enum/class.dart';
import '../interface/enum_with_title.dart';
import 'character.dart';

part 'part/enchantment.g.dart';

enum Level  {
  level0('Trucchetto'),
  level1('Livello 1'),
  level2('Livello 2'),
  level3('Livello 3'),
  level4('Livello 4'),
  level5('Livello 5'),
  level6('Livello 6'),
  level7('Livello 7'),
  level8('Livello 8'),
  level9('Livello 9');

  final String title;

  int get num => int.parse(name.split('level')[1]);

  const Level(this.title);
}

enum Type  {
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
  km8('8 km dall\'incantatore'),
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
  punto(''),
  raggio('raggio di'),
  semisfera('semisfera del raggio di'),
  linea('linea di'),
  cono('cono di'),
  cubo('cubo con spigolo di');

  final String title;

  const RangeType(this.title);
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
  v('Verbale'),
  s('Somatica'),
  m('Materiale');

  final String title;

  const Component(this.title);
}

enum Damage { attacco, tiroSalvezza, descrittivo }

@JsonSerializable(constructor: 'jsonConstructor')
class Enchantment with Comparable<Enchantment> implements WithUID {
  final String name, description;
  final Level level;
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

  final Damage damage; // TODO: rename to "category"

  Enchantment.jsonConstructor(
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
    this.damage,
    this.description,
  );

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
    this.damage,
    this.description,
  ) : uid = name;

  @override
  factory Enchantment.fromJson(Map<String, dynamic> json) => _$EnchantmentFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$EnchantmentToJson(this);

  @override
  // Compare first by level than by name
  int compareTo(Enchantment other) => level.num.compareTo(other.level.num) == 0
      ? name.compareTo(other.name)
      : level.num.compareTo(other.level.num);

  String get launchTimeStr => launchTime.title + (launchCondition.isNotEmpty ? '($launchCondition)' : '');

  String get rangeStr => '${rangeType.title} ${range.title}${isCharmer ? ' (Incantatore)' : ''}';

  String get componentsStr =>
      components.map((e) => e.title).join(', ') +
      (componentsDescription.isNotEmpty ? ' ($componentsDescription)' : '');

  String get durationStr => (concentration ? 'concentrazione, ' : '') + duration.title;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;
}
