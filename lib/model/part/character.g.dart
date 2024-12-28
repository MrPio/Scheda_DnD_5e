// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) =>
    Character.jsonConstructor(
      (json['regDateTimestamp'] as num).toInt(),
      json['campaignUID'] as String?,
      json['authorUID'] as String,
      json['_name'] as String,
      (json['_hp'] as num?)?.toInt(),
      (json['_maxHp'] as num?)?.toInt(),
      (json['weaponsUIDs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      (json['armorsUIDs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      (json['itemsUIDs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      (json['coinsUIDs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      $enumDecode(_$ClassEnumMap, json['class_']),
      $enumDecode(_$SubClassEnumMap, json['subClass']),
      $enumDecode(_$RaceEnumMap, json['race']),
      $enumDecodeNullable(_$SubRaceEnumMap, json['subRace']),
      (json['_chosenSkills'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$SkillEnumMap, k), (e as num).toInt()),
      ),
      (json['rollSkills'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$SkillEnumMap, k), (e as num).toInt()),
      ),
      (json['customSkills'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$SkillEnumMap, k), (e as num).toInt()),
      ),
      (json['subSkills'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$SubSkillEnumMap, k), (e as num).toInt()),
      ),
      (json['totalSlots'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$LevelEnumMap, k), (e as num).toInt()),
      ),
      (json['availableSlots'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$LevelEnumMap, k), (e as num).toInt()),
      ),
      (json['masteries'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MasteryEnumMap, e))
          .toSet(),
      (json['languages'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LanguageEnumMap, e))
          .toSet(),
      $enumDecodeNullable(_$StatusEnumMap, json['status']),
      $enumDecode(_$AlignmentEnumMap, json['alignment']),
      (json['level'] as num).toInt(),
      (json['armorClass'] as num).toInt(),
      (json['initiative'] as num).toInt(),
      (json['speed'] as num).toDouble(),
      json['physical'] as String?,
      json['history'] as String?,
      json['traits'] as String?,
      json['defects'] as String?,
      json['ideals'] as String?,
      json['bonds'] as String?,
      (json['enchantmentUIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'regDateTimestamp': instance.regDateTimestamp,
      'campaignUID': instance.campaignUID,
      'authorUID': instance.authorUID,
      '_name': instance._name,
      '_hp': instance._hp,
      '_maxHp': instance._maxHp,
      'class_': _$ClassEnumMap[instance.class_]!,
      'subClass': _$SubClassEnumMap[instance.subClass]!,
      'race': _$RaceEnumMap[instance.race]!,
      'subRace': _$SubRaceEnumMap[instance.subRace],
      '_chosenSkills':
          instance._chosenSkills.map((k, e) => MapEntry(_$SkillEnumMap[k]!, e)),
      'rollSkills':
          instance.rollSkills.map((k, e) => MapEntry(_$SkillEnumMap[k]!, e)),
      'customSkills':
          instance.customSkills.map((k, e) => MapEntry(_$SkillEnumMap[k]!, e)),
      'subSkills':
          instance.subSkills.map((k, e) => MapEntry(_$SubSkillEnumMap[k]!, e)),
      'totalSlots':
          instance.totalSlots.map((k, e) => MapEntry(_$LevelEnumMap[k]!, e)),
      'availableSlots': instance.availableSlots
          .map((k, e) => MapEntry(_$LevelEnumMap[k]!, e)),
      'masteries': instance.masteries.map((e) => _$MasteryEnumMap[e]!).toList(),
      'languages':
          instance.languages.map((e) => _$LanguageEnumMap[e]!).toList(),
      'enchantmentUIDs': instance.enchantmentUIDs.toList(),
      'status': _$StatusEnumMap[instance.status],
      'alignment': _$AlignmentEnumMap[instance.alignment]!,
      'level': instance.level,
      'armorClass': instance.armorClass,
      'initiative': instance.initiative,
      'weaponsUIDs': instance.weaponsUIDs,
      'armorsUIDs': instance.armorsUIDs,
      'itemsUIDs': instance.itemsUIDs,
      'coinsUIDs': instance.coinsUIDs,
      'speed': instance.speed,
      'physical': instance.physical,
      'history': instance.history,
      'traits': instance.traits,
      'defects': instance.defects,
      'ideals': instance.ideals,
      'bonds': instance.bonds,
      'skills': instance.skills.map((k, e) => MapEntry(_$SkillEnumMap[k]!, e)),
      'skillsModifier': instance.skillsModifier
          .map((k, e) => MapEntry(_$SkillEnumMap[k]!, e)),
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

const _$SubClassEnumMap = {
  SubClass.collegioSapienza: 'collegioSapienza',
  SubClass.collegioValore: 'collegioValore',
  SubClass.campione: 'campione',
  SubClass.cavaliereMistico: 'cavaliereMistico',
  SubClass.maestroDiBattaglia: 'maestroDiBattaglia',
  SubClass.assassino: 'assassino',
  SubClass.furfante: 'furfante',
  SubClass.mistificatoreArcano: 'mistificatoreArcano',
  SubClass.abiurazione: 'abiurazione',
  SubClass.ammaliamento: 'ammaliamento',
  SubClass.divinazione: 'divinazione',
  SubClass.evocazione: 'evocazione',
  SubClass.illusione: 'illusione',
  SubClass.invocazione: 'invocazione',
  SubClass.necromanzia: 'necromanzia',
  SubClass.trasmutazione: 'trasmutazione',
  SubClass.camminoDelBerserker: 'camminoDelBerserker',
  SubClass.camminoDelCombattenteTotemico: 'camminoDelCombattenteTotemico',
  SubClass.dominioDellaConoscenza: 'dominioDellaConoscenza',
  SubClass.dominioDellaGuerra: 'dominioDellaGuerra',
  SubClass.dominioDellaLuce: 'dominioDellaLuce',
  SubClass.dominioDellaNatura: 'dominioDellaNatura',
  SubClass.dominioDellaTempesta: 'dominioDellaTempesta',
  SubClass.dominioDellaVita: 'dominioDellaVita',
  SubClass.dominioDellInganno: 'dominioDellInganno',
  SubClass.circoloDellaLuna: 'circoloDellaLuna',
  SubClass.circoloDellaTerra: 'circoloDellaTerra',
  SubClass.viaDeiQuattroElementi: 'viaDeiQuattroElementi',
  SubClass.viaDellaManoAperta: 'viaDellaManoAperta',
  SubClass.viaDellOmbra: 'viaDellOmbra',
  SubClass.giuramentoDegliAntichi: 'giuramentoDegliAntichi',
  SubClass.giuramentoDiDevozione: 'giuramentoDiDevozione',
  SubClass.giuramentoDellaVendetta: 'giuramentoDellaVendetta',
  SubClass.cacciatore: 'cacciatore',
  SubClass.signoreDelleBestie: 'signoreDelleBestie',
  SubClass.discendenzaDraconica: 'discendenzaDraconica',
  SubClass.magiaSelvaggia: 'magiaSelvaggia',
  SubClass.ilGrandeAntico: 'ilGrandeAntico',
  SubClass.ilSignoreFatato: 'ilSignoreFatato',
  SubClass.lImmondo: 'lImmondo',
};

const _$RaceEnumMap = {
  Race.umano: 'umano',
  Race.nano: 'nano',
  Race.elfo: 'elfo',
  Race.dragonide: 'dragonide',
  Race.gnomo: 'gnomo',
  Race.halfling: 'halfling',
  Race.mezzelfo: 'mezzelfo',
  Race.mezzorco: 'mezzorco',
  Race.tiefling: 'tiefling',
};

const _$SubRaceEnumMap = {
  SubRace.elfoAlto: 'elfoAlto',
  SubRace.elfoDeiBoschi: 'elfoDeiBoschi',
  SubRace.elfoOscuro: 'elfoOscuro',
  SubRace.gnomoDelleForeste: 'gnomoDelleForeste',
  SubRace.gnomoDelleRocce: 'gnomoDelleRocce',
  SubRace.halflingPiedelesto: 'halflingPiedelesto',
  SubRace.halflingTozzo: 'halflingTozzo',
  SubRace.nanoDelleColline: 'nanoDelleColline',
  SubRace.nanoDelleMontagne: 'nanoDelleMontagne',
  SubRace.dragoDArgento: 'dragoDArgento',
  SubRace.dragoBianco: 'dragoBianco',
  SubRace.dragoBlu: 'dragoBlu',
  SubRace.dragoDiBronzo: 'dragoDiBronzo',
  SubRace.dragoNero: 'dragoNero',
  SubRace.dragoDOro: 'dragoDOro',
  SubRace.dragoDOttone: 'dragoDOttone',
  SubRace.dragoDiRame: 'dragoDiRame',
  SubRace.dragoRosso: 'dragoRosso',
  SubRace.dragoVerde: 'dragoVerde',
};

const _$SkillEnumMap = {
  Skill.forza: 'forza',
  Skill.destrezza: 'destrezza',
  Skill.costituzione: 'costituzione',
  Skill.intelligenza: 'intelligenza',
  Skill.saggezza: 'saggezza',
  Skill.carisma: 'carisma',
};

const _$SubSkillEnumMap = {
  SubSkill.atletica: 'atletica',
  SubSkill.acrobazia: 'acrobazia',
  SubSkill.furtivita: 'furtivita',
  SubSkill.rapiditaDiMano: 'rapiditaDiMano',
  SubSkill.arcano: 'arcano',
  SubSkill.storia: 'storia',
  SubSkill.indagare: 'indagare',
  SubSkill.natura: 'natura',
  SubSkill.religione: 'religione',
  SubSkill.addestrareAnimali: 'addestrareAnimali',
  SubSkill.intuizione: 'intuizione',
  SubSkill.medicina: 'medicina',
  SubSkill.percezione: 'percezione',
  SubSkill.sopravvivenza: 'sopravvivenza',
  SubSkill.inganno: 'inganno',
  SubSkill.intimidire: 'intimidire',
  SubSkill.intrattenere: 'intrattenere',
  SubSkill.persuasione: 'persuasione',
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

const _$MasteryEnumMap = {
  Mastery.ciaramella: 'ciaramella',
  Mastery.cornamusa: 'cornamusa',
  Mastery.corno: 'corno',
  Mastery.dulcimer: 'dulcimer',
  Mastery.flauto: 'flauto',
  Mastery.flautoDiPan: 'flautoDiPan',
  Mastery.lira: 'lira',
  Mastery.liuto: 'liuto',
  Mastery.tamburo: 'tamburo',
  Mastery.viola: 'viola',
  Mastery.scorteDaAlchimista: 'scorteDaAlchimista',
  Mastery.scorteDaCalligrafo: 'scorteDaCalligrafo',
  Mastery.scorteDaMescitore: 'scorteDaMescitore',
  Mastery.strumentiDaCalzolaio: 'strumentiDaCalzolaio',
  Mastery.strumentiDaCartografo: 'strumentiDaCartografo',
  Mastery.strumentiDaConciatore: 'strumentiDaConciatore',
  Mastery.strumentiDaFabbro: 'strumentiDaFabbro',
  Mastery.strumentiDaCostruttore: 'strumentiDaCostruttore',
  Mastery.strumentiDaFalegname: 'strumentiDaFalegname',
  Mastery.strumentiDaGioielliere: 'strumentiDaGioielliere',
  Mastery.strumentiDaIntagliatore: 'strumentiDaIntagliatore',
  Mastery.strumentiDaInventore: 'strumentiDaInventore',
  Mastery.strumentiDaPittore: 'strumentiDaPittore',
  Mastery.strumentiDaSoffiatore: 'strumentiDaSoffiatore',
  Mastery.strumentiDaTessitore: 'strumentiDaTessitore',
  Mastery.strumentiDaVasaio: 'strumentiDaVasaio',
  Mastery.utensiliDaCuoco: 'utensiliDaCuoco',
  Mastery.spadeCorte: 'spadeCorte',
  Mastery.spadeLunghe: 'spadeLunghe',
  Mastery.archiCorti: 'archiCorti',
  Mastery.archiLunghi: 'archiLunghi',
  Mastery.ascieDaBattaglia: 'ascieDaBattaglia',
  Mastery.martelliDaGuerra: 'martelliDaGuerra',
  Mastery.martelliLeggeri: 'martelliLeggeri',
  Mastery.armatureLeggere: 'armatureLeggere',
  Mastery.armatureMedie: 'armatureMedie',
  Mastery.scudi: 'scudi',
  Mastery.armiSemplici: 'armiSemplici',
  Mastery.armiDaGuerra: 'armiDaGuerra',
  Mastery.balestreAMano: 'balestreAMano',
  Mastery.balestreLeggere: 'balestreLeggere',
  Mastery.stocchi: 'stocchi',
  Mastery.arnesiDaScasso: 'arnesiDaScasso',
  Mastery.ascie: 'ascie',
  Mastery.tutteLeArmature: 'tutteLeArmature',
  Mastery.bastoniFerrati: 'bastoniFerrati',
  Mastery.dardi: 'dardi',
  Mastery.fionde: 'fionde',
  Mastery.pugnali: 'pugnali',
  Mastery.falcetti: 'falcetti',
  Mastery.giavellotti: 'giavellotti',
  Mastery.lance: 'lance',
  Mastery.mazze: 'mazze',
  Mastery.randelli: 'randelli',
  Mastery.scimitarre: 'scimitarre',
  Mastery.strumentiDaErborista: 'strumentiDaErborista',
};

const _$LanguageEnumMap = {
  Language.gigante: 'gigante',
  Language.gnomesco: 'gnomesco',
  Language.goblin: 'goblin',
  Language.halfling: 'halfling',
  Language.nanico: 'nanico',
  Language.orchesco: 'orchesco',
  Language.abissale: 'abissale',
  Language.celestiale: 'celestiale',
  Language.draconico: 'draconico',
  Language.gergoDelleProfondita: 'gergoDelleProfondita',
  Language.infernale: 'infernale',
  Language.primordiale: 'primordiale',
  Language.silvano: 'silvano',
  Language.sottocomune: 'sottocomune',
  Language.elfico: 'elfico',
  Language.comune: 'comune',
};

const _$StatusEnumMap = {
  Status.accecato: 'accecato',
  Status.affascinato: 'affascinato',
  Status.afferrato: 'afferrato',
  Status.assordato: 'assordato',
  Status.avvelenato: 'avvelenato',
  Status.incapacitato: 'incapacitato',
  Status.invisibile: 'invisibile',
  Status.paralizzato: 'paralizzato',
  Status.pietrificato: 'pietrificato',
  Status.privo: 'privo',
  Status.prono: 'prono',
  Status.spaventato: 'spaventato',
  Status.stordito: 'stordito',
  Status.trattenuto: 'trattenuto',
};

const _$AlignmentEnumMap = {
  CharacterAlignment.legaleBuono: 'legaleBuono',
  CharacterAlignment.neutraleBuono: 'neutraleBuono',
  CharacterAlignment.caoticoBuono: 'caoticoBuono',
  CharacterAlignment.legaleNeutrale: 'legaleNeutrale',
  CharacterAlignment.neutralePuro: 'neutralePuro',
  CharacterAlignment.caoticoNeutrale: 'caoticoNeutrale',
  CharacterAlignment.legaleMalvagio: 'legaleMalvagio',
  CharacterAlignment.neutraleMalvagio: 'neutraleMalvagio',
  CharacterAlignment.caoticoMalvagio: 'caoticoMalvagio',
  CharacterAlignment.nessuno: 'nessuno',
};
