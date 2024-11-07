import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';

import '../enum/dice.dart';

part 'part/loot.g.dart';

abstract class InventoryItem extends EnumWithTitle {
  static const List<List<InventoryItem>> implementations = [
    Weapon.values,
    Armor.values,
    Item.values,
    Coin.values,
    Equipment.values,
  ];

  factory InventoryItem.fromName(String name) {
    for (var impl in implementations) {
      for (var val in impl) {
        if (val.toString() == name) {
          return val;
        }
      }
    }
    throw Exception;
  }
}

enum Weapon implements InventoryItem {
  // Armi da Mischia Semplici
  ascia('Ascia', [Dice.d6], 0, 'Danni taglienti, Lancio (gittata 6/18), Leggera'),
  bastoneFerrato('Bastone Ferrato', [Dice.d6], 0, 'Danni contundenti, Versatile (1d8)'),
  falcetto('Falcetto', [Dice.d4], 0, 'Danni taglienti, Leggera'),
  giavellotto('Giavellotto', [Dice.d6], 0, 'Danni perforantiLancio (gittata 9/36)'),
  lancia('Lancia', [Dice.d6], 0, 'Danni perforanti, Lancio (gittata 6/18), Versatile (1d8)'),
  martelloLeggero('Martello Leggero', [Dice.d4], 0, 'Danni contundenti, Lancio (gittata 6/18), Leggera'),
  mazza('Mazza', [Dice.d6], 0, 'Danni contundenti'),
  pugnale('Pugnale', [Dice.d4], 0, 'Danni perforanti, Accurata, Lancio (gittata 6/18), Leggera'),
  randello('Randello', [Dice.d4], 0, 'Danni contundenti, Leggera'),
  randelloPesante('Randello Pesante', [Dice.d8], 0, 'Danni contundenti, Due Mani'),
  // Armi a Distanza Semplici
  arcoCorto('Arco Corto', [Dice.d6], 0, 'Danni perforanti, Due Mani, Munizioni (gittata 24/96)'),
  balestraLeggera('Balestra Leggera', [Dice.d8], 0,
      'Danni perforanti, Due Mani, Munizioni (gittata 24/96), Ricarica'),
  dardo('Dardo', [Dice.d4], 0, 'Danni perforanti, Accurata, Lancio (gittata 6/18)'),
  fionda('Fionda', [Dice.d4], 0, 'Danni contundenti, Munizioni (gittata 9/36)'),
  // Armi da Mischia da Guerra
  alabarda('Alabarda', [Dice.d10], 0, 'Danni taglienti, Due Mani, Pesante, Portata'),
  asciaBipenne('Ascia Bipenne', [Dice.d12], 0, 'Danni taglienti, Due Mani, Pesante'),
  asciaDaBattaglia('Ascia da Battaglia', [Dice.d8], 0, 'Danni taglienti, Versatile (1d1O)'),
  falcione('Falcione', [Dice.d10], 0, 'Danni taglienti, Due Mani, Pesante, Portata'),
  frusta('Frusta', [Dice.d4], 0, 'Danni taglienti, Accurata, Portata'),
  lanciaDaCavaliere('Lancia da Cavaliere', [Dice.d12], 0, 'Danni perforanti, Portata, Speciale'),
  maglio('Maglio', [Dice.d6, Dice.d6], 0, 'Danni contundenti, Due Mani, Pesante'),
  martelloDaGuerra('Martello da Guerra', [Dice.d8], 0, 'Danni contundenti, Versatile (1d10)'),
  mazzafrusto('Mazzafrusto', [Dice.d8], 0, 'Danni contundenti'),
  morningStar('Morning Star', [Dice.d8], 0, 'Danni perforanti'),
  picca('Picca', [Dice.d10], 0, 'Danni perforanti, Due Mani, Pesante, Portata'),
  picconeDaGuerra('Piccone da Guerra', [Dice.d8], 0, 'Danni perforanti'),
  scimitarra('Scimitarra', [Dice.d6], 0, 'Danni taglienti, Accurata, leggera'),
  spadaCorta('Spada Corta', [Dice.d6], 0, 'Danni perforanti, Accurata, leggera'),
  spadaLunga('Spada Lunga', [Dice.d8], 0, 'Danni taglienti, Versatile (1d10)'),
  spadone('Spadone', [Dice.d6, Dice.d6], 0, 'Danni taglienti, Due Mani, Pesante'),
  stocco('Stocco', [Dice.d8], 0, 'Danni perforanti, Accurata'),
  tridente('Tridente', [Dice.d6], 0, 'Danni perforanti, Lancio (gittata 6/18), Versatile (1d8)'),
  // Armi o Distanza da Guerra
  arcoLungo(
      'Arco Lungo', [Dice.d8], 0, 'Danni perforanti, Due Mani, Munizioni (gittata 45/180), Pesante'),
  balestraAMano(
      'Balestra a Mano', [Dice.d6], 0, 'Danni perforanti, Leggera, Munizioni (gittata 9/36), Ricarica'),
  balestraPesante('Balestra Pesante', [Dice.d10], 0,
      'Danni perforanti, Due Mani, Munizioni (gittata 30/120), Pesante, Ricarica'),
  cerbottana('Cerbottana', [], 1, 'Danni perforanti, Munizioni (gittata 7,5/30), Ricarica'),
  rete('Rete', [], 0, 'Lancio (gittata 1,5/4,5), Speciale');

