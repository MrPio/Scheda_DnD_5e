import 'package:scheda_dnd_5e/enum/skill.dart';
import 'package:scheda_dnd_5e/enum/subrace.dart';
import 'package:scheda_dnd_5e/enum/subskill.dart';
import 'package:tuple/tuple.dart';

import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';
import 'language.dart';
import 'mastery.dart';
import 'subrace.localized.g.part';

@Localized(['title', 'description'])
enum Race implements EnumWithTitle {
  umano(
      [],
      [
        Language.comune,
      ],
      null,
      true,
      {
        Skill.forza: 1,
        Skill.destrezza: 1,
        Skill.costituzione: 1,
        Skill.intelligenza: 1,
        Skill.saggezza: 1,
        Skill.carisma: 1,
      },
      0,
      0,
      [],
      9,
      []),
  nano(
      [
        SubRace.nanoDelleColline,
        SubRace.nanoDelleMontagne,
      ],
      [
        Language.comune,
        Language.nanico,
      ],
      null,
      false,
      {
        Skill.costituzione: 2,
      },
      0,
      0,
      [Mastery.scorteDaMescitore, Mastery.strumentiDaCostruttore, Mastery.strumentiDaFabbro],
      7.5,
      [
        Tuple2('Scurovisione',
            'SCUROVISIONE\nAbituati alla vita sotterranea, avete una vista superiore in condizioni di buio o luce debole.\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.'),
        Tuple2('Resilienza nanica',
            'RESILIENZA NANICA\nAvete vantaggio nei tiri salvezza contro il veleno ed avete resistenza contro i danni da veleno (spiegato nel capitolo 9). '),
        Tuple2('Esperto minatore',
            'ESPERTO MINATORE\nOgni volta che effettuate una prova di Intelligenza (Storia) relativa all\'origine di opere in muratura, venite considerati competenti nell\'abilità Storia ed aggiungete il doppio del bonus di competenza alla prova, invece del normale bonus di competenza.')
      ]),
  elfo(
      [
        SubRace.elfoAlto,
        SubRace.elfoDeiBoschi,
        SubRace.elfoOscuro,
      ],
      [
        Language.comune,
        Language.elfico,
      ],
      SubSkill.percezione,
      false,
      {
        Skill.destrezza: 2,
      },
      0,
      0,
      [],
      9,
      [
        Tuple2('Scurovisione',
            'SCUROVISIONE\nAbituati a foreste in penombra ed al cielo notturno, avete una vista superiore in condizioni di buio o luce debole.Abituati a foreste in penombra ed al cielo notturno, avete una vista superiore in condizioni di buio o luce debole.\nPossono vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\nNon possono discernere i colori nell\'oscurità, solo sfumature di grigio.'),
        Tuple2('Stirpe fatata',
            'STIRPE FATATA\nSi ha vantaggio nei tiri salvezza contro l\'essere affascinati e la magia non può farvi addormentare.'),
        Tuple2('Trance',
            'TRANCE\nGli elfi non hanno bisogno di dormire.\nInvece meditano profondamente, rimanendo semi-coscienti, per 4 ore al giorno.\nMentre meditano, possono in qualche modo sognare: tali sogni sono in realtà esercizi mentali che sono divenuti riflessivi attraverso anni di pratica.\nDopo aver riposato in questo modo, guadagnate lo stesso beneficio che un umano ottiene da 8 ore di sonno.')
      ]),
  dragonide(
      [
        SubRace.dragoDArgento,
        SubRace.dragoBianco,
        SubRace.dragoBlu,
        SubRace.dragoDiBronzo,
        SubRace.dragoNero,
        SubRace.dragoDOro,
        SubRace.dragoDOttone,
        SubRace.dragoDiRame,
        SubRace.dragoRosso,
        SubRace.dragoVerde,
      ],
      [
        Language.comune,
        Language.draconico,
      ],
      null,
      false,
      {
        Skill.forza: 2,
        Skill.carisma: 1,
      },
      0,
      0,
      [],
      9,
      [
        Tuple2('Tipo di drago',
            '| Sotto razza | Tipo di danno |    Arma a soffio     | Tiro salvezza |\n|:----------:|:-------------:|:--------------------:|:-------------:|\n|   Bianco   |    Freddo     |    Cono di 4,5 m     | Costituzione  |\n|    Blu     |  Elettricità  | Lineare da 1,5 a 9 m |   Destrezza   |\n|   Bronzo   |  Elettricità  | Lineare da 1,5 a 9 m |   Destrezza   |\n|    Nero    |     Acido     | Lineare da 1,5 a 9 m |   Destrezza   |\n|    Oro     |     Fuoco     |    Cono di 4,5 m     |   Destrezza   |\n|   Ottone   |     Fuoco     | Lineare da 1,5 a 9 m |   Destrezza   |\n|    Rame    |     Acido     | Lineare da 1,5 a 9 m |   Destrezza   |\n|   Rosso    |     Fuoco     |    Cono di 4,5 m     |   Destrezza   |\n|   Verde    |    Veleno     |    Cono di 4,5 m     | Costituzione  |'),
        Tuple2('Arma a soffio',
            'ARMA A SOFFIO\nPotete usare la vostra azione per esalare energia distruttiva.\nLa discendenza draconica determina dimensione, forma e tipo di danno dell\'esalazione.\nQuando usate l\'arma a soffio, ogni creatura nell\'area dell\'esalazione deve effettuare un tiro salvezza, il cui tipo è determinato dalla vostra discendenza draconica.\nLa CD per questo tiro salvezza è pari a 8 + modificatore di Costituzione + bonus di competenza.\nUna creatura subisce 2d6 danni con un tiro fallito e metà danni con un successo.\nIl danno aumenta a 3d6 al 6° livello, 4d6 all\'11° livello e 5d6 al 16° livello.\nDopo aver usato la vostra arma a soffio, non potete usarla di nuovo finché non completate un riposo breve o lungo.'),
        Tuple2('Resistenze al danno',
            'RESISTENZE AL DANNO\nAvete resistenza al tipo di danno associato con la vostra discendenza draconica.')
      ]),
  gnomo(
      [
        SubRace.gnomoDelleForeste,
        SubRace.gnomoDelleRocce,
      ],
      [
        Language.comune,
        Language.gnomesco,
      ],
      null,
      false,
      {
        Skill.intelligenza: 2,
      },
      0,
      0,
      [],
      7.5,
      [
        Tuple2('Scurovisione',
            'SCUROVISIONE\nAbituati alla vita sotterranea, avete una vista superiore in condizioni di buio o luce debole.\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.'),
        Tuple2('Astuzia gnomesca',
            'ASTUZIA GNOMESCA\nAvete vantaggio in tutti i tiri salvezza su Intelligenza, Saggezza e Carisma contro la magia.')
      ]),
  halfling(
      [
        SubRace.halflingPiedelesto,
        SubRace.halflingTozzo,
      ],
      [
        Language.comune,
        Language.halfling,
      ],
      null,
      false,
      {
        Skill.destrezza: 2,
      },
      0,
      0,
      [],
      7.5,
      [
        Tuple2('Fortunato',
            'FORTUNATO\nQuando ottenete un 1 ad un tiro per colpire, prova caratteristica o tiro salvezza, potete ritirare il dado e dovete usare il nuovo risultato.'),
        Tuple2(
            'Coraggioso', 'CORAGGIOSO\nAvete vantaggio nei tiri salvezza contro l\'essere spaventato.'),
        Tuple2('Versatilità halfling',
            'VERSATILITÀ HALFLING\nPotete muovervi attraverso lo spazio di qualunque creatura che è di una taglia più grande di voi.')
      ]),
  mezzelfo(
      [],
      [
        Language.comune,
        Language.elfico,
      ],
      null,
      true,
      {},
      2,
      2,
      [],
      9,
      [
        Tuple2('Scurovisione',
            'SCUROVISIONE\nGrazie al sangue elfico, avete una vista superiore in condizioni di buio o luce debole.\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.'),
        Tuple2('Stirpe fatata',
            'STIRPE FATATA\nAvete vantaggio nei tiri salvezza contro l\'essere affascinati e la magia non può farvi addormentare.')
      ]),
  mezzorco(
      [],
      [Language.comune, Language.orchesco],
      SubSkill.intimidire,
      false,
      {
        Skill.forza: 2,
        Skill.costituzione: 1,
      },
      0,
      0,
      [],
      9,
      [
        Tuple2('Scurovisione',
            'SCUROVISIONE\nGrazie al sangue orchesco, avete una vista superiore in condizioni di buio o luce debole.\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.'),
        Tuple2('Resistenza inesorabile',
            'RESISTENZA INESORABILE\nQuando siete ridotti a 0 punti ferita ma non uccisi sul colpo, potete invece tornare ad 1 punto ferita.\nNon potete usare questo privilegio nuovamente finché non completate un riposo lungo.'),
        Tuple2('Attacchi selvaggi',
            'ATTACCHI SELVAGGI\nQuando ottenete un colpo critico con un attacco con arma da mischia, potete tirare uno dei dadi del danno da arma una volta in più e aggiungerlo al danno extra del colpo critico.')
      ]),
  tiefling(
      [],
      [
        Language.comune,
        Language.infernale,
      ],
      null,
      false,
      {
        Skill.intelligenza: 1,
        Skill.carisma: 2,
      },
      0,
      0,
      [],
      9,
      [
        Tuple2('Scurovisione',
            'SCUROVISIONE\nGrazie all\'eredità infernale, avete una vista superiore in condizioni di buio o luce debole.\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.'),
        Tuple2('Resistenza diabolica', 'RESISTENZA DIABOLICA\nAvete resistenza al danno da fuoco.'),
        Tuple2('Retaggio infernale',
            'RETAGGIO INFERNALE\nConoscete il trucco taumaturgia.\nUna volta raggiunto il 3° livello, potete lanciare l\'incantesimo rimprovero diabolico una volta al giorno come incantesimo di 2° livello.\nUna volta raggiunto il 5° livello, potete anche lanciare l\'incantesimo oscurità una volta al giorno.\nIl Carisma è la caratteristica chiave per questi incantesimi.'),
      ]);

  final List<SubRace> subRaces;
  final List<Language> defaultLanguages;
  final SubSkill? defaultSubskill;
  final bool canChoiceLanguage;
  final Map<Skill, int> defaultSkills;
  final int numChoiceableSkills, numChoiceableSubSkills; // solo mezzelfo
  // final List<Mastery> defaultMasteries **QUI** **NO**! (**VERIFICATO**)
  final double defaultSpeed;
  final List<Mastery> choiceableMasteries; // ce l'ha il nano
  final List<Tuple2<String, String>> abilities; //name, info

  const Race(
      this.subRaces,
      this.defaultLanguages,
      this.defaultSubskill,
      this.canChoiceLanguage,
      this.defaultSkills,
      this.numChoiceableSkills,
      this.numChoiceableSubSkills,
      this.choiceableMasteries,
      this.defaultSpeed,
      this.abilities);

  String get subRacesInfo =>
      subRaces.isEmpty ? 'Nessuna sottorazza' : subRaces.map((e) => e.title).join(', ');
}
