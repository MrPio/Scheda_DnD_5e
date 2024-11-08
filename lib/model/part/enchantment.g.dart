// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../enchantment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enchantment _$EnchantmentFromJson(Map<String, dynamic> json) =>
    Enchantment.jsonConstructor(
      json['name'] as String,
      $enumDecode(_$LevelEnumMap, json['level']),
      $enumDecode(_$TypeEnumMap, json['type']),
      (json['classes'] as List<dynamic>)
          .map((e) => $enumDecode(_$ClassEnumMap, e))
          .toList(),
      $enumDecode(_$RangeEnumMap, json['range']),
      $enumDecode(_$RangeTypeEnumMap, json['rangeType']),
      json['isCharmer'] as bool,
      $enumDecode(_$LaunchTimeEnumMap, json['launchTime']),
      json['launchCondition'] as String,
      $enumDecode(_$DurationEnumMap, json['duration']),
      json['concentration'] as bool,
      (json['components'] as List<dynamic>)
          .map((e) => $enumDecode(_$ComponentEnumMap, e))
          .toList(),
      json['componentsDescription'] as String,
      $enumDecode(_$DamageEnumMap, json['damage']),
      json['description'] as String,
    );

Map<String, dynamic> _$EnchantmentToJson(Enchantment instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'level': _$LevelEnumMap[instance.level]!,
      'type': _$TypeEnumMap[instance.type]!,
      'classes': instance.classes.map((e) => _$ClassEnumMap[e]!).toList(),
      'range': _$RangeEnumMap[instance.range]!,
      'rangeType': _$RangeTypeEnumMap[instance.rangeType]!,
      'isCharmer': instance.isCharmer,
      'launchTime': _$LaunchTimeEnumMap[instance.launchTime]!,
      'launchCondition': instance.launchCondition,
      'duration': _$DurationEnumMap[instance.duration]!,
      'concentration': instance.concentration,
      'components':
          instance.components.map((e) => _$ComponentEnumMap[e]!).toList(),
      'componentsDescription': instance.componentsDescription,
      'damage': _$DamageEnumMap[instance.damage]!,
    };

const _$LevelEnumMap = {
  Level.level0: 'level0',
  Level.level1: 'level1',
  Level.level2: 'level2',
  Level.level3: 'level3',
  Level.level4: 'level4',
  Level.level5: 'level5',
  Level.level6: 'level6',
  Level.level7: 'level7',
  Level.level8: 'level8',
  Level.level9: 'level9',
};

const _$TypeEnumMap = {
  Type.evocazione: 'evocazione',
  Type.divinazione: 'divinazione',
  Type.invocazione: 'invocazione',
  Type.trasmutazione: 'trasmutazione',
  Type.ammaliamento: 'ammaliamento',
  Type.illusione: 'illusione',
  Type.abiurazione: 'abiurazione',
  Type.necromanzia: 'necromanzia',
};

const _$ClassEnumMap = {
  Class.barbaro: 'barbaro',
  Class.bardo: 'bardo',
  Class.chierico: 'chierico',
  Class.druido: 'druido',
  Class.guerriero: 'guerriero',
  Class.ladro: 'ladro',
  Class.mago: 'mago',
  Class.monaco: 'monaco',
  Class.paladino: 'paladino',
  Class.ranger: 'ranger',
  Class.stregone: 'stregone',
  Class.warlock: 'warlock',
};

const _$RangeEnumMap = {
  Range.metri1_5: 'metri1_5',
  Range.metri3: 'metri3',
  Range.metri4_5: 'metri4_5',
  Range.metri9: 'metri9',
  Range.metri18: 'metri18',
  Range.metri27: 'metri27',
  Range.metri30: 'metri30',
  Range.metri36: 'metri36',
  Range.metri45: 'metri45',
  Range.metri90: 'metri90',
  Range.metri150: 'metri150',
  Range.km7_5: 'km7_5',
  Range.km750: 'km750',
  Range.personale: 'personale',
  Range.vista: 'vista',
  Range.contatto: 'contatto',
  Range.illimitata: 'illimitata',
  Range.speciale: 'speciale',
};

const _$RangeTypeEnumMap = {
  RangeType.punto: 'punto',
  RangeType.raggio: 'raggio',
  RangeType.semisfera: 'semisfera',
  RangeType.linea: 'linea',
  RangeType.cono: 'cono',
  RangeType.cubo: 'cubo',
};

const _$LaunchTimeEnumMap = {
  LaunchTime.reazione: 'reazione',
  LaunchTime.azione: 'azione',
  LaunchTime.azioneBonus: 'azioneBonus',
  LaunchTime.azioneO8Ore: 'azioneO8Ore',
  LaunchTime.minuto1: 'minuto1',
  LaunchTime.minuti10: 'minuti10',
  LaunchTime.ora1: 'ora1',
  LaunchTime.ore8: 'ore8',
  LaunchTime.ore12: 'ore12',
  LaunchTime.ore24: 'ore24',
};

const _$DurationEnumMap = {
  Duration.round1: 'round1',
  Duration.finoA1Minuto: 'finoA1Minuto',
  Duration.minuto1: 'minuto1',
  Duration.minuti10: 'minuti10',
  Duration.ora1: 'ora1',
  Duration.finoA1Ora: 'finoA1Ora',
  Duration.finoA8Ore: 'finoA8Ore',
  Duration.ore8: 'ore8',
  Duration.ore24: 'ore24',
  Duration.giorno1: 'giorno1',
  Duration.giorni7: 'giorni7',
  Duration.giorni10: 'giorni10',
  Duration.giorni30: 'giorni30',
  Duration.finoA1Round: 'finoA1Round',
  Duration.finoA6Round: 'finoA6Round',
  Duration.finoA10Minuti: 'finoA10Minuti',
  Duration.finoA2Ore: 'finoA2Ore',
  Duration.finoA1Giorno: 'finoA1Giorno',
  Duration.istantanea: 'istantanea',
  Duration.fincheNonVieneDissolto: 'fincheNonVieneDissolto',
  Duration.fincheNonVieneDissoltoOInnescato: 'fincheNonVieneDissoltoOInnescato',
  Duration.speciale: 'speciale',
};

const _$ComponentEnumMap = {
  Component.v: 'v',
  Component.s: 's',
  Component.m: 'm',
};

const _$DamageEnumMap = {
  Damage.attacco: 'attacco',
  Damage.tiroSalvezza: 'tiroSalvezza',
  Damage.descrittivo: 'descrittivo',
};