  @override
  final String title;
  final List<Dice> rollDamage;
  final int fixedDamage;
  final String property;

  const Weapon(this.title, this.rollDamage, this.fixedDamage, this.property);
}

enum Armor implements InventoryItem {
  // Leggere
  imbottita('Imbottita', '11 + modificatore di Destrezza', 0, true),
  armaturaDiCuoio('Armatura di cuoio', '11 + modificatore di Destrezza', 0, false),
  armaturaDiCuoioBorchiato('Armatura di cuoio borchiato', '12 + modificatore di Destrezza', 0, false),
  // Medie
  armaturaDiPelle('Armatura di pelle', '12 + modificatore di Destrezza (max 2)', 0, false),
  giacoDiMaglia('Giaco di maglia', '13 + modificatore di Destrezza (max 2)', 0, false),
  corazzaDiScaglie('Corazza di scaglie', '14 + modificatore di Destrezza (max 2)', 0, true),
  corazzaDiPiastre('Corazza di piastre', '14 + modificatore di Destrezza (max 2)', 0, false),
  mezzaArmatura('Mezza armatura', '15 + modificatore di Destrezza (max 2)', 0, true),
  // Pesanti
  cottaDiMaglia('Cotta di maglia', '14', 0, true),
  corazzaAdAnelli('Corazza ad anelli', '16', 13, true),
  corazzaAStriscie('Corazza a strisce', '17', 15, true),
  armaturaCompleta('Armatura completa', '18', 15, true),
  // Scudi
  scudo('Scudo', '+2', 0, false),
  scudoDiLegno('Scudo di legno', '+2', 0, false);

  @override
  final String title;
  final String CA;
  final int strength;
  final bool disadvantage;

  const Armor(this.title, this.CA, this.strength, this.disadvantage);
}

enum Item implements InventoryItem {
  corno('Corno'),
  focusArcano('Focus arcano'),
  dulcimer('Dulcimer'),
  ciaramella('Ciaramella'),
  cornamusa('Cornamusa'),
  libroDegliIncantesimi('Libro degli incantesimi'),
  tamburo('Tamburo'),
  liuto('Liuto'),
  viola('Viola'),
  lira('Lira'),
  flautoDiPan('Flauto di Pan'),
  flauto('Flauto'),
  borsaPerComponenti('Borsa per componenti'),
  martello('Martello'),

