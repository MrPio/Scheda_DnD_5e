import 'package:scheda_dnd_5e/enum/race.dart';
import 'package:scheda_dnd_5e/enum/skill.dart';
import 'package:tuple/tuple.dart';

import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';
import 'mastery.dart';

@Localized(['title', 'description'])
enum SubRace implements EnumWithTitle {
  elfoAlto(
      1,
      {Skill.intelligenza: 1},
      [Mastery.spadeCorte, Mastery.spadeLunghe, Mastery.archiCorti, Mastery.archiLunghi],
      9,
      [
        Tuple2('Trucchetto',
            'TRUCCHETTO\nConoscete un trucchetto a vostra scelta dalla lista degli incantesimi da mago.\nL\'Intelligenza è la caratteristica chiave per lanciare questo incantesimo.')
      ]),
  elfoDeiBoschi(
      0,
      {Skill.saggezza: 1},
      [Mastery.spadeCorte, Mastery.spadeLunghe, Mastery.archiCorti, Mastery.archiLunghi],
      10.5,
      [
        Tuple2('Maschera della selva',
            'MASCHERA DELLA SELVA\nUn elfo dei boschi può tentare di nascondersi alla vista altrui anche quando è leggermente oscurato da fogliamo, pioggia fitta, neve, foschia e altri fenomeni naturali.')
      ]),
  elfoOscuro(
      0,
      {Skill.carisma: 1},
      [Mastery.spadeCorte, Mastery.stocchi, Mastery.balestreAMano],
      9,
      [
        Tuple2('Scurovisione superiore',
            'SCUROVISIONE SUPERIORE\nLa scurovisione di un elfo oscuro arriva fino a 36 metri.'),
        Tuple2('Sensibilità alla luce del sole',
            'SENSIBILITÀ ALLA LUCE DEL SOLE\nUn elfo oscuro dispone di svantaggio ai tiri per colpire e alle prove di saggezza(Percezione) basate sulla vista quando l\'elfo in questione, il bersaglio del suo attacco o l\'oggetto da percepire si trovano in piena luce del sole.'),
        Tuple2('Magia drow',
            'MAGIA DROW\nUn elfo oscuro conosce il trucchetto "luci danzanti".\nQuando raggiunge il 3° livello, può lanciare l\'incantesimo "luminescenza" una volta con questo tratto e recuperare la capacità di farlo quando completa un riposo lungo.\nQuando raggiunge il 5° livello, può lanciare l\'incantesimo "oscurità" una volta con questo tratto e recuperà la capacità di farlo quando completa un riposo lungo.\nLa caratteristica da incantatore per questi incantesimi è carisma.')
      ]),
  gnomoDelleForeste(
      0,
      {Skill.destrezza: 1},
      [],
      7.5,
      [
        Tuple2('Illusionista nato',
            'ILLUSIONISTA NATO\nUno gnomo delle foreste conosce il trucchetto illusione minore.\nLa caratteristica da incantatore usata per questo trucchetto è Intelligenza.'),
        Tuple2('Parlare con le piccole bestie',
            'PARLARE CON LE PICCOLE BESTIE\nUno gnomo delle foreste può usare suoni e gesti per comunicare i concetti più semplici alle bestie di taglia piccola o inferiore.\nGli gnomi delle foreste amano gli animali e spesso tengono presso di loro scoiattoli, tassi, conigli, talpe, picchi e altre creature simili come animali da compagnia.')
      ]),
  gnomoDelleRocce(
      0,
      {Skill.costituzione: 2},
      [],
      7.5,
      [
        Tuple2('Sapere da artefice',
            'SAPERE DA ARTEFICE\nOgni volta che fate una prova di Intelligenza (Storia) relativa ad oggetti magici, oggetti alchemici o dispositivi tecnologici, potete aggiungere il doppio del bonus di competenza, invece di qualsiasi bonus di competenza applichiate normalmente.'),
        Tuple2('Inventore',
            'INVENTORE\nAvete competenza con strumenti da artigiano (strumenti da inventore).\nUsando questi strumenti, potete spendere 1 ora e materiali del valore di 10 mo per costruire un congegno ad orologeria Minuscolo (CA 5, 1 pf).\nIl congegno cessa di funzionare dopo 24 ore (a meno che spendiate 1 ora a ripararlo per mantenerlo in funzione) o quando usate un\'azione per smantellarlo; in quel caso potete recuperare i materiali usati per crearlo.\nPotete avere fino a tre di tali congegni attivi nello stesso momento.\nQuando create un congegno, scegliete una delle seguenti opzioni:\n- Giocattolo ad orologeria: Questo giocattolo è un animale, mostro o persona ad orologeria, come una rana, un topo, un uccello, un drago o un soldato.\nUna volta posizionato sul terreno, il giocattolo si muove di 1,5 m sul terreno in ognuno dei vostri turni in una direzione casuale.\nFa rumore come appropriato per la creatura che rappresenta.\n- Accendino: Il dispositivo produce una fiamma in miniatura, che potete usare per accendere una candela, una torcia o un fuoco da campo.\nUsare il congegno richiede un\'azione.\n- Scatola Musicale: Una volta aperta, questa scatola musicale suona una singola canzone ad un volume moderato.\nLa scatola finisce di suonare quando raggiunge la fine della canzone o quando viene chiusa.')
      ]),
  halflingPiedelesto(
      0,
      {Skill.carisma: 1},
      [],
      7.5,
      [
        Tuple2('Furtività innata',
            'FURTIVITÀ INNATA\nUn halfling piedelesto può tentare di nascondersi anche se è oscurato solo da una singola creatura, purché questa sia più grande di lui di almeno una taglia.')
      ]),
  halflingTozzo(
      0,
      {Skill.costituzione: 1},
      [],
      7.5,
      [
        Tuple2('Resilienza dei tozzi',
            'RESILIENZA DEI TOZZI\nUn halfling tozzo dispone di vantaggio ai tiri salvezza contro il veleno e di resistenza ai danni da veleno.')
      ]),
  nanoDelleColline(
      0,
      {Skill.saggezza: 1},
      [],
      7.5,
      [
        Tuple2('Robustezza nanica',
            'ROBUSTEZZA NANICA\nIl massimo dei punti ferita aumenta di 1 ed aumenta di 1 ogni volta che guadagnate un livello.')
      ]),
  nanoDelleMontagne(0, {Skill.forza: 2}, [Mastery.armatureLeggere, Mastery.armatureMedie], 7.5, []),
  dragoDArgento(0, {}, [], 9, []),
  dragoBianco(0, {}, [], 9, []),
  dragoBlu(0, {}, [], 9, []),
  dragoDiBronzo(0, {}, [], 9, []),
  dragoNero(0, {}, [], 9, []),
  dragoDOro(0, {}, [], 9, []),
  dragoDOttone(0, {}, [], 9, []),
  dragoDiRame(0, {}, [], 9, []),
  dragoRosso(0, {}, [], 9, []),
  dragoVerde(0, {}, [], 9, []),
  ;

  @override
  final int numChoiceableLanguages;
  final Map<Skill, int> defaultSkills;
  final double defaultSpeed;
  final List<Mastery> defaultMasteries;
  final List<Tuple2<String, String>> abilities; //name, info

  const SubRace(this.numChoiceableLanguages, this.defaultSkills, this.defaultMasteries, this.defaultSpeed,
      this.abilities);

  // String get description =>
  //     _description ?? Race.values.firstWhere((e) => e.subRaces.contains(this)).description;

  Race get race => Race.values.firstWhere((e) => e.subRaces.contains(this));
}
