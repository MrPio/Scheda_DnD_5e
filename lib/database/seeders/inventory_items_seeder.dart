import 'package:scheda_dnd_5e/model/loot.dart';

import '../../enum/dice.dart';
import '../../model/character.dart';
import '../database_seeder.dart';

class WeaponSeeder extends Seeder<Weapon> {
  @override
  List<Weapon> get seeds => [
        // Armi da Mischia Semplici
        Weapon('Ascia', [Dice.d6], 0, 'Danni taglienti, Lancio (gittata 6/18), Leggera'),
        Weapon('Bastone Ferrato', [Dice.d6], 0, 'Danni contundenti, Versatile (1d8)'),
        Weapon('Falcetto', [Dice.d4], 0, 'Danni taglienti, Leggera'),
        Weapon('Giavellotto', [Dice.d6], 0, 'Danni perforantiLancio (gittata 9/36)'),
        Weapon('Lancia', [Dice.d6], 0, 'Danni perforanti, Lancio (gittata 6/18), Versatile (1d8)'),
        Weapon('Martello Leggero', [Dice.d4], 0, 'Danni contundenti, Lancio (gittata 6/18), Leggera'),
        Weapon('Mazza', [Dice.d6], 0, 'Danni contundenti'),
        Weapon('Pugnale', [Dice.d4], 0, 'Danni perforanti, Accurata, Lancio (gittata 6/18), Leggera'),
        Weapon('Randello', [Dice.d4], 0, 'Danni contundenti, Leggera'),
        Weapon('Randello Pesante', [Dice.d8], 0, 'Danni contundenti, Due Mani'),
        // Armi a Distanza Semplici
        Weapon('Arco Corto', [Dice.d6], 0, 'Danni perforanti, Due Mani, Munizioni (gittata 24/96)'),
        Weapon('Balestra Leggera', [Dice.d8], 0,
            'Danni perforanti, Due Mani, Munizioni (gittata 24/96), Ricarica'),
        Weapon('Dardo', [Dice.d4], 0, 'Danni perforanti, Accurata, Lancio (gittata 6/18)'),
        Weapon('Fionda', [Dice.d4], 0, 'Danni contundenti, Munizioni (gittata 9/36)'),
        // Armi da Mischia da Guerra
        Weapon('Alabarda', [Dice.d10], 0, 'Danni taglienti, Due Mani, Pesante, Portata'),
        Weapon('Ascia Bipenne', [Dice.d12], 0, 'Danni taglienti, Due Mani, Pesante'),
        Weapon('Ascia da Battaglia', [Dice.d8], 0, 'Danni taglienti, Versatile (1d1O)'),
        Weapon('Falcione', [Dice.d10], 0, 'Danni taglienti, Due Mani, Pesante, Portata'),
        Weapon('Frusta', [Dice.d4], 0, 'Danni taglienti, Accurata, Portata'),
        Weapon('Lancia da Cavaliere', [Dice.d12], 0, 'Danni perforanti, Portata, Speciale'),
        Weapon('Maglio', [Dice.d6, Dice.d6], 0, 'Danni contundenti, Due Mani, Pesante'),
        Weapon('Martello da Guerra', [Dice.d8], 0, 'Danni contundenti, Versatile (1d10)'),
        Weapon('Mazzafrusto', [Dice.d8], 0, 'Danni contundenti'),
        Weapon('Morning Star', [Dice.d8], 0, 'Danni perforanti'),
        Weapon('Picca', [Dice.d10], 0, 'Danni perforanti, Due Mani, Pesante, Portata'),
        Weapon('Piccone da Guerra', [Dice.d8], 0, 'Danni perforanti'),
        Weapon('Scimitarra', [Dice.d6], 0, 'Danni taglienti, Accurata, leggera'),
        Weapon('Spada Corta', [Dice.d6], 0, 'Danni perforanti, Accurata, leggera'),
        Weapon('Spada Lunga', [Dice.d8], 0, 'Danni taglienti, Versatile (1d10)'),
        Weapon('Spadone', [Dice.d6, Dice.d6], 0, 'Danni taglienti, Due Mani, Pesante'),
        Weapon('Stocco', [Dice.d8], 0, 'Danni perforanti, Accurata'),
        Weapon('Tridente', [Dice.d6], 0, 'Danni perforanti, Lancio (gittata 6/18), Versatile (1d8)'),
        // Armi o Distanza da Guerra
        Weapon('Arco Lungo', [Dice.d8], 0,
            'Danni perforanti, Due Mani, Munizioni (gittata 45/180), Pesante'),
        Weapon('Balestra a Mano', [Dice.d6], 0,
            'Danni perforanti, Leggera, Munizioni (gittata 9/36), Ricarica'),
        Weapon('Balestra Pesante', [Dice.d10], 0,
            'Danni perforanti, Due Mani, Munizioni (gittata 30/120), Pesante, Ricarica'),
        Weapon('Cerbottana', [], 1, 'Danni perforanti, Munizioni (gittata 7,5/30), Ricarica'),
        Weapon('Rete', [], 0, 'Lancio (gittata 1,5/4,5), Speciale'),
      ];
}