  // Dotazioni
  zaino('Zaino'),
  acciarino('Acciarino'),
  pietraFocaia('Pietra focaia'),
  razioneGiornaliera('Razione giornaliera'),
  otre('Otre'),
  cordaDiCanapa('15mt di corda di canapa'),
  giaciglio('Giaciglio'),
  gavetta('Gavetta'),
  focusDruidico('Focus druidico'),
  piedeDiPorco('Piede di porco'),
  torcia('Torcia'),
  chiodoDaRocciatore('Chiodo da rocciatore'),
  forziere('Forziere'),
  custodiaPerMappeEPergamene('Custodia per mappe e pergamene'),
  abitoPregiato('Abito pregiato'),
  bocciettaDiInchiostro('Boccietta di inchiostro'),
  pennino('Pennino'),
  lampada('Lampada'),
  ampollaDiOlio('Ampolla di olio'),
  fogloDiCarta('Foglo di carta'),
  fialaDiProfumo('Fiala di profumo'),
  ceraPerSigillo('Cera per sigillo'),
  sapone('Sapone'),
  coperta('Coperta'),
  candela('Candele'),
  cassettaPerLeOfferte('Cassetta per le offerte'),
  cubettoDiIncenso('Cubetto di incenso'),
  incensiere('Incensiere'),
  veste('Veste'),
  simboloSacro('Simbolo sacro'),
  sacchettoCon1000SfereMetalliche('Sacchetto con 1000 sfere metalliche'),
  spago('3mt di spago'),
  campanella('Campanella'),
  lanternaSchermabile('Lanterna schermabile'),
  costume('Costume'),
  trucchiPerIlCamuffamento('Trucchi per il camuffamento'),
  libroDiStudio('Libro di studio'),
  fogloDiPergamena('Foglo di pergamena'),
  sacchettoDiSabbia('Sacchetto di sabbia'),
  coltellino('Coltellino'),
  // Ammunition
  agoDaCerbottana('Ago da cerbottana'),
  freccia('Freccia'),
  proiettileDaFionda('Proiettile da fionda'),
  quadrelloDaBalestra('Quadrello da balestra'),
  picconeDaMinatore('Piccone da minatore'),
  pozioneDiGuarigione('Pozione di guarigione'),
  rampino('Rampino'),
  sacco('Sacco'),
  scalaAPioli('3mt di scala a pioli'),
  secchio('Secchio'),
  serratura('Serratura'),
  arnesiDaScasso('Arnesi da scasso'),
  ;

  @override
  final String title;

  const Item(this.title);
}

enum Coin implements InventoryItem {
  rame('mr', 1),
  argento('ma', 10),
  electrum('me', 50),
  oro('mo', 100),
  platino('mp', 1000);

  @override
  final String title;
  final int value;

  const Coin(this.title, this.value);
}

