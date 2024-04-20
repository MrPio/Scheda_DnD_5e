import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/interface/inventory_item.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';

part 'part/loot.g.dart';

enum Weapon implements InventoryItem {
  // Armi da Mischia Semplici
  ascia('Ascia'),
  bastoneFerrato('Bastone Ferrato'),
  falcetto('Falcetto'),
  giavellotto('Giavellotto'),
  lancia('Lancia'),
  martelloLeggero('Martello Leggero'),
  mazza('Mazza'),
  pugnale('Pugnale'),
  randello('Randello'),
  randelloPesante('Randello Pesante'),
  // Armi a Distanza Semplici
  arcoCorto('Arco Corto'),
  balestraLeggera('Balestra Leggera'),
  dardo('Dardo'),
  fionda('Fionda'),
  // Armi da Mischia da Guerra
  alabarda('Alabarda'),
  asciaBipenne('Ascia Bipenne'),
  asciaDaBattaglia('Ascia da Battaglia'),
  falcione('Falcione'),
  frusta('Frusta'),
  lanciaDaCavaliere('Lancia da Cavaliere'),
  maglio('Maglio'),
  martelloDaGuerra('Martello da Guerra'),
  mazzafrusto('Mazzafrusto'),
  morningStar('Morning Star'),
  picca('Picca'),
  picconeDaGuerra('Piccone da Guerra'),
  scimitarra('Scimitarra'),
  spadaCorta('Spada Corta'),
  spadaLunga('Spada Lunga'),
  spadone('Spadone'),
  stocco('Stocco'),
  tridente('Tridente'),
  // Armi o Distanza da Guerra
  arcoLungo('Arco Lungo'),
  balestraAMano('Balestra a Mano'),
  balestraPesante('Balestra Pesante'),
  cerbottana('Cerbottana'),
  rete('Rete');

  @override
  final String title;

  const Weapon(this.title);
}

enum Armor implements InventoryItem {
  // Leggere
  imbottita('Imbottita'),
  armaturaDiCuoio('Armatura di cuoio'),
  armaturaDiCuoioBorchiato('Armatura di cuoio borchiato'),
  // Medie
  armaturaDiPelle('Armatura di pelle'),
  giacoDiMaglia('Giaco di maglia'),
  corazzaDiScaglie('Corazza di scaglie'),
  corazzaDiPiastre('Corazza di piastre'),
  mezzaArmatura('Mezza armatura'),
  // Pesanti
  cottaDiMaglia('Cotta di maglia'),
  corazzaAdAnelli('Corazza ad anelli'),
  corazzaAStriscie('Corazza a strisce'),
  armaturaCompleta('Armatura completa'),
  // Scudi
  scudo('Scudo'),
  scudoDiLegno('Scudo di legno');

  @override
  final String title;

  const Armor(this.title);
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
  unaBalestraLeggeraE20Quadrelli('Una balestra leggera e 20 Quadrelli',
      {Weapon.balestraLeggera: 1, Item.quadrelloDaBalestra: 20}),
  arcoLungoEFaretraCon20Frecce('Arco lungo e faretra con 20 frecce', {
    Weapon.arcoLungo: 1,
    Item.freccia: 20,
  }),
  unArmaturaDiCuoioUnArcoLungoE20Frecce(
      'Un\'armatura di cuoio, un arco lungo e 20 frecce', {
    Armor.armaturaDiCuoio: 1,
    Weapon.arcoLungo: 1,
    Item.freccia: 20,
  }),
  unArcoCortoE20Frecce(
      'Un arco corto e 20 frecce', {Weapon.arcoCorto: 1, Item.freccia: 20}),
  unArmaturaDiCuoioEUnPugnale('Un\'armatura di cuoio e un pugnale', {
    Armor.armaturaDiCuoio: 1,
    Weapon.pugnale: 1,
  }),
  unArmaturaDiCuoio2PugnaliEArnesiDaScasso(
      'Un\'armatura di cuoio, 2 pugnali e arnesi da scasso', {
    Armor.armaturaDiCuoio: 1,
    Weapon.pugnale: 2,
    Item.arnesiDaScasso: 1,
  }),
  ;

  @override
  final String title;
  final Map<InventoryItem, int> content;

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
    for (var qta in content.values) {
      assert(qta < 1);
    }
  }

  String get name => _name ?? content.keys.toList()[0].title;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<InventoryItem, int> get content => _content as Map<InventoryItem, int>;

  @override
  factory Loot.fromJson(Map<String, dynamic> json) => _$LootFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$LootToJson(this);
}