class ArmorSeeder extends Seeder<Armor> {
  @override
  List<Armor> get seeds => [
        // Leggere
        Armor('Imbottita', 11, 0, true, {Skill.destrezza: 0}, false),
        Armor('Armatura di cuoio', 11, 0, false, {Skill.destrezza: 0}, false),
        Armor('Armatura di cuoio borchiato', 12, 0, false, {Skill.destrezza: 0}, false),
        // Medie
        Armor('Armatura di pelle', 12, 0, false, {Skill.destrezza: 2}, false),
        Armor('Giaco di maglia', 13, 0, false, {Skill.destrezza: 2}, false),
        Armor('Corazza di scaglie', 14, 0, true, {Skill.destrezza: 2}, false),
        Armor('Corazza di piastre', 14, 0, false, {Skill.destrezza: 2}, false),
        Armor('Mezza armatura', 15, 0, true, {Skill.destrezza: 2}, false),
        // Pesanti
        Armor('Cotta di maglia', 14, 0, true, {}, false),
        Armor('Corazza ad anelli', 16, 13, true, {}, false),
        Armor('Corazza a strisce', 17, 15, true, {}, false),
        Armor('Armatura completa', 18, 15, true, {}, false),
        // Scudi
        Armor('Scudo', 2, 0, false, {}, true),
        Armor('Scudo di legno', 2, 0, false, {}, true)
      ];
}

class ItemSeeder extends Seeder<Item> {
  @override
  List<Item> get seeds => [
        Item('Corno'),
        Item('Focus arcano'),
        Item('Dulcimer'),
        Item('Ciaramella'),
        Item('Cornamusa'),
        Item('Libro degli incantesimi'),
        Item('Tamburo'),
        Item('Liuto'),
        Item('Viola'),
        Item('Lira'),
        Item('Flauto di Pan'),
        Item('Flauto'),
        Item('Borsa per componenti'),
        Item('Martello'),

        // Dotazioni
        Item('Zaino'),
        Item('Acciarino'),
        Item('Pietra focaia'),
        Item('Razione giornaliera'),
        Item('Otre'),
        Item('15mt di corda di canapa'),
        Item('Giaciglio'),
        Item('Gavetta'),
        Item('Focus druidico'),
        Item('Piede di porco'),
        Item('Torcia'),
        Item('Chiodo da rocciatore'),
        Item('Forziere'),
        Item('Custodia per mappe e pergamene'),
        Item('Abito pregiato'),
        Item('Boccietta di inchiostro'),
        Item('Pennino'),
        Item('Lampada'),
        Item('Ampolla di olio'),
        Item('Foglo di carta'),
        Item('Fiala di profumo'),
        Item('Cera per sigillo'),
        Item('Sapone'),
        Item('Coperta'),
        Item('Candele'),
        Item('Cassetta per le offerte'),
        Item('Cubetto di incenso'),
        Item('Incensiere'),
        Item('Veste'),
        Item('Simbolo sacro'),
        Item('Sacchetto con 1000 sfere metalliche'),
        Item('3mt di spago'),
        Item('Campanella'),
        Item('Lanterna schermabile'),
        Item('Costume'),
        Item('Trucchi per il camuffamento'),
        Item('Libro di studio'),
        Item('Foglo di pergamena'),
        Item('Sacchetto di sabbia'),
        Item('Coltellino'),
        // Ammunition
        Item('Ago da cerbottana'),
        Item('Freccia'),
        Item('Proiettile da fionda'),
        Item('Quadrello da balestra'),
        Item('Piccone da minatore'),
        Item('Pozione di guarigione'),
        Item('Rampino'),
        Item('Sacco'),
        Item('3mt di scala a pioli'),
        Item('Secchio'),
        Item('Serratura'),
        Item('Arnesi da scasso'),
      ];
}