enum Equipment implements InventoryItem {
  // Dotazioni
  dotazioneDaAvventuriero('Dotazione da avventuriero', {
    Item.zaino: 1,
    Item.martello: 1,
    Item.piedeDiPorco: 1,
    Item.chiodoDaRocciatore: 10,
    Item.torcia: 10,
    Item.acciarino: 1,
    Item.pietraFocaia: 1,
    Item.razioneGiornaliera: 10,
    Item.otre: 1,
    Item.cordaDiCanapa: 1,
  }),
  dotazioneDaSacerdote('Dotazione da sacerdote', {
    Item.coperta: 1,
    Item.candela: 10,
    Item.cassettaPerLeOfferte: 1,
    Item.cubettoDiIncenso: 2,
    Item.incensiere: 1,
    Item.veste: 1,
    Item.razioneGiornaliera: 2,
    Item.otre: 1,
    Item.simboloSacro: 1,
    Item.zaino: 1,
    Item.acciarino: 1,
    Item.pietraFocaia: 1,
  }),
  dotazioneDaScassinatore('Dotazione da scassinatore', {
    Item.zaino: 1,
    Item.piedeDiPorco: 1,
    Item.martello: 1,
    Item.chiodoDaRocciatore: 10,
    Item.acciarino: 1,
    Item.pietraFocaia: 1,
    Item.razioneGiornaliera: 5,
    Item.otre: 1,
    Item.cordaDiCanapa: 1,
    Item.ampollaDiOlio: 2,
    Item.candela: 5,
    Item.sacchettoCon1000SfereMetalliche: 1,
    Item.spago: 1,
    Item.campanella: 1,
    Item.lanternaSchermabile: 1,
  }),
  dotazioneDaDiplomatico('Dotazione da diplomatico', {
    Item.forziere: 1,
    Item.custodiaPerMappeEPergamene: 2,
    Item.abitoPregiato: 1,
    Item.bocciettaDiInchiostro: 1,
    Item.pennino: 1,
    Item.lampada: 1,
    Item.ampollaDiOlio: 2,
    Item.fogloDiCarta: 5,
    Item.fialaDiProfumo: 1,
    Item.ceraPerSigillo: 1,
    Item.sapone: 1,
  }),
  dotazioneDaEsploratore('Dotazione da esploratore', {
    Item.zaino: 1,
    Item.acciarino: 1,
    Item.pietraFocaia: 1,
    Item.razioneGiornaliera: 10,
    Item.otre: 1,
    Item.cordaDiCanapa: 1,
    Item.giaciglio: 1,
    Item.gavetta: 1,
    Item.focusDruidico: 1,
  }),
  dotazioneDaIntrattenitore('Dotazione da intrattenitore', {
    Item.zaino: 1,
    Item.giaciglio: 1,
    Item.costume: 2,
    Item.candela: 5,
    Item.razioneGiornaliera: 5,
    Item.otre: 1,
    Item.trucchiPerIlCamuffamento: 1,
  }),
  dotazioneDaStudioso('Dotazione da studioso', {
    Item.zaino: 1,
    Item.libroDiStudio: 1,
    Item.bocciettaDiInchiostro: 1,
    Item.pennino: 1,
    Item.fogloDiPergamena: 10,
    Item.sacchettoDiSabbia: 1,
    Item.coltellino: 1
  }),
  // Oggetti Composti
  unaBalestraLeggeraE20Quadrelli(
      'Una balestra leggera e 20 Quadrelli', {Weapon.balestraLeggera: 1, Item.quadrelloDaBalestra: 20}),
  arcoLungoEFaretraCon20Frecce('Arco lungo e faretra con 20 frecce', {
    Weapon.arcoLungo: 1,
    Item.freccia: 20,
  }),
  unArmaturaDiCuoioUnArcoLungoE20Frecce('Un\'armatura di cuoio, un arco lungo e 20 frecce', {
    Armor.armaturaDiCuoio: 1,
    Weapon.arcoLungo: 1,
    Item.freccia: 20,
  }),
  unArcoCortoE20Frecce('Un arco corto e 20 frecce', {Weapon.arcoCorto: 1, Item.freccia: 20}),
  unArmaturaDiCuoioEUnPugnale('Un\'armatura di cuoio e un pugnale', {
    Armor.armaturaDiCuoio: 1,
    Weapon.pugnale: 1,
  }),
  unArmaturaDiCuoio2PugnaliEArnesiDaScasso('Un\'armatura di cuoio, 2 pugnali e arnesi da scasso', {
    Armor.armaturaDiCuoio: 1,
    Weapon.pugnale: 2,
    Item.arnesiDaScasso: 1,
  }),
  ;

  @override
  final String title;
  final Map<EnumWithTitle, int> content;

  const Equipment(this.title, this.content);

  Loot get loot => Loot(content, title);
}

@JsonSerializable(constructor: 'jsonConstructor')
class Loot implements JSONSerializable {
  @JsonKey(includeFromJson: true, includeToJson: true)
  final String? _name;
  @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<Object, int> _content;

  Loot.jsonConstructor(this._name, this._content);

  Loot(this._content, [this._name]) {
    for (var qta in _content.values) {
      assert(qta > 0);
    }
  }

  String get name => _name ?? content.keys.toList()[0].title;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<InventoryItem, int> get content => _content.cast<InventoryItem, int>();

  @override
  factory Loot.fromJson(Map<String, dynamic> json) => _$LootFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$LootToJson(this);
}