class CoinSeeder extends Seeder<Coin> {
  @override
  List<Coin> get seeds => [
        Coin('Rame', 'mr', 1),
        Coin('Argento', 'ma', 10),
        Coin('Electrum', 'me', 50),
        Coin('Oro', 'mo', 100),
        Coin('Platino', 'mp', 1000),
      ];
}

class EquipmentSeeder extends Seeder<Equipment> {
  @override
  List<Equipment> get seeds => [
        // Dotazioni
        Equipment('Dotazione da avventuriero', {
          'zaino': 1,
          'martello': 1,
          'piedeDiPorco': 1,
          'chiodoDaRocciatore': 10,
          'torcia': 10,
          'acciarino': 1,
          'pietraFocaia': 1,
          'razioneGiornaliera': 10,
          'otre': 1,
          'cordaDiCanapa': 1,
        }),
        Equipment('Dotazione da sacerdote', {
          'coperta': 1,
          'candela': 10,
          'cassettaPerLeOfferte': 1,
          'cubettoDiIncenso': 2,
          'incensiere': 1,
          'veste': 1,
          'razioneGiornaliera': 2,
          'otre': 1,
          'simboloSacro': 1,
          'zaino': 1,
          'acciarino': 1,
          'pietraFocaia': 1,
        }),
        Equipment('Dotazione da scassinatore', {
          'zaino': 1,
          'piedeDiPorco': 1,
          'martello': 1,
          'chiodoDaRocciatore': 10,
          'acciarino': 1,
          'pietraFocaia': 1,
          'razioneGiornaliera': 5,
          'otre': 1,
          'cordaDiCanapa': 1,
          'ampollaDiOlio': 2,
          'candela': 5,
          'sacchettoCon1000SfereMetalliche': 1,
          'spago': 1,
          'campanella': 1,
          'lanternaSchermabile': 1,
        }),
        Equipment('Dotazione da diplomatico', {
          'forziere': 1,
          'custodiaPerMappeEPergamene': 2,
          'abitoPregiato': 1,
          'bocciettaDiInchiostro': 1,
          'pennino': 1,
          'lampada': 1,
          'ampollaDiOlio': 2,
          'fogloDiCarta': 5,
          'fialaDiProfumo': 1,
          'ceraPerSigillo': 1,
          'sapone': 1,
        }),
        Equipment('Dotazione da esploratore', {
          'zaino': 1,
          'acciarino': 1,
          'pietraFocaia': 1,
          'razioneGiornaliera': 10,
          'otre': 1,
          'cordaDiCanapa': 1,
          'giaciglio': 1,
          'gavetta': 1,
          'focusDruidico': 1,
        }),
        Equipment('Dotazione da intrattenitore', {
          'zaino': 1,
          'giaciglio': 1,
          'costume': 2,
          'candela': 5,
          'razioneGiornaliera': 5,
          'otre': 1,
          'trucchiPerIlCamuffamento': 1,
        }),
        Equipment('Dotazione da studioso', {
          'zaino': 1,
          'libroDiStudio': 1,
          'bocciettaDiInchiostro': 1,
          'pennino': 1,
          'fogloDiPergamena': 10,
          'sacchettoDiSabbia': 1,
          'coltellino': 1
        }),
        // Oggetti Composti
        Equipment(
            'Una balestra leggera e 20 Quadrelli', {'balestraLeggera': 1, 'quadrelloDaBalestra': 20}),
        Equipment('Arco lungo e faretra con 20 frecce', {
          'arcoLungo': 1,
          'freccia': 20,
        }),
        Equipment('Un\'armatura di cuoio, un arco lungo e 20 frecce', {
          'armaturaDiCuoio': 1,
          'arcoLungo': 1,
          'freccia': 20,
        }),
        Equipment('Un arco corto e 20 frecce', {'arcoCorto': 1, 'freccia': 20}),
        Equipment('Un\'armatura di cuoio e un pugnale', {
          'armaturaDiCuoio': 1,
          'pugnale': 1,
        }),
        Equipment('Un\'armatura di cuoio, 2 pugnali e arnesi da scasso', {
          'armaturaDiCuoio': 1,
          'pugnale': 2,
          'arnesiDaScasso': 1,
        }),
      ];
}
