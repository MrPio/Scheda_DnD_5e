import 'package:scheda_dnd_5e/mixin/comparable.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:scheda_dnd_5e/interface/enum_with_title.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scheda_dnd_5e/extension_function/map_extensions.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';

import 'loot.dart';

part 'character.g.dart';

enum SubClass implements EnumWithTitle {
  // Servono solo per lettura info
  collegioSapienza('Collegio sapienza',
      '**COMPETENZE** **BONUS**\nQuando un bardo si unisce al Collegio della Sapienza al 3° livello, ottiene competenza in tre abilità a sua scelta.\n\n---\n\n**PAROLE** **TAGLIENTI**\nSempre al 3° livello, il bardo impara anche a fare buon uso del suo ingegno per distrarre, confondere e fiaccare la determinazione e la competenza altrui.\nQuando una creatura situata entro 18 metri e che il bardo sia in grado di vedere effettua un tiro per colpire, una prova di caratteristica o un tiro per i danni, il bardo può usare la sua reazione per spendere uno dei suoi utilizzi di Ispirazione Bardica, tirare un dado di Ispirazione Bardica e sottrarre il numero ottenuto dal tiro della creatura.\nPuò scegliere di utilizzare questo privilegio dopo che la creatura ha effettuato il suo tiro, ma prima che il **DM** dichiari se il tiro per colpire o la prova di caratteristica abbia avuto successo o meno, o prima che la creatura infligga i danni.\nLa creatura è immune se non è in grado di sentire il bardo o se non può essere affascinata.\n\n---\n\n**SEGRETI** **MAGICI** **AGGIUNTIVI**\nAl 6° livello, un bardo impara due incantesimi a sua scelta da qualsiasi classe.\nOgni incantesimo scelto deve essere di un livello che il bardo sia in grado di lanciare, come indicato dalla tabella "Bardo", oppure deve essere un trucchetto.\nGli incantesimi scelti contano come incantesimi da bardo, ma non contano al fine di determinare il numero di incantesimi da bardo conosciuti.\n\nABILITÀ **IMPAREGGIABILE**\nA partire dal 14° livello, quando un bardo effettua una prova di caratteristica, può spendere un utilizzo di Ispirazione Bardita.\nSe lo fa, tira un dado di Ispirazione Bardica e aggiunge il risultato ottenuto alla sua prova di caratteristica.\nPuò scegliere di farlo dopo avere tirato il dado per la prova di caratteristica, ma prima che il **DM** dichiari se la prova abbia avuto successo o meno.\n'),
  collegioValore('Collegio valore',
      '**COMPETENZE** **BONUS**\nQuando un bardo si unisce al Collegio del Valore al 3° livello, ottiene competenza nelle armature medie, negli scudi e nelle armi da guerra.\n\n---\n\n**ISPIRAZIONE** **IN** **COMBATTIMENTO**\nAl 3° livello, un bardo apprende anche a ispirare gli ahri in battaglia.\nUna creatura a cui il bardo abbia fornito un dado di Ispirazione Bardica può tirare quel dado e aggiungere il risultato ottenuto al tiro appena effettuato per i danni dell\'arma.\nIn alternativa, quando qualcuno effettua un tiro per colpire contro la creatura, essa può usare la sua reazione per tirare il dado di Ispirazione Bardica e aggiungere il risultato ottenuto alla sua **CA** contro quell\'attacco, dopo avere visto il tiro, ma prima di sapere se la colpirà o meno.\n\n---\n\n**ATTACCO** **EXTRA**\nA partire dal 6° livello, un bardo può attaccare due volte anziché una, ogni volta che effettua l\'azione di Attacco, nel proprio turno.\n\n---\n\n**MAGIA** **DA** **BATTAGLIA**\nAl 14° livello, un bardo ha padroneggiato l\'arte di intessere incantesimi e di utilizzare le armi in un\'unica pratica armonizzata.\nQuando usa la propria azione per lanciare un incantesimo da bardo, può effettuare un attacco con un\'arma come azione bonus.\n'),
  campione('Campione',
      '**CRITICO** **MIGLIORATO**\nA partire da quando il guerriero sceglie questo archetipo al 3° livello, i suoi attacchi con un\'arma mettono a segno un colpo critico con un risultato di 19-20 al tiro.\n\n---\n\n**ATLETA** **STRAORDINARIO**\nA partire dal 7° livello, il guerriero può aggiungere metà del suo bonus di competenza (arrotondalo per eccesso) a qualsiasi prova di Forza, Destrezza o Costituzione che effettua e che non utilizzi già il suo bonus di competenza.\nInoltre, quando il guerriero effettua un salto in lungo con rincorsa, la distanza che copre aumenta di 30 cm per ogni punto del suo modificatore di Forza.\n\n---\n\n**STILE** **DI** **COMBATTIMENTO** **AGGIUNTIVO**\nAl 10° livello, il guerriero può scegliere una seconda opzione dal privilegio di classe Stile di Combattimento.\n\n---\n\n**CRITICO** **SUPERIORE**\nA partire dal 15° livello, gli attacchi con un\'arma del guerriero mettono a segno un colpo critico con un risultato di 18-20 al tiro.\n\n---\n\n**SOPRAVVISSUTO**\nAl 18° livello, il guerriero giunge all\'apice della sua resilienza in battaglia.\nAll\'inizio di ogni suo turno, recupera un ammontare di punti ferita pari a 5 + il suo modificatore di Costituzione, se non gli rimane più della metà dei suoi punti ferita.\nNon ottiene questo beneficio se ha 0 punti ferita.\n'),
  cavaliereMistico('Cavaliere mistico',
      '**INCANTESIMI**\nQuando arriva al 3° livello, il guerriero potenzia le sue doti marziali grazie alla capacità di lanciare incantesimi.\n\n---\n\n**TRUCCHETTI**\nUn guerriero conosce due trucchetti a sua scelta tratti dalla lista degli incantesimi da mago.\nApprende un trucchetto da mago aggiuntivo a sua scelta al 10° livello.\n\n---\n\n**SLOT** **INCANTESIMO**\nLa tabella "Incantesimi del Cavalliere Mistico" indica quanti slot incantesimo possiede un guerriero per lanciare i suoi incantesimi.\nPer lanciare uno di questi incantesimi, un guerriero deve spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nIl guerriero recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nPer esempio, se un guerriero conosce l\'incantesimo di 1° livello scudo e possiede uno slot incantesimo di 1° livello e uno slot incantesimo di 2° livello, può lanciare scudo usando uno qualsiasi dei due slot.\n\n---\n\n**INCANTESIMI** **CONOSCIUTI** **DI** 1° **LIVELLO** E **DI** **LIVELLO** **SUPERIORE**.\nUn guerriero conosce tre incantesimi da mago di 1° livello a sua scelta, due dei quali devono essere scelti tra gli incantesimi di abiurazione e invotazione sulla lista degli incantesimi da mago.\nLa colonna "Incantesimi Conosciuti" nella tabella "Incantesimi del Cavaliere Mistico" indica quando un guerriero impara altri incantesimi da mago di 1° livello o di livello superiore.\nOgnuno di questi incantesimi deve essere un incantesimo di abiurazione o di invocazione a scelta del guerriero e deve appartenere a un livello di cui il guerriero possiede degli slot incantesimo.\nPer esempio, quando un guerriero arriva al 7° livello in questa classe, può apprendere un nuovo incantesimo di 1° o 2° livello.\nGli incantesimi che apprende all\'8°, 14° e 20° livello possono appartenere a qualsiasi scuola di magia.\nOgni volta che il guerriero acquisisce un livello, può sostituire uno degli incantesimi da mago che conosce con un altro incantesimo a sua scelta della lista degli incantesimi da mago.\nIl nuovo incantesimo deve essere di un livello di cui il guerriero possiede almeno uno slot incantesimo e deve essere un incantesimo di abiurazione o di invocazione, a meno che non stia sostituendo l\'incantesimo ottenuto al 3°, 8°, 14° o 20° livello di una qualsiasi scuola di magia.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nIntelligenza è la caratteristica da incantatore per gli incantesimi da mago del guerriero, dal momento che egli apprende i suoi incantesimi tramite lo studio costante e la memorizzazione.\nUn guerriero usa Intelligenza ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Intelligenza per definire la **CD** del tiro salvezza di un incantesimo da mago da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** der tiro salvezza dell\'incantesimo = 8 + il bonus di competenza del guerriero + il modificatore di Intelligenza del guerriero\nModificatore di attacco dell\'incantestmo = Il bonus di competenza del guerriero + il modificatore di Intelligenza del guerriero\n\n---\n\n**ARMA** **VINCOLATA**\nAl 3° livello, il guerriero apprende un rituale che stabilisce un vincolo magico tra lui e un\'arma.\nIl guerriero celebra il rituale nell\'arco di 1 ora, e può farlo durante un riposo breve.\nL\'arma deve trovarsi a sua portata di mano nel corso di tutto il rituale; alla conclusione del rituale, il guerriero tocca l\'arma e stabilisce il vincolo.\nUna volta vincolata l\'arma a sé, il guerriero non può essere disarmato di quell\'arma a meno che non sia incapacitato. Se il guerriero e l\'arma si trovano sullo stesso piano di esistenza, il guerriero può evocare quell\'arma come azione bonus nel proprio turno, facendo in modo che si teletrasporti istantaneamente netta sua mano.\nUn guerriero può avere al massimo due armi vincolate, ma può evocarne solo una alta volta con la sua azione bonus.\nSe tenta di vincolare una terza arma, dovrà spezzare il vincolo con una delle altre due.\n\n---\n\n**MAGIA** **DA** **GUERRA**\nA partire dal 7° livello, quando il guerriero usa la sua azione per lanciare un trucchetto, può effettuare un attacco con un\'arma come azione bonus.\n\n---\n\n**COLPO** **MISTICO**\nAl 10° livello, il guerriero impara a demolire la resistenza agli incantesimi delle creature che colpisce con la sua arma.\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, quella creatura subisce svantaggio al tiro salvezza successivo che effettua contro un incantesimo lanciato dal guerriero entro la fine del turno successivo di quest\'ultimo.\n\n---\n\n**CARICA** **ARCANA**\nAl 15° livello, il guerriero ottiene la capacità di teletrasportarsi di un massimo di 9 metri fino a uno spazio libero cho egli sia in grado di vedere quando utilizza la sua Azione Impetuosa.\nIl guerriero pub teletrasportarsi prima o dopo l\'azione aggiuntiva.\n\n---\n\n**MAGIA** **DA** **GUERRA** **MIGLIORATA**\nA partire dal 18° livello, quando il guerriero usa la sua azione per lanciare un incantesimo, può effettuare un attacco'),
  maestroDiBattaglia('Maestro di battaglia',
      'SUPERIORITÀ **IN** **COMBATTIMENTO**\nQuando il guerriero sceglie questo archetipo al 3° livello, apprende alcune manovre alimentate da dadi speciali chiamati dadi di superiorità.\n\n---\n\n**MANOVRE**: Il guerriero apprende tre manovre a sua scelta, descritte nella sezione "Manovre" seguente.\nMolte manovre potenziano un attacco in qualche modo. Il guerriero può usare soltanto una manovra per attacco.\nUn guerriero apprende due manovre aggiuntive a sua scelta al 7°, 10° e 15° livello.\nOgni volta che apprende nuove manovre, può anche sostituire una manovra che conosce con una manovra diversa.\n---\n\n**DADI** **DI** SUPERIORITà: Il guerriero possiede quattro dadi di superiorità, rappresentati da d8.\nQuando il guerriero usa un dado di superiorità, lo spende.\nRecupera tutti i dadi di superiorità quando completa un riposo breve o lungo.\nOttiene un altro dado di superiorità al 7° livello e un altro ancora al 15° livello.\n---\n\n**TIRI** **SALVEZZA**: Alcune manovre del guerriero richiedono che il bersaglio effettui un tiro salvezza per resistere agli effetti della manovra.\nLa **CD** del tiro salvezza va calcolata come segue:\n---\n\n**CD** del tiro salvezza della manovra = 8 + A bonus di competenza del guerriero + il modificatore di Forza o di Destrezza del guerriero (a scelta del guerriero)\n\n---\n\n**STUDIOSO** **DI** **GUERRA**\nAl 3° livello, il guerriero ottiene competenza in un tipo di strumenti da artigiano a sua scelta.\n\n---\n\n**CONOSCI** **IL** **TUO** **NEMICO**\nA partire dal 7° livello, se il guerriero spende almeno 1 minuto a osservare un\'altra creatura al di fuori del combattimento o a interagire con essa, può apprendere alcune informazioni relative alle capacità di quella Creatura, confrontandole con le proprie.\nIl **DM** rivela al guerriero se la creatura gli è pari, superiore o inferiore relativamente a due dei seguenti tratti a scelta del guerriero:\n- Punteggio di Forza\n- Punteggio di Destrezza\n- Punteggio di Costituzione\n- Classe Armatura\n- Punti ferita attuali\n- Livelli di classe totali (se ne possiede)\n- Livelli di classe da guerriero (se ne possiede)\n\nSUPERIORITÀ **IN** **COMBATTIMENTO** **MIGLIORATA**\nAl 10° livello, i dadi di superiorità del guerriero diventano d1O. Al 18° livello, diventano d12.\n\n---\n\n**IMPLACABILE**\nA partire dal 15° livello, quando il guerriero tira per l\'iniziativa e non gli rimane alcun dado di superiorità, recupera un dado di superiorità.\n\n---\n\n**MANOVRE**\nLe manovre sono presentate in ordine alfabetico:\n\n---\n\n**ATTACCO** **ADDESCANTE**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, può spendere un dado di superiorità per indurre il bersaglio ad attaccarlo.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco, e il bersaglio deve effettuare un tiro salvezza su Saggezza.\nSe lo fallisce, il bersaglio subisce svantaggio a tutti i tiri per colpire contro bersagli diversi dal guerriero fino alla fine del turno successivo del guerriero.\n\n---\n\n**ATTACCO** **CON** **AFFONDO**:\nQuando il guerriero effettua un attacco con un\'arma da mischia nel suo turno, può spendere un dado di superiorità per aumentare di 1,5 metri la propria portata per quell\'attacco.\nSe colpisce, aggiunge il dado di superiorità al tiro per i danni dell\'attacco.\n\n---\n\n**ATTACCO** **CON** **FINTA**:\nIl guerriero può spendere un dado di superiorità e usare un\'azione bonus nel suo turno per fintare, scegliendo una creatura entro 1,5 metri da sé come bersaglio.\nIl guerriero dispone di vantaggio al suo prossimo tiro per colpire contro quella creatura in questo turno.\nSe quell\'attacco colpisce, il guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco.\n\n---\n\n**ATTACCO** **CON** **MANOVRA**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, può spendere un dado di superiorità per spostare uno dei suoi compagni in una posizione più vantaggiosa.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco e sceglie una creatura amica che sia in grado di vederlo o di sentirlo.\nQuella creatura può usare la sua reazione per muoversi fino alla metà della sua velocità senza provocare attacchi di opportunità da parte del bersaglio dell\'attacco del guerriero.\n\n---\n\n**ATTACCO** **CON** **SPAZZATA**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma da mischia, può spendere un dado di superiorità per tentare di infliggere danni a un\'altra creatura con lo stesso attacco.\n---\n\n**II** guerriero sceglie un\'altra creatura entro 1,5 metri dal bersaglio originale ed entro la propria portata.\nSe il tiro per colpire originale colpirebbe anche la seconda creatura, quest\'ultima subisce danni pari al risultato del tiro ottenuto con il dado di superiorità del guerriero.\nI danni sono dello stesso tipo dell\'attacco originale.\n\n---\n\n**ATTACCO** **CON** **SPINTA**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, può spendere un dado di superiorità per tentare di spingere il bersaglio rigettandolo indietro.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco.\nSe il bersaglio è di taglia Grande o inferiore, deve effettuare un tiro salvezza su Forza.\nSe lo fallisce, il guerriero spinge il bersaglio fino a un massimo di 4,5 metri allontanandolo da sé.\n\n---\n\n**ATTACCO** **DISARMANTE**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma può spendere un dado di superiorità per tentare di disarmare il bersaglio, costringendolo a lasciare cadere un oggetto che sta impugnando a scelta del guerriero.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco, e il bersaglio deve effettuare un tiro salvezza su Forza.\nSe lo fallisce, lascia cadere l\'oggetto scelto dal guerriero.\nL\'oggetto cade ai piedi della creatura.\n\n---\n\n**ATTACCO** **MINACCIOSO**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, può spendere un dado di superiorità per tentare di spaventare il bersaglio.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco, e il bersaglio deve effettuare un tiro salvezza su Saggezza.\nSe lo fallisce, il bersaglio è spaventato dal guerriero fino aLLa fine del turno successivo di quest\'ultimo.\n\n---\n\n**ATTACCO** **PRECISO**:\nQuando il guerriero effettua un tiro per colpire con un\'arma contro una creatura, può spendere un dado di superiorità per aggiungerlo al tiro.\nPuò usare questa manovra prima o dopo avere effettuato il tiro per colpire, ma prima di applicare qualsiasi effetto dell\'attacco.\n\n---\n\n**ATTACCO** **SBILANCIANTE**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, può spendere un dado di superiorità per tentare di buttare a terra il bersaglio.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco.\nSe il bersaglio è di taglia Grande o inferiore, deve effettuare u n tiro salvezza su Forza.\nSe lo fallisce, cade a terra prono.\n\n---\n\n**COLPO** **DEL** **COMANDANTE**:\nQuando il guerriero effettua l\'azione di Attacco nel suo turno, può rinunciare a uno dei suoi attacchi e usare un\'azione bonus per ordinare a uno dei suoi compagni di colpire.\nQuando lo fa, sceglie una creatura amica che sia in grado di vederlo o di sentirlo e spende un dado di superiorità.\nQuella creatura può immediatamente usare la sua reazione per effettuare un attacco con un\'arma, aggiungendo il dado di superiorità al tiro per i danni dell\'attacco.\n\n---\n\n**COLPO** **DISTRAENTE**:\nQuando il guerriero colpisce una creatura con un attacco con un\'arma, può spendere un dado di superiorità per distrarre la creatura e procurare ai suoi alleati un\'apertura.\nIl guerriero aggiunge il dado di superiorità al tiro per i danni dell\'attacco.\nIl prossimo tiro per colpire effettuato contro il bersaglio da un attaccante che non sia il guerriero dispone di vantaggio, purché sia effettuato prima dell\'inizio del turno successivo del guerriero.\n\n---\n\n**INCORAGGIAMENTO**:\nNel proprio turno, il guerriero può usare un\'azione bonus e spendere un dado di superiorità per incitare uno dei suoi compagni.\nQuando lo fa, sceglie una creatura amica che sia in grado di vederlo o di sentirlo.\nQuella creatura ottiene un ammontare di punti ferita temporanei pari al risultato del tiro del dado di superiorità + il modificatore di Carisma del guerriero.\n\n---\n\n**PARATA**:\nQuando un\'altra creatura infligge danni al guerriero con un attacco in mischia, il guerriero può usare la sua reazione e spendere un dado di superiorità per ridurre i danni del numero ottenuto con il tiro del suo dado di superiorità + il suo modificatore di Destrezza.\n\n---\n\n**REPLICA**:\nQuando una creatura manca il guerriero con un attacco in mischia, il guerriero può usare la sua reazione e spendere un dado di superiorità per effettuare un attacco con un\'arma da mischia contro la creatura.\nSe la colpisce, aggiunge il dado di superiorità al tiro per i danni dell\'attacco.\n\n---\n\n**SCARTO** **ELUSIVO**:\nQuando il guerriero si muove, può spendere un dado di superiorità, tirarlo e aggiungere il risultato ottenuto alla sua **CA** finché non smette di muoversi.\n'),
  assassino('Assassino',
      '**COMPETENZE** **BONUS**\nQuando un ladro sceglie questo archetipo al 3° livello, ottiene competenza nei trucchi per il camuffamento e nelle sostanze da avvelenatore.\n\n---\n\n**ASSASSINARE**\nA partire dal 3° livello, il ladro risulta particolarmente letale quando coglie i propri nemici alla sprovvista e dispone di vantaggio ai tiri per colpire contro qualsiasi creatura che non abbia ancora effettuato un turno in combattimento.\nInoltre, ogni colpo da lui messo a segno contro una creatura sorpresa è considerato un colpo critico.\n\n---\n\n**MAESTRO** **INFILTRATO**\nA partire dal 9° livello, il ladro può creare infallibilmente delle identità fittizie per se stesso.\nDeve utilizzare sette giorni e 25 mo per stabilire la storia, la progressione e le affiliazioni dell\'identità in questione.\nNon può stabilire un\'identità che appartiene a qualcun altro.\nPotrebbe per esempio procurarsi degli abiti adeguati, una lettera di presentazione e un certificato apparentemente legittimo per spacciarsi per un membro di un casato mercantile di una remota città, in modo da potersi insinuare nella cerchia delle frequentazioni di altri ricchi mercanti.\nDa allora in poi, quando il ladro adotta la nuova identità come travestimento, le altre creature lo riterranno quella persona finché il ladro non offrirà loro dei motivi validi per dubitare di lui.\n\n---\n\n**IMPOSTORE**\nAl 13° livello, un ladro ottiene la capacità di imitare infallibilmente la parlata, la calligrafia e il modo di fare di un\'altra persona.\nIl ladro deve trascorrere almeno tre ore a studiare queste tre componenti comportamentali del soggetto, ascoltandolo parlare, studiando la sua calligrafia e osservandone i modi di fare.\nL\'inganno del ladro è impossibile da discernere per un osservatore casuale.\nSe una creatura sospettosa ha ragione di credere che ci sia qualcosa che non va, il ladro dispone di vantaggio a qualsiasi prova di Carisma (Inganno) da lui effettuata per evitare di essere scoperto.\n\n---\n\n**COLPO** **MORTALE**\nA partire dal 17° livello, il ladro diventa un maestro nell\'impartire la morte istantaneamente.\nQuando attacca e colpisce una creatura sorpresa, quella creatura deve effettuare un tiro salvezza su Costituzione (**CD** 8 + il modificatore di Destrezza del ladro + il bonus di competenza del ladro).\nSe lo fallisce, il ladro raddoppia i danni del suo attacco contro di essa.\n'),
  furfante('Furfante',
      '**MANI** **VELOCI**\nA partire dal 3° livello, un ladro può usare razione bonus conferitagli da Azione Scaltra per effettuare una prova di Destrezza (Rapidità di Mano), usare i propri arnesi da scasso per disattivare una trappola o scassinare una serratura, o effettuare un\'azione di Usare un Oggetto.\n\n---\n\n**LAVORO** **AL** **SECONDO** **PIANO**\nQuando un ladro sceglie questo archetipo al 3° livello, diventa in grado di scalare più velocemente rispetto al normale; scalare non gli richiede più un movimento extra.\nInoltre, quando il ladro effettua un salto in lungo con rincorsa, la distanza che copre aumenta di 30 cm per ogni punto del suo modificatore di Destrezza.\n\nFURTIVITÀ **SUPREMA**\nA partire dal 9° livello, un ladro dispone di vantaggio a una prova di Destrezza {Furtività) se si muove di non più della metà della sua velocità in quello stesso turno.\n\n---\n\n**USARE** **OGGETTO** **MAGICO**\nGiunto al 13° livello, un ladro ha imparato come funziona la magia quanto basta da improvvisare un utilizzo di questi oggetti che non sono destinati a lui.\nIl ladro ignora tutti 1 requisiti di classe, razza e livello quando usa gli oggetti magici.\n\n---\n\n**RIFLESSI** **DA** **FURFANTE**\nUna volta giunto al 17° livello, un ladro diventa articolarmente abile nel tendere imboscate e nello sfuggire rapidamente ai pericoli.\nIl ladro può effettuare due turni durante il primo round di ogni combattimento.\nEffettua il suo primo turno alla sua normale iniziativa e il secondo turno alla sua iniziativa meno 10.\nNon può utilizzare questo privilegio se è sorpreso.\n'),
  mistificatoreArcano('Mistificatore arcano',
      '**INCANTESIMI**\nQuando arriva al 3° livello, il ladro ottiene la capacità di lanciare incantesimi da mago.\n\n---\n\n**TRUCCHETTI**\nUn ladro apprende tre trucchetti: mano magica e altri due trucchetti a sua scelta tratti dalla lista degli incantesimi da mago.\nApprende un trucchetto da mago aggiuntivo a sua scelta al 10° livello.\n\n---\n\n**SLOT** **INCANTESIMO**\nLa tabella "Incantesimi del Mistificatore Arcano" indica quanti slot incantesimo possiede un ladro per lanciare i suoi incantesimi di 1° livello e di livello superiore.\nPer lanciare uno di questi incantesimi, il ladro deve spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nIl ladro recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nPer esempio, se un ladro conosce l\'incantesimo di 1° livello charme su persone e possiede uno slot incantesimo di 1° livello e uno slot incantesimo di 2° livello, può lanciare charme su persone usando uno qualsiasi dei due slot.\n\n---\n\n**INCANTESIMI** **CONOSCIUTI** **DI** 1° **LIVELLO** E **DI** **LIVELLO** **SUPERIORE**\nUn ladro conosce tre incantesimi da mago di 1° Livello a sua scelta, due dei quali devono essere scelti tra gli incantesimi di ammaliamento e illusione sulla lista degli incantesimi da mago.\nLa colonna "incantesimi Conosciuti" nella tabella "Incantesimi del Mistificatore Arcano" indica quando un ladro impara altri incantesimi da mago di 1° livello o di livello superiore.\nOgnuno di questi incantesimi deve essere un incantesimo di ammaliamento o di illusione a scelta del ladro e deve appartenere a un livello di cui il ladro possiede degli slot incantesimo.\nPer esempio, quando un ladro arriva al 7° livello in questa classe, può apprendere un nuovo incantesimo di 1° o di 2° livello.\nGli incantesimi che apprende all\'8°, 14° o 20° livello possono appartenere a qualsiasi scuola di magia.\nOgni volta che il ladro acquisisce un livello, può sostituire uno degli incantesimi da mago che conosce con un altro incantesimo a sua scelta della lista degli incantesimi da mago.\nIl nuovo incantesimo deve essere di un livello di cui il ladro possiede almeno uno slot incantesimo e deve essere un incantesimo di ammaliamento o di illusione, a meno che non stia sostituendo l\'incantesimo ottenuto all\'8°, 14° o 20° livello di una qualsiasi scuola di magia.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nIntelligenza è la caratteristica da incantatore per gli incantesimi da mago del ladro, dal momento che egli apprende i suoi incantesimi tramite lo studio costante e la memorizzazione.\nIl ladro usa Intelligenza ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Intelligenza per definire la **CD** del tiro salvezza di un incantesimo da mago da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro safvezza dell\'incantesimo= 8 + il bonus di competenza del ladro + il modificatore di Intelligenza del ladro\nModificatore di attacco dell\'incantesimo= Il bonus di competenza del ladro + il modificatore di Intelligenza del ladro\n\n---\n\n**GIOCO** **DI** **PRESTIGIO** **DELLA** **MANO** **MAGICA**\nA partire dal 3° livello, quando il ladro lancia mano magica, può rendere la mano spettrale invisibile e può farle svolgere i seguenti compiti aggiuntivi:\n- Riporre un oggetto impugnato dalla mano in un contenitore indossato o trasportato da un\'altra creatura.\n- Recuperare un oggetto in un contenitore Indossato o trasportato da un\'altra creatura.\n- Usare gli arnesi da scasso del ladro per scassinare serrature e disattivare trappole a distanza.\nIl ladro può svolgere uno di questi compiti senza essere notato da una creatura se effettua con successo una prova di Destrezza (Rapidità di Mano) contrapposta a una prova di Saggezza (Percezione) della creatura.\nIl ladro può inoltre usare l\'azione bonus conferitagli da Azione Scaltra per controllare la mano.\n\n---\n\n**IMBOSCATA** **MAGICA**\nA partire dal 9° 1ivello, se il ladro è nascosto da una creatura quando lancia un incantesimo su di essa, quella creatura subisce svantaggio a ogni tiro salvezza che effettua contro quell\'incantesimo in quel turno.\n\n---\n\n**INGANNATORE** **VERSATILE**\nAl 13° livello, il ladro sviluppa la capacità di distrarre i bersagli grazie alla sua mano magica.\nCome azione bonus nel suo turno, può designare una creatura entro 1,5 metri dalla mano spettrale creata dall\'incantesimo.\nCosì facendo dispone di vantaggio ai tiri per colpire contro quella creatura fino alla fine del turno.\n\n---\n\n**LADRO** **DI** **INCANTESIMI**\nAl 17° livello, il ladro ottiene la capacità di rubare magicamente a un altro incantatore le conoscenze richieste per lanciare un incantesimo.\nImmediatamente dopo che una creatura ha lanciato un incantesimo che bersaglia il ladro o lo include nella sua area di effetto, il ladro può usare la sua reazione per obbligare la creatura a effettuare un tiro salvezza con il modificatore della caratteristica da incantatore della creatura.\nLa **CD** è pari alla **CD** del tiro salvezza degli incantesimi del ladro.\nSe lo fallisce, il ladro nega l\'effetto dell\'incantesimo contro di lui e ruba la conoscenza dell\'incantesimo, se il livello di quell\'incantesimo è pari almeno al 1° ed è un livello che il ladro sia in grado di lanciare (non è necessario che si tratti di un incantesimo da mago).\nPer le 8 ore successive, il ladro conosce l\'incantesimo e può lanciarlo usando i propri slot incantesimo.\nLa creatura non può lanciare quell\'incantesimo finché le ore non sono trascorse.\nUna volta utilizzato questo privilegio, il ladro non può più utilizzarlo finché non completa un riposo lungo.\n'),
  abiurazione('Abiurazione',
      '**ABIURATORE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di abiurazione nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**INTERDIZIONE** **ARCANA**\nA partire dal 2° livello, il mago può intrecciare una trama magica intorno a sé per proteggersi.\nQuando lancia un incantesimo di abiurazione di livello pari o superiore al 1, il mago può utilizzare un filamento dell\'energia magica dell\'incantesimo per creare un\'interdizione magica che dura finché il mago non completa un riposo lungo.\nL\'interdizione possiede un numero di punti ferita pari al doppio del livello da mago + il modificatore di Intelligenza del mago.\nOgni volta che il mago subisce danni, è invece l\'interdizione a subire quei danni.\nSe questi danni riducono l\'interdizione a O punti ferita, il mago subisce gli eventuali danni rimanenti.\nQuando l\'interdizione ha O punti ferita, non può più assorbire danni, ma la sua magia permane.\nOgni volta che il mago lancia un incantesimo di abiurazione di livello pari o superiore al 1°, l\'interdizione riacquista un numero di punti ferita pari al doppio del livello dell\'incantesimo.\nUna volta creata l\'interdizione, il mago non può crearne un\'altra finché non completa un riposo lungo.\n\n---\n\n**INTERDIZIONE** **PROIETTATA**\nA partire dal 6° livello, quando una creatura situata entro 9 metri dal mago e che egli sia in grado di vedere subisce danni, il mago può usare la sua reazione per fare in modo che la sua Interdizione Arcana assorba quei danni.\nSe questi danni riducono l\'interdizione a O punti ferita, la creatura protetta subisce gli eventuali danni rimanenti.\n\n---\n\n**ABIURAZIONE** **MIGLIORATA**\nA partire dal 10° livello, quando lancia un incantesimo di abiurazione che richiede una prova di caratteristica come parte del lancio dell\'incantesimo stesso (come nel caso di controincantesimo o dissolvi magie), il mago può aggiungere il suo bonus di competenza a quella prova di caratteristica.\n\n---\n\n**RESISTENZA** **AGLI** **INCANTESIMI**\nA partire dal 14° livello, il mago dispone di vantaggio ai tiri salvezza contro incantesimi.\nDispone inoltre di resistenza ai danni degli incantesimi.'),
  ammaliamento('Ammaliamento',
      '**AMMALIATORE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di ammaliamento nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**SGUARDO** **IPNOTICO**\nA partire da quando il mago sceglie questa scuola al 2° livello, le sue parole suadenti e il suo sguardo ipnotico sono in grado di estasiare magicamente un\'altra creatura.\nCon un\'azione, il mago sceglie una creatura situata entro 1,5 metri e che egli sia in grado di vedere.\nSe il bersaglio è in grado di vedere e sentire il mago, deve superare un tiro salvezza su Saggezza contro la **CD** degli incantesimi del mago, altrimenti sarà affascinata dal mago fino alla fine del turno successivo di quest\'ultimo.\nLa velocità della creatura affascinata scende a O e la creatura è incapacitata e visibilmente frastornata.\nNei turni successivi il mago può usare la sua azione per mantenere questo effetto, estendendone la durata fino alla fine del suo turno successivo.\nTuttavia, l\'effetto termina se il mago si allontana a più di 1,5 metri dalla creatura, se la creatura non è più in grado di vederlo o di sentirlo o se la creatura subisce danni.\nUna volta terminato l\'effetto, o se la creatura ha superato il suo tiro salvezza iniziale contro questo effetto, il mago non può più utilizzare questo privilegio su quella stessa creatura finché non completa un riposo lungo.\n\n---\n\n**FASCINO** **ISTINTIVO**\nA partire dal 6° livello, quando una creatura situata entro 9 metri dal mago e che egli sia in grado di vedere effettua un tiro per colpire contro di lui, il mago può usare la sua reazione per deviare l\'attacco, purché un\'altra creatura si trovi entro la gittata dell\'attacco.\nL\'attaccante deve effettuare un tiro salvezza su Saggezza contro la **CD** degli incantesimi del mago.\nSe lo fallisce, l\'attaccante deve bersagliare la creatura a esso più vicina (escludendo il mago e se stesso).\nSe più creature sono egualmente distanti, l\'attaccante sceglie quale bersagliare.\nSe la creatura supera il tiro salvezza, il mago non può più utilizzare questo privilegio contro l\'attaccante finché non completa un riposo lungo.\nIl mago deve scegliere se utilizzare questo privilegio prima di sapere se l\'attacco colpirà o mancherà.\nLe creature che non possono essere affascinate sono immuni a questo effetto.\n\n---\n\n**AMMALIAMENTO** **CONDIVISO**\nA partire dal 10° livello, quando il mago lancia un incantesimo di ammaliamento di livello pari o superiore al 1° che bersagli una sola creatura, può farlo in modo chebersagli anche una seconda creatura.\n\n---\n\n**ALTERARE** **RICORDI**\nAl 14° livello, il mago ottiene la capacità di far dimenticare a una creatura di avere subito la sua influenza magica.\nQuando il mago lancia un incantesimo di ammaliamento per affascinare una o più creature, può alterare la percezione di una creatura in modo che resti inconsapevole di essere stata affascinata.\nInoltre, prima che l\'incantesimo termini, il mago può usare una volta la sua azione per tentare di far dimenticare alla creatura parte del tempo in cui è rimasta affascinata.\nLa creatura deve superare un tiro salvezza su Intelligenza contro la **CD** degli incantesimi del mago, altrimenti perderà un ammontare di ore di ricordi pari a 1 + il modificatore di Carisma del mago (fino a un minimo di 1).\nIl mago può far dimenticare alla creatura un ammontare di tempo inferiore, e l\'ammontare in questione non può superare la durata dell\'incantesimo di ammaliamento.'),
  divinazione('Divinazione',
      '**DIVINATORE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2 livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di divinazione nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**PORTENTO**\nA partire da quando sceglie questa scuota al 2° livello, il mago inizia a intravedere bagliori di futuro che si fanno strada a tratti nella sua coscienza.\nDopo avere completato un riposo lungo, il mago tira due d20 e annota i risultati ottenuti.\nPotrà sostituire un qualsiasi tiro per colpire, tiro salvezza o prova di caratteristica da lui effettuata con uno di quei risultati di preveggenza.\nDeve scegliere di farlo prima di effettuare il tiro e può sostituire un tiro in questo modo soltanto una volta per turno.\nOgni tiro di preveggenza può essere usato una volta sola.\nQuando il mago completa un riposo lungo, perde ogni eventuale tiro di preveggenza inutilizzato.\n\n---\n\n**DIVINAZIONE** **ESPERTA**\nA partire dal 6° livello, lanciare incantesimi di divinazione diventa talmente naturale per il mago da richiedergli soltanto uno sforzo minimale.\nQuando il mago lancia un incantesimo di divinazione di livello pari o superiore al 2°, recupera uno slot incantesimo già speso.\nLo slot recuperato deve essere di livello inferiore a quello dell\'incantesimo lanciato e non può essere di livello superiore al 5°.\n\n---\n\n**TERZO** **OCCHIO**\nA partire dat 10° livello, il mago può usare la sua azione per amplificare i suoi poteri di percezione.\nQuando lo fa, deve scegliere uno dei benefici seguenti, che permane finché il mago non diventa incapacitato o finché non completa un riposo breve o lungo.\nIl mago non può più utilizzare questo privilegio finché non completa un riposo.\n---\n\n**COMPRENSIONE** **SUPERIORE**: Il mago è in grado di leggere qualsiasi linguaggio.\n---\n\n**SCUROVISIONE**: Il mago ottiene scurovisione entro 18 metri, come descritto nel capitolo 8, "All\'Avventura".\n---\n\n**VEDERE** INVISIBILITà: Il mago è in grado di vedere le creature e gli oggetti invisibili entro 3 metri da lui e situati entro linea di vista.\n---\n\n**VISTA** **ETEREA**: **IL** mago può vedere sul Piano Etereo entro 18 metri.\n\n---\n\n**PORTENTO** **SUPERIORE**\nA partire dal 14° livello, Le visioni che affollano i sogni del mago si intensificano, e compongono nella sua mente un quadro più preciso di ciò che accadrà.\nQuando il mago utilizza il privilegio Portento, tira 3d20 anziché 2.\n'),
  evocazione('Evocazione',
      '**EVOCATORE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di evocazione nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**EVOCAZIONE** **MINORE**\nA partire da quando sceglie questa scuola al 2° livello, il mago può usare la sua azione per evocare un oggetto inanimato che compare nelle sue mani o a terra, in uno spazio libero situato entro 3 metri da lui e che egli sia in grado di vedere.\nQuesto oggetto non deve essere più lungo di 90 cm, non deve pesare più di 5 kg e deve avere la forma di un oggetto non magico che il mago abbia già visto.\nL\'oggetto è palesemente magico ed emana luce lioca entro 1,5 metri di distanza.\nL\'oggetto scompare dopo 1 ora, quando il mago utilizza di nuovo questo privilegio o se l\'oggetto stesso subisce qualsiasi danno.\n\n---\n\n**TRASPOSIZIONE** **BENEVOLA**\nA partire dal 6° livello, il mago può usare la sua azione per teletrasportarsi lino a 9 metri di distanza in uno spazio libero che egli sia in grado di vedere.\nIn alternativa può scegliere uno spazio entro gittata che sia occupato da una creatura Piccola o Media.\nSe quella creatura è consenziente, sia il mago che la creatura si teletrasportano, scambiandosi di posto.\nUna volta utilizzato questo privilegio, il mago non può più utilizzarlo finché non completa un riposo lungo o finché non lancia un incantesimo di evocazione di livello pari o superiore al 1°.\n\n---\n\n**EVOCAZIONE** **FOCALIZZATA**\nA partire dal 10° livello, quando il mago si concentra su un incantesimo di evocazione, la sua concentrazione non può più essere interrotta dai danni che subisce.\n\n---\n\n**EVOCAZIONI** **PERDURANTI**\nA partire dal 14° livello, le creature evocate o create dal mago con un incantesimo di evocazione possiedono 30 punti vita temporanei.\n'),
  illusione('Illusione',
      '**ILLUSIONISTA** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di illusione nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**ILLUSIONE** **MINORE** **MIGLIORATA**\nA partire da quando sceglie questa scuola al 2° livello, il mago apprende il trucchetto illusione minore.\nSe già conosceva questo trucchetto, apprende un diverso trucchetto da mago a sua scelta.\nIl trucchetto non conta al fine di determinare il numero di trucchetti conosciuti dal mago.\nQuando il mago lancia illusione minare, può creare sia un suono che un\'immagine con un singolo lancio dell\'incantesimo.\n\n---\n\n**ILLUSIONI** **DUTTILI**\nA partire dal 6° livello, quando lancia un incantesimo con una durata pari o superiore a 1 minuto, il mago può usare la propria azione per cambiare la natura dell\'illusione creata (rispettando i limiti dei normali parametri dell\'incantesimo), purché sia in grado di vedere l\'illusione.\n\n---\n\n**SOSIA** **ILLUSORIO**\nA partire dal 10° livello, il mago può creare un duplicato illusorio di se stesso come reazione istantanea al pericolo.\nQuando una creatura effettua un attacco contro di lui, il mago può usare la sua reazione per frapporre il sosia illusorio tra sé e l\'attaccante.\nL\'attacco manca il mago automaticamente e l\'illusione svanisce.\nUna volta utilizzato questo privilegio, il mago non può più utilizzarlo finché non completa un riposo breve o lungo.\n\nREALTÀ **ILLUSORIA**\nGiunto al 14° livello, il mago ha imparato a intessere la magia dell\'ombra per impartire alle sue illusioni una parvenza di realtà.\nQuando lancia un incantesimo di illusione di livello pari o superiore al 1°, può scegliere un oggetto inanimato non magico che sia parte dell\'illusione e rendere quell\'oggetto reale.\nPuò farlo nel suo turno con un\'azione bonus finché l\'incantesimo è attivo.\nL\'oggetto resta reale per 1 minuto.\nPer esempio, il mago può creare l\'illusione di un ponte che attraversa un baratro e renderla reale quanto basta da consentire ai suoi alleati di attraversarlo.\nL\'oggetto non può infliggere danni o ferire in modo diretto.\n'),
  invocazione('Invocazione',
      '**INVOCATORE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di invocazione nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**PLASMARE** **INCANTESIMI**\nA partire dal 2° tivello, il mago è in grado di creare delle sacche di relativa sicurezza all\'interno degli effetti dei suoi incantesimi di invocazione.\nQuando il mago lancia un incantesimo di invocazione che influenza le altre creature che è in grado di vedere, può scegliere un numero di quelle creature pari a 1 + il livello dell1ncantesimo.\nLe creature scelte superano automaticamente i loro tiri salvezza contro l\'incantesimo e non subiscono alcun danno se normalmente subirebbero la metà dei danni in caso di tiro salvezza superato.\n\n---\n\n**TRUCCHETTO** **POTENTE**\nA partire dal 6° livello, i trucchetti del mago che infliggono danni possono influenzare perfino le creature che altrimenti eviterebbero il grosso dell\'effetto.\nQuando una creatura supera un tiro salvezza contro un trucchetto del mago, quella creatura subisce la metà dei danni del trucchetto (se previsti), ma non subisce alcun effetto aggiuntivo da quel trucchetto.\n\n---\n\n**INVOCAZIONE** **POTENTE**\nA partire dal 10° livello, il mago può aggiungere il suo modificatore di Intelligenza a un tiro per i danni di un qualsiasi incantesimo di invocazione da mago da lui lanciato.\n\n---\n\n**SATURAZIONE** **MAGICA**\nA partire dal 14° livello, il mago può intensificare il potere dei suoi incantesimi più semplici.\nQuando lancia un incantesimo da mago compreso tra il 1° e il 5° livello e che infligga danni, può infliggere il massimo dei danni con quell\'incantesimo.\nLa prima volta che il mago lo fa, non subisce alcun effetto avverso.\nSe però utilizza questo privilegio di nuovo prima di avere completato un riposo lungo, subisce 2d12 danni necrotici per ogni livello dell\'incantesimo in questione, subito dopo averlo lanciato.\nOgni volta che utilizza di nuovo questo privilegio prima di avere completato un riposo lungo, i danni necrotici per livello dell\'incantesimo aumentano di 1d12.\nQuesti danni ignorano le varie forme di resistenza e immunità.'),
  necromanzia('Necromanzia',
      '**NECROMANTE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di necromanzia nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**RACCOLTO** **MACABRO**\nAl 2° livello, il mago sviluppa la capacità di raccogliere l\'energia vitale delle creature uccise dai suoi incantesimi.\nUna volta per turno, quando uccide una o più creature con un incantesimo di livello pari o superiore al 1°, il mago recupera un ammontare di punti ferita pari al doppio del livello dell\'incantesimo, o al triplo del livello se l\'incantesimo appartiene alla Scuola di Necromanzia.\nNon ottiene questo beneficio se uccide dei costrutti o dei non morti.\n\n---\n\n**SERVITORI** **NON** **MORTI**\nAl 6° livello, il mago aggiunge l\'incantesimo animare morti al suo libro degli incantesimi, se non lo possedeva già.\nQuando lancia animare morti, può bersagliare un cadavere o un cumulo di ossa aggiuntivo per creare un altro scheletro o zombi, come appropriato.\nOgni volta che il mago crea un non morto usando un incantesimo di necromanzia, quella creatura ottiene i benefici seguenti:\n- Il massimo dei punti ferita della creatura aumenta di un ammontare pari al livello del mago.\n- La creatura aggiunge il bonus di competenza del mago ai suoi tiri per i danni con le armi.\n\n---\n\n**IMPERVIO** **ALLA** **NON** **MORTE**\nA partire dal 10° livello, il mago dispone di resistenza ai danni necrotici e il suo massimo dei punti ferita non può essere ridotto.\nIl mago ha trascorso tanto tempo a occuparsi dei non morti e delle forze che li animano che è diventato impervio ad alcuni dei loro effetti peggiori.\n\n---\n\n**COMANDARE** **NON** **MORTI**\nA partire dal 14° livello, il mago può usare la magia per condurre sotto il suo controllo anche i non morti creati da altri maghi.\nCon un\'azione può scegliere un non morto situato entro 18 metri da lui e che egli sia in grado di vedere.\nQuella creatura deve superare un tiro salvezza su Carisma contro la **CD** degli incantesimi del mago.\nSe lo supera, il mago non può più utilizzare questo privilegio contro di lei.\nSe lo fallisce, la creatura diventa amichevole nei confronti del mago e obbedisce ai suoi comandi finché il mago non utilizza di nuovo questo privilegio.\nI non morti intelligenti sono più difficili da controllare in questo modo.\nSe il bersaglio possiede un\'Intelligenza pari o superiore a 8, dispone di vantaggio al tiro salvezza.\nSe fallisce il tiro salvezza e possiede un\'Intelligenza pari o superiorea 12, può ripetere il tiro salvezza alla fine di ogni ora, finché non lo supera e si libera.'),
  trasmutazione('Trasmutazione',
      '**TRASMUTATORE** **SAPIENTE**\nA partire da quando il mago sceglie questa scuola al 2° livello, il tempo e il denaro che egli deve spendere per copiare un incantesimo di trasmutazione nel suo libro degli incantesimi sono dimezzati.\n\n---\n\n**ALCHIMIA** **MINORE**\nA partire da quando sceglie questa scuola al 2° livello, il mago può alterare temporaneamente le proprietà fisiche di un oggetto non magico, trasformandolo da una sostanza all\'altra.\nIl mago applica una procedura alchemica speciale a un oggetto composto interamente di legno, pietra (ma non gemme), ferro, rame o argento, trasformandolo in un oggetto diverso fatto di quei materiali.\nOgni 10 minuti trascorsi ad applicare la procedura gli consentono di trasformare materiale pari a un cubo con spigolo di 30 cm.\nDopo 1 ora, o finché il mago non perde la concentrazione (come se si stesse concentrando su un incantesimo), il materiale si ritrasforma nella sua sostanza originale.\n\n---\n\n**PIETRA** **DEL** **TRASMUTATORE**\nA partire dal 6° livello, il mago può trascorrere 8 ore a creare una pietra del trasmutatore che accumuli la magia di trasmutazione.\nIl mago può beneficiare della pietra personalmente o cederla a un\'altra creatura.\nUna creatura ottiene un beneficio a scelta del mago fintanto che la pietra resta in suo possesso.\nQuando il mago crea la pietra, sceglie il beneficio tra le opzioni seguenti:\n- Scurovisione entro 18 metri, come descritto nel capitolo 8, "All\'Avventura"\n- Un aumento della velocità di 3 metri fintanto che la creatura è priva di ingombro.\n- Competenza nei tiri salvezza su Costituzione.\n- Resistenza ai danni da acido, freddo, fulmine, fuoco o tuono (a scelta del mago al momento di determinare questo beneficio).\nOgni volta che il mago lancia un incantesimo di trasmutazione di livello pari o superiore al 1°, può cambiare l\'effetto della pietra, se la pietra si trova sulla sua persona.\nSe il mago crea una nuova pietra del trasmutatore, quella precedente cessa di funzionare.\n\n---\n\n**MUTAFORMA**\nAl 10° livello, il mago aggiunge l\'incantesimo metamorfosi al suo libro degli incantesimi, se non lo possedeva già.\nPuò lanciare metamorfosi senza spendere uno slot incantesimo.\nQuando lo fa, può bersagliare solo se stesso e trasformarsi in una bestia il cui grado di sfida sia pari o inferiore a 1.\nUna volta lanciato metamorfosi in questo modo, il mago non può più farlo di nuovo finché non completa un riposo breve o lungo, ma può comunque lanciarlo normalmente usando uno slot incantesimo disponibile.\n\n---\n\n**MAESTRO** **TRASMUTATORE**\nA partire dal 14° livello, il mago può usare la sua azione per consumare la riserva di magia di trasmutazione accumulata all\'interno della sua pietra del trasmutatore in un\'unica soluzione.\nQuando lo fa, sceglie uno degli effetti seguenti.\nLa sua pietra del trasmutatore si distrugge e non può essere ricreata finché il mago non completa un riposo lungo.\n---\n\n**PANACEA**: Il mago rimuove tutte le maledizioni, malattie e veleni che influenzano una creatura da lui toccata con la pietra del trasmutatore. La creatura recupera anche tutti i suoi punti ferita.\n---\n\n**RIPRISTINARE** **GIOVINEZZA**: Il mago tocca una creatura consenziente con la pietra del trasmutatore e l\'età apparente di quella creatura è ridotta di 3d10 anni, fino a un minimo di 13 anni.\nQuesto effetto non prolunga l\'arco vitale della creatura.\n---\n\n**RIPRISTINARE** **VITA**: Il mago lancia l\'incantesimo rianimare morti su una creatura da lui toccata con la pietra del trasmutatore, senza spendere uno slot incantesimo e senza che debba possedere l\'incantesimo nel suo libro degli incantesimi.\n---\n\n**TRASFORMAZIONE** **MAGGIORE**: Il mago può trasmutare un oggetto non magico (che non sia più grande di un cubo con spigolo di 1,5 metri) in un altro oggetto non magico di taglia e massa analoga e di valore pari o inferiore.\nDeve trascorrere 10 minuti a maneggiare l\'oggetto che intende trasformare.'),
  camminoDelBerserker('Cammino del berserker',
      '**FRENESIA**\nA partire da quando sceglie questo cammino al 3° livello, il barbaro può entrare in frenesia quando entra in ira.\nSe lo fa, per la durata della sua ira può effettuare un singolo attacco con un\'arma da mischia come azione bonus in ognuno dei suoi turni successivi dopo di questo.\nQuando la sua ira termina, il barbaro subisce un livello di indebolimento.\n\n---\n\n**IRA** **INCONTENIBILE**\nA partire dal 6° livello, il barbaro non può essere affascinato o spaventato mentre è in ira.\nSe è affascinato o spaventato quando entra in ira, quell\'effetto è sospeso per tutta la durata dell\'ira.\n\n---\n\n**PRESENZA** **INTIMIDATORIA**\nA partire dal 10° livello, il barbaro può usare la sua azione per spaventare qualcuno con la sua presenza minacciosa.\nQuando lo fa, sceglie una creatura che egli sia in grado di vedere entro 9 metri.\nSe la creatura può vedere o sentire il barbaro, deve superare un **TS** di Saggezza (**CD** pari a 8 + il bonus di competenza del barbaro + il modificatore di Carisma del Barbaro), altrimenti sarà spaventata dal barbaro fino alla fine del turno successivo di quest\'ultimo.\nNei turni successivi, il barbaro può usare la sua azione per estendere la durata di questo effetto sulla creatura spaventata fino alla fine del proprio turno successivo.\nQuesto effetto si esaurisce se la creatura termina il suo turno fuori dalla linea di vista o oltre 18 metri di distanza dal barbaro.\nSe la creatura riesce il suo tiro salvezza, il barbaro non può più usare questo privilegio su quella creatura per 24 ore.\n\n---\n\n**RITORSIONE**\nA partire dal 14° livello, quando il barbaro subisce danni da una creatura che si trova entro 1,5 metri da lui, può usare la sua reazione per effettuare un attacco con un\'arma da mischia contro quella creatura.'),
  camminoDelCombattenteTotemico('Cammino del combattente totemico',
      'nCERCATORE **DI** **SPIRITI**\nIl cammino del barbaro è un cammino in sintonia con il mondo naturale, destinato ad accentuare la sua affinità con le bestie.\nAl 3° livello, quando il barbaro adotta questo cammino, ottiene la capacità di lanciare gli incantesimi percezione delle bestie e parlare con gli animali, ma solo come rituali, come descritto nel capitolo 10, "Magia".\n\n---\n\n**SPIRITO** **TOTEMICO**\nAl 3° livello, quando adotta questo cammino, il barbaro sceglie uno spirito totemico e ne ottiene il relativo privilegio.\nDeve fabbricare o acquisire un oggetto fisico che funga per lui da totem, come un amuleto o un monile simile, che includa pelliccia, piume, artigli, denti o ossa di un animale totemico.\nA sua opzione, potrebbe sviluppare anche degli attributi fisici minori che richiamino il suo spirito totemico.\nPer esempio, un barbaro che abbia un orso come spirito totemico potrebbe avere barba e capelli molto folti e una pelle molto dura; uno che abbia un\'aquila come totem potrebbe avere gli occhi di color giallo chiaro.\nUn animale totemico potrebbe essere un animale correlato a quelli elencati di seguito, ma più appropriato alle terre di provenienza del barbaro.\nPer esempio, un barbaro potrebbe scegliere un falco o un avvoltoio al posto di un\'aquila.\n-Aquila: Finché il barbaro è in ira e non indossa un\'armatura pesante, le altre creature dispongono di svantaggio ai tiri degli attacchi di opportunità contro di lui, e il barbaro può usare l\'azione di Scatto come azione bonus nel suo turno.\nLo spirito dell\'aquila trasforma il barbaro in un predatore che può sgusciare agilmente in mezzo a una mischia.\n-Lupo: Finché il barbaro è in ira, i suoi amici dispongono di vantaggio ai tiri per colpire in mischia contro ogni creatura che si trovi entro 1,5 metri da lui e che gli sia ostile.\nLo spirito del lupo trasforma il barbaro in un capobranco di cacciatori.\n-Orso: Quando il barbaro è in ira, ottiene resistenza a tutti i danni tranne che a quelli psichici.\nLo spirito dell\'orso lo rende abbastanza robusto da sopportare qualsiasi aggressione.\n\n---\n\n**ASPETTO** **DELLA** **BESTIA**\nAl 6° livello, il barbaro ottiene un beneficio magico basato su un animale totemico di sua scelta.\nPuò scegliere lo stesso animale che ha scelto al 3° livello o un animale diverso.\n-Aquila: Il barbaro ottiene la vista di un\'aquila.\nPuò vedere fino a 1,5 km di distanza senza difficoltà e discernere i dettagli come se osservasse qualcosa entro 30 metri da lui.\nInoltre, la luce fioca non impone svantaggio alle sue prove di Saggezza (Percezione).\n-Lupo: Il barbaro ottiene gli istinti cacciatori di un lupo.\nPuò seguire le tracce delle altre creature mentre viaggia a passo veloce e può muoversi furtivamente mentre viaggia a passo normale (vedi il Capitolo 8, "All\'Avventura", per le regole relative al passo di viaggio).\n-Orso: Il barbaro ottiene la potenza di un orso.\nLa sua capacità di trasporto (incluso il carico massimo e il sollevamento massimo) raddoppia e il barbaro dispone di vantaggio alle prove di Forza effettuate per spingere, trascinare, sollevare o spezzare oggetti.\n\n---\n\n**VIANDANTE** **SPIRITUALE**\nAl 10° livello, il barbaro può lanciare l\'incantesimo "comunione con la natura", ma solo come rituale.\nQuando lo fa, una versione spirituale di uno degli animali che ha scelto come Spirito Totemico o Aspetto della Bestia gli appare per fornirgli le informazioni che desidera.\n\n---\n\n**SINTONIA** **TOTEMICA**\nAl 14° livello, il barbaro ottiene un beneficio magico basato su un animale totemico di sua scelta.\nPuò scegliere lo stesso animale che ha scelto in precedenza o un animale diverso.\n-Aquila: Finché il barbaro è in ira, ha una velocità di volare pari alla sua attuale velocità base sul terreno.\nQuesto beneficio funziona soltanto per brevi tratti; se il barbaro termina il suo turno in aria e non c\'è nulla a sorreggerlo, cade a terra.\n-Lupo: Finché il barbaro è in ira, può usare un\'azione bonus nel suo turno per buttare a terra prona una creatura di taglia Grande o inferiore quando la colpisce con un attacco con un\'arma da mischia.\n-Orso: Finché il barbaro è in ira, ogni creatura entro 1,5 metri da lui e che gli sia ostile dispone di svantaggio ai tiri per colpire contro i bersagli diversi da lui o da un altro personaggio dotato di questo privilegio.\nUn nemico è immune a questo effetto se non è in grado di vedere o sentire il barbaro o se non può essere spaventato.'),
  dominioDellaConoscenza('Dominio della conoscenza',
      '**BENEDIZIONI** **DELLA** **CONOSCENZA**\nAl 1° livello, il chierico apprende due linguaggi a sua scelta.\nOttiene inoltre competenza in due delle seguenti abilità a sua scelta: Arcano, Natura, Religione o Storia.\nIl suo bonus di competenza raddoppia in ogni prova di caratteristica da lui effettuata usando una di queste abilità.\n\n---\n\n**INCANALARE** DIVINITÀ: **CONOSCENZE** **SECOLARI**\nA partire dal 2° livello, il chierico pub utilizzare Incanalare Divinità per attingere a un pozzo divino di conoscenza.\nCon un\'azione, può scegliere un\'abilità o uno strumento.\nPer 10 minuti ottiene competenza nell\'abilità o nello strumento scelto.\n\n---\n\n**INCANALARE** DIVINITÀ: **LETTURA** **DEL** **PENSIERO**\nAl 6° livello, il chierico può utilizzare Incanalare Divinità per leggere i pensieri di una creatura.\nPuò quindi usare il suo accesso alla mente della creatura per assumerne il comando.\nCon un\'azione, il chierico sceglie una creatura situata entro 18 metri da lui e che egli sia in grado di vedere.\nQuella creatura deve effettuare un tiro salvezza su Saggezza.\nSe lo supera, il chierico non può utilizzare questo privilegio su di essa finché egli non completa un riposo lungo.\nSe la creatura fallisce il suo tiro salvezza, il chierico pub leggere i suoi pensieri superficiali (quelli che tengono occupata la sua mente al momento, che riflettono le sue emozioni attuali e a cui la creatura sta pensando attivamente) quando essa si trova entro 18 metri da lui.\nQuesto effetto dura 1 minuto.\nDurante quel periodo, il chierico può usare la sua azione per porre fine a questo effetto e lanciare l\'incantesimo suggestione sulla creatura senza spendere uno slot incantesimo.\nIl bersaglio fallisce automaticamente il suo tiro salvezza contro l\'incantesimo.\n\n---\n\n**INCANTESIMI** **POTENTI**\nA partire dall\'8° livello, il chierico aggiunge il suo modificatore di Saggezza ai danni che infligge con qualsiasi trucchetto da chierico.\n\n---\n\n**VISIONI** **DEL** **PASSATO**\nA partire dal 17° livello, il chierico può evocare una visione del passato collegata a un oggetto che impugna o che si trova nelle sue immediate vicinanze.\nPer farlo deve spendere almeno 1 minuto in meditazione o in preghiera, poi riceverà una visione fugace, indistinta e sognante degli eventi recenti.\nIl chierico può meditare in questo modo per un numero di minuti pari al suo punteggio di Saggezza e deve mantenere la concentrazione durante quel periodo, come se stesse lanciando un incantesimo.\nUna volta utilizzato questo privilegio, il chierico non può più utilizzarlo finché non completa un riposo breve o lungo.\n-**LETTURE** **DEGLI** **OGGETTI**: Il chierico medita mentre impugna un oggetto e riceve una visione del suo precedente proprietario.\nDopo avere meditato per 1 minuto, apprende in che modo il proprietario ne è entrato in possesso e come lo ha perduto, nonché l\'evento recente più significativo che ha coinvolto l\'oggetto e quel proprietario.\nSe l\'oggetto è stato posseduto da un\'altra creatura nei tempi recenti (entro un numero di giorni pari al punteggio di Saggezza del chierico), il chierico può dedicare 1 minuto aggiuntivo per ogni proprietario per apprendere le stesse informazioni relative a quella creatura.\n- **LETTURA** **DELL**\'**AREA**: Il chierico medita e riceve una visione degli eventi recenti nelle sue immediate vicinanze (una camera, una strada, un tunnel, una radura e così via, entro un cubo con spigolo di 15 metri), risalendo nel passato fino a un numero di giorni pari al suo punteggio di Saggezza.\nPer ogni minuto in cui medita apprende un evento significativo, a partire dal più recente.\nPer eventi significativi solitamente si intendono quelli segnati da emozioni potenti, come battaglie, tradimenti, matrimoni, omicidi, nascite e funerali.\nTuttavia questo potrebbe anche includere eventi più comuni che risultino però importanti per il chierico nella sua situazione attuale.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              comando, identificare\n3°              presagio, suggestione\n5°              anti-individuazione,parlare con i morti\n7°              confusione, occhio arcano\n9°              conoscenza delle leggende, scrutare\n'),
  dominioDellaGuerra('Dominio della guerra',
      '**COMPETENZE** **BONUS**\nAl 1° livello, il chierico ottiene competenza nelle armi da guerra e nelle armature pesanti.\n\n---\n\n**SACERDOTE** **DI** **GUERRA**\nA partire dal 1° livello, il chierico riceve dal suo dio dei fugaci lampi di ispirazione quando è impegnato in battaglia.\nQuando usa l\'azione di Attacco, il chierico può effettuare un attacco con un\'arma come azione bonus.\nIl chierico può utilizzare questo privilegio un numero di volte pari al suo modificatore di Saggezza (fino a un minimo di una volta).\nRecupera tutti gli utilizzi spesi quando completa un riposo lungo.\n\n---\n\n**INCANALARE** DIVINITÀ: **COLPO** **GUIDATO**\nA partire dal 2° livello, il chierico può utilizzare Incanalare Divinità per impartire ai suoi colpi una precisione soprannaturale.\nQuando effettua un tiro per colpire, può utilizzare Incanalare Divinità per ottenere un bonus di +10 al tiro.\nIl chierico effettua questa scelta dopo avere visto il tiro, ma prima che il **DM** dichiari se l\'attacco colpisce o manca.\n\n---\n\n**INCANALARE** DIVINITÀ: **BENEDIZIONE** **DEL** **DIO** **DELLA** **GUERRA**\nAl 6° livello, quando una creatura entro 9 metri dal chierico effettua un tiro per colpire, il chierico può usare la sua reazione per conferire a quella creatura un bonus di +10 al tiro, utilizzando Incanalare Divinità.\nIl chierico fa questa scelta dopo avere visto il tiro, ma prima che il **DM** dichiari se l\'attacco colpisce o manca.\n\n---\n\n**COLPO** **DIVINO**\nAll\'8° livello, il chierico ottiene la capacità di infondere energia divina nei colpi della sua arma.\nUna volta per ogni suo turno, quando colpisce una creatura con un attacco con un\'arma, il chierico può fare in modo che l\'attacco infligga 1d8 danni extra dello stesso tipo di danni inferti dall\'arma al bersaglio.\nQuando il chierico arriva al 14° livello, i danni extra aumentano a 2d8.\n\n---\n\n**AVATAR** **DELLA** **BATTAGLIA**\nAl 17° livello, il chierico ottiene resistenza ai danni contundenti, perforanti e taglienti delle armi non magiche.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              favore divino, scudo della fede\n3°              arma magica, arma spirituale\n5°              guardiani spirituali, manto del crociato\n7°              libertà di movimento, pelle di pietra\n9°              blocca mostri, colpo infuocato\n'),
  dominioDellaLuce('Dominio della luce',
      '**TRUCCHETTO** **BONUS**\nQuando il chierico sceglie questo dominio al 1° livello, apprende il trucchetto luce, se già non lo possiede.\n\n---\n\n**LAMPO** **DI** **INTERDIZIONE**\nAl 1° livello, il chierico è anche in grado di erigere una barriera di luce divina tra sé e un nemico che lo sta attaccando.\nQuando il chierico è attaccato da una creatura situata entro 9 metri da lui e che egli sia in grado di vedere, può usare la sua reazione per infliggere svantaggio al tiro per colpire, facendo in modo che un lampo di luce confonda l\'attaccante prima che il suo colpo vada a segno o manchi.\nUn attaccante che non può essere accecato è immune a questo privilegio.\nIl chierico può utilizzare questo privilegio un numero di volte pari al suo modificatore di Saggezza (fino a un minimo di una volta).\nRecupera tutti gli utilizzi spesi quando completa un riposo lungo.\n\n---\n\n**INCANALARE** DIVINITÀ: **FULGORE** **DELL**\'**ALBA**\nA partire dal 2° livello, il chierico può utilizzare Incanalare Divinità per imbrigliare la luce del sole, esiliare l\'oscurità e infliggere danni radiosi ai suoi avversari.\nCon un\'azione, il chierico brandisce il simbolo sacro e ogni forma di oscurità magica entro 9 metri da lui è dissolta.\nInoltre, ogni creatura ostile situata entro 9 metri da lui deve effettuare un tiro salvezza su Costituzione.\nSe lo fallisce, subisce 2d10 + il livello da chierico danni radiosi, mentre se lo supera subisce soltanto la metà di quei danni.\nUna creatura che beneficia di copertura totale nei confronti del chierico non è influenzata da questo privilegio.\n\n---\n\n**LAMPO** **MIGLIORATO**\nA partire dal 6° livello, il chierico può utilizzare il suo Lampo di Interdizione quando una creatura situata entro 9 metri da lui e che egli sia in grado di vedere attacca una creatura diversa da lui.\n\n---\n\n**INCANTESIMI** **POTENTI**\nA partire dall\'8° livello, il chierico aggiunge il suo modificatore di Saggezza ai danni che infligge con qualsiasi trucchetto da chierico.\n\n---\n\n**CORONA** **DI** **LUCE**\nA partire dal 11° livello, il chierico può usare la sua azione per attivare un\'aura di luce solare che dura 1 minuto o finché il chierico non la congeda usando un\'altra azione.\nIl chierico emette luce intensa entro un raggio di 18 metri e luce fioca per ulteriori 9 metri.\nI nemici che si trovano entro il raggio di luce intensa subiscono svantaggio ai tiri salvezza contro qualsiasi incantesimo che infligga danni da fuoco o radiosi.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              luminescenza, mani brucianti\n3°              raggio rovente, sfera infuocata\n5°              luce diurna, palla di fuoco\n7°              guardiano della fede, muro di fuoco\n9°              colpo infuocato, scrutare\n'),
  dominioDellaNatura('Dominio della natura',
      '**ACCOLITO** **DELLA** **NATURA**\nAl 1° livello, il chierico apprende un trucchetto da druido a sua scelta.\nOttiene inoltre competenza in una delle seguenti abilità a sua scelta: Addestrare Animali, Natura o Sopravvivenza.\n\n---\n\n**COMPETENZA** **BONUS**\nAl 1° livello, il chierico ottiene competenza nelle armature pesanti.\n\n---\n\n**INCANALARE** DIVINITÀ: **CHARME** **SU** **ANIMALI** E **VEGETALI**\nA partire dal 2° livello, il chierico può utilizzare Incanalare Divinità per affascinare animali e vegetali.\nCon un\'azione, il chierico brandisce il suo simbolo sacro e invoca il nome della sua divinità.\nOgni bestia o creatura vegetale in grado di vedere il chierico e situata entro 9 metri da lui deve effettuare un tiro salvezza su Saggezza.\nSe lo fallisce, è affascinata dal chierico per 1 minuto o finché non subisce danni.\nFinché è affascinata, la creatura è considerata amichevole nei confronti del chierico e delle altre creature da lui designate.\n\n---\n\n**MITIGARE** **ELEMENTI**\nA partire dal 6° livello, quando il chierico o una creatura entro 9 metri da lui subisce danni da acido, freddo, fulmine, fuoco o tuono, egli può usare la sua reazione per conferire a se stesso o a quella creatura resistenza a quel tipo di danni.\n\n---\n\n**COLPO** **DIVINO**\nAll\'8° livello, il chierico ottiene la capacità di infondere energia divina nei colpi della sua arma.\nUna volta per ogni suo turno, quando colpisce una creatura con un attacco con un\'arma, il chierico può fare in modo che l\'attacco infligga 1d8 danni extra da freddo, fulmine o fuoco (a sua scelta) al bersaglio.\nQuando il chierico arriva al 14° livello, i danni extra aumentano a 2d8.\n\n---\n\n**MAESTRO** **DELLA** **NATURA**\nAl 17° livello, il chierico ottiene la capacità di comandare gli animali e le creature vegetali.\nQuando le creature sono affascinate dal chierico tramite il suo privilegio Charme su Animali e Vegetali, il chierico può effettuare un\'azione bonus nel suo turno per comandare verbalmente ognuna di quelle creature, decidendo ciò che faranno nel loro turno successivo.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              amicizia con gli animali, parlare con gli animali\n3°              crescita di spine, pelle coriacea\n5°              crescita vegetale, muro di vento\n7°              dominare bestie, rampicante afferrante\n9°              piaga degli insetti, traslazione arborea\n'),
  dominioDellaTempesta('Dominio della tempesta',
      '**COMPETENZE** **BONUS**\nAl 1° livello, il chierico ottiene competenza nelle armi da guerra e nelle armature pesanti.\n\n---\n\n**COLLERA** **DELLA** **TEMPESTA**\nAl 1° livello, il chierico impara a intimorire gli attaccanti con la potenza del tuono.\nQuando il chierico è colpito dall\'attacco di una creatura situata entro 1,5 metri da lui e che egli sia in grado di vedere, può usare la sua reazione per obbligare la creatura a effettuare un tiro salvezza su Destrezza.\nSe lo fallisce, subisce 2d8 danni da fulmine o da tuono (a scelta del chierico), mentre se lo supera subisce soltanto la metà di quei danni.\nIl chierico può utilizzare questo privilegio un numero di volte pari al suo modificatore di Saggezza (fino a un minimo di una volta).\nRecupera tutti gli utilizzi spesi quando completa un riposo lungo.\n\n---\n\n**INCANALARE** DIVINITÀ: **COLLERA** **DISTRUTTIVA**\nA partire dal 2° livello, il chierico può utilizzare Incanalare Divinità per esercitare il potere della tempesta con ferocia incontrollata.\nQuando il chierico tira per infliggere danni da fulmine o da tuono, può utilizzare Incanalare Divinità per infliggere il massimo dei danni anziché tirarli.\n\n---\n\n**COLPO** **DEL** **TUONO** E **DEL** **FULMINE**\nAl 6° livello, quando il chierico infligge danni da fulmine a una creatura di taglia Grande o inferiore, può anche spingere quella creatura fino a 3 metri, allontanandola da sé.\n\n---\n\n**COLPO** **DIVINO**\nAll\'8° livello, il chierico ottiene la capacità di infondere energia divina nei colpi della sua arma.\nUna volta per ogni suo turno, quando colpisce una creatura con un attacco con un\'arma, il chierico può fare in modo che l\'attacco infligga 1d8 danni da tuono extra al bersaglio.\nQuando il chierico arriva al 14° livello, i danni extra aumentano a 2d8.\n\n---\n\n**NATO** **DALLA** **TEMPESTA**\nAl 17 livello, il chierico ottiene una velocità di volare pari alla sua attuale velocità base sul terreno ogni volta che non si trova sottoterra o al chiuso.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              nube di nebbia, onda tonante\n3°              folata di vento, frantumare\n5°              invocare il fulmine, tempesta di vischio\n7°              controllare acqua, tempesta di ghiaccio\n9°              onda distruttiva, piaga degli insetti\n'),
  dominioDellaVita('Dominio della vita',
      '**COMPETENZA** **BONUS**\nQuando il chierico sceglie questo dominio al 1° livello, ottiene competenza nelle armature pesanti.\n\n---\n\n**DISCEPOLO** **DELLA** **VITA**\nA partire dal 1° livello, gli incantesimi di guarigione del chierico diventano più efficaci.\nOgni volta che il chierico usa un incantesimo di 1° livello o di livello superiore per ripristinare i punti ferita di una creatura, quella creatura recupera un ammontare di punti ferita aggiuntivi pari a 2 + il livello dell\'incantesimo.\n\n---\n\n**INCANALARE** DIVINITÀ: **PRESERVARE** **VITA**\nA partire dal 2° livello, il chierico può utilizzare Incanalare Divinità per curare chi è stato gravemente ferito.\nCon un\'azione, il chierico brandisce il suo simbolo sacro ed evoca un flusso di energia curativa che può ripristinare un numero di punti ferita pari a cinque volte il suo livello da chierico.\nSceglie le creature desiderate purché siano situate entro 9 metri da lui e suddivide questo ammontare di punti ferita tra di esse.\nQuesto privilegio può ripristinare in una creatura un ammontare di punti ferita che la riporti a non più della metà del suo massimo dei punti ferita.\nIl chierico non può utilizzare questo privilegio su un costrutto o su un non morto.\n\n---\n\n**GUARITORE** **BENEDETTO**\nA partire dal 6° livello, gli incantesimi curativi che il chierico lancia sugli altri guariscono anche lui.\nQuando il chierico lancia un incantesimo di 1° livello o di livello superiore che ripristina punti ferita in una creatura diversa da lui, egli recupera un ammontare di punti ferita pari a 2 + il livello dell\'incantesimo.\n\n---\n\n**COLPO** **DIVINO**\nAll\'8° livello, il chierico ottiene la capacità di infondere energia divina nei colpi della sua arma.\nUna volta per ogni suo turno, quando colpisce una creatura con un attacco con un\'arma, il chierico può fare in modo che l\'attacco infligga 1d8 danni radiosi extra al bersaglio.\nQuando il chierico arriva al 14° livello, i danni extra aumentano a 2d8.\n\n---\n\n**GUARIGIONE** **SUPREMA**\nA partire dal 17° livello, quando il chierico normalmente tirerebbe uno o più dadi per ripristinare punti ferita tramite un incantesimo, egli usa invece il numero più alto possibile per ogni dado.\nPer esempio, anziché ripristinare 2d6 punti ferita a una creatura, ne ripristina direttamente 12.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              benedizione, cura ferite\n3°              arma spirituale, ristorare inferiore\n5°              faro di speranza, rinascita\n7°              guardiano della fede, interdizione alla morte\n9°              cura ferite di massa, rianimare morti\n'),
  dominioDellInganno('Dominio dell inganno',
      '**BENEDIZIONE** **DELL**\'**INGANNATORE**\nA partire da quando sceglie questo dominio al 1° livello, il chierico può usare la sua azione per toccare una creatura consenziente diversa da sé e conferirle vantaggio alle prove di Destrezza (Furtività).\nQuesta benedizione dura 1 ora o finché il chierico non utilizza di nuovo questo privilegio.\n\n---\n\n**INCANALARE** DIVINITÀ: **INVOCARE** **DUPLICATO**\nA partire dal 2° livello, Il chierico può utilizzare Incanalare Divinità per creare un duplicato illusorio di se stesso.\nCon un\'azione, il chierico crea una perfetta illusione di se stesso che dura 1 minuto o finché il chierico non perde la concentrazione (come se si stesse concentrando su un incantesimo).\nL\'illusione appare in uno spazio libero situato entro 9 metri dal chierico e che egli sia in grado di vedere.\nCome azione bonus, nel suo turno, il chierico può muovere l\'illusione di un massimo di 9 metri fino a uno spazio che egli sia in grado di vedere, ma l\'illusione deve rimanere entro 36 metri da lui.\nPer tutta la durata, il chierico può lanciare incantesimi come se si trovasse nello spazio dell\'illusione, ma deve usare i propri sensi.\nInoltre, quando sia il chierico che la sua illusione si trovano entro 1,5 metri da una creatura che sia in grado di vedere l\'illusione, il chierico dispone di vantaggio ai tiri per colpire contro quella creatura, in quanto l\'illusione distrae il bersaglio.\n\n---\n\n**INCANALARE** DIVINITÀ: **MANTO** **DI** **OMBRE**\nA partire dal 6° livello, il chierico può utilizzare Incanalare Divinità per svanire.\nCon un\'azione, il chierico diventa invisibile fino alla fine del suo turno successivo.\nTorna a essere visibile se attacca o se lancia un incantesimo.\n\n---\n\n**COLPO** **DIVINO**\nAll\'8° livello, il chierico ottiene la capacità di infondere nei colpi della sua arma un veleno donatogli dalla sua divinità.\nUna volta per ogni suo turno, quando colpisce una creatura con un attacco con un\'arma, il chierico può rare in modo che l\'attacco infligga 1d8 danni da veleno extra.\nQuando arriva al 14° livello, i danni extra aumentano a 2d8.\n\n---\n\n**DUPLICATO** **MIGLIORATO**\nAl 17° livello, il Chierico può creare fino a quattro duplicati di se stesso anziché uno quando utilizza Invocare Duplicato.\nCome azione bonus nel suo turno, il chierico può muovere un qualsiasi numero di quei duplicati fino a un massimo di 9 metri ed entro una gittata massima di 36 metri.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**     **INCANTESIMI**\n1°              camuffare se stesso, charme su persone\n3°              immagine speculare, passare senza tracce\n5°              dissolvi magie, intermittenza\n7°              metamorfosi, porta dimensionale\n9°              dominare persone, modificare memoria\n'),
  circoloDellaLuna('Circolo della luna',
      '**FORMA** **SELVATICA** **DA** **COMBATTIMENTO**\nQuando il druido sceglie questo circolo al 2° livello, ottiene la capacità di utilizzare Forma Selvatica nel proprio turno come azione bonus anziché con un\'azione.\nInoltre, finché mantiene la sua Forma Selvatica, può usare un\'azione bonus per spendere uno slot incantesimo e recuperare un ammontare di punti ferita pari a 1d8 per ogni livello dello slot incantesimo speso.\n\n---\n\n**FORME** **DEL** **CIRCOLO**\nI riti del circolo conferiscono al druido la capacità di assumere forme bestiali più pericolose.\nA partire dal 2° livello, il druido può utilizzare Forma Selvatica per trasformarsi in una bestia con un grado di sfida massimo pari a 1 (deve ignorare la colonna "**GS** Max" nella tabella "Forme Bestiali" ma deve rispettare le altre limitazioni riportate in quella tabella).\nA partire dal 6° livello, può trasformarsi in una bestia con un grado di sfida pari al proprio livello da druido diviso 3, arrotondato per difetto.\n\n---\n\n**COLPO** **PRIMORDIALE**\nA partire dal 6° livello, gli attacchi del druido in forma bestiale sono considerati magici al fine di oltrepassare la resistenza e l\'immunità agli attacchi e ai danni non magici.\n\n---\n\n**FORMA** **SELVATICA** **ELEMENTALE**\nAl 10° livello, il druido può spendere due utilizzi di Forma Selvatica simultaneamente per trasformarsi in un elementale dell\'acqua, un elementale dell\'aria, un elementale del fuoco o un elementale della terra.\n\n---\n\n**MILLE** **FORME**\nAl 14° livello, il druido ha imparato a usare la magia per alterare la sua forma fisica in modo più sottile e può lanciare l\'incantesimo alterare se stesso a volontà.    '),
  circoloDellaTerra('Circolo della terra',
      '**TRUCCHETTO** **BONUS**\nQuando il druido sceglie questo circolo al 2° livello, apprende un trucchetto da druido aggiuntivo a sua scelta.\n\n---\n\n**RECUPERO** **NATURALE**\nA partire dal 2° livello, il druido recupera parte della sua energia magica mettendosi seduto a meditare per entrare in comunione con la natura.\nDurante un riposo breve, il druido sceglie quali slot incantesimo spesi desidera recuperare.\nQuesti slot incantesimo possono avere un livello totale pari o inferiore alla metà del livello da druido (arrotondato per eccesso) e nessuno slot può essere di livello pari o superiore al 6°.\nIl druido non può più utilizzare questo privilegio finché non completa un riposo lungo.\nPer esempio, un druido di 4° livello può recuperare slot incantesimo per un valore totale di due livelli.\nPotrà quindi recuperare uno slot di 2° livello o due slot di 1° livello.\n\n---\n\n**INCANTESIMI** **DEL** **CIRCOLO**\nGrazie al suo legame mistico con la terra, il druido è in grado di lanciare alcuni particolari incantesimi.\nAl 3°, 5°, 7°, 9° livello il druido può accedere agli incantesimi del circolo collegati alla terra in cui egli è diventato un druido.\nIl giocatore sceglie quel tipo di territorio (artico, costa, deserto, foresta, montagna, palude, prateria o Underdark) e consulta la lista di incantesimi a essa associata.\nUna volta ottenuto l\'accesso a un incantesimo del circolo, quell\'incantesimo è sempre considerato preparato e non conta al fine di determinare il numero di incantesimi che il druido può preparare ogni giorno.\nSe il druido ottiene l\'accesso a un incantesimo che non compare sulla lista degli incantesimi da druido, quell\'incantesimo è comunque considerato un incantesimo da druido per lui.\n\n---\n\n**ARTICO**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            blocca persone, crescita di spine\n5°            lentezza, temptesta di nevischio\n7°            libertà di movimento, tempesta di ghiaccio\n9°            comunione con la natura, cono di freddo\n\n---\n\n**COSTA**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            immagine speculare, passo velato\n5°            camminare sull\'acqua, respirare sott\'acqua\n7°            controllare acqua, libertà di movimento\n9°            evoca elementale, scrutare\n\n---\n\n**DESERTO**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            sfocatura, silenzio\n5°            creare cibo e acqua, protezione dall\'energia\n7°            inaridire, terreno illusorio\n9°            muro di pietra, piaga degli insetti\n\n---\n\n**FORESTA**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            movimenti del ragno, pelle coriacea\n5°            crescita vegetale, invocare il fulmine\n7°            divinazione, libertà di movimento\n9°            comunione con la natura, traslazione arborea\n\n---\n\n**MONTAGNA**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            crescita di spine, movimenti del ragno\n5°            fondersi nella pietra, fulmine\n7°            pelle di pietra, scolpire pietra\n9°            muro di pietra, passapareti\n\n---\n\n**PALUDE**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            freccia acido di Melf, oscurità\n5°            camminare sull\'acqua, nube maleodorante\n7°            libertà di movimento, localizza creatura\n9°            piaga degli insetti, scrutare\n\n---\n\n**PRATERIA**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            invisibilità, passare senza tracce\n5°            luce diurna, velocità\n7°            divinazione, libertà di movimento\n9°            piaga degli insetti, sogno\n\n---\n\n**UNDERDARK**\n---\n\n**LIVELLO** **DA** **DRUIDO**     **INCANTESIMI** **DEL** **CIRCOLO**\n3°            movimenti del ragno, ragnatela\n5°            forma gassosa, nube maleodorante\n7°            invisibilità superiore, scolpire pietra\n9°            nube mortale, piaga degli insetti\n\n---\n\n**ANDATURA** **SUL** **TERRITORIO**\nA partire dal 6° livello, muoversi attraverso il terreno difficile non magico non richiede più un costo in movimento extra al druido.\nInoltre, il druido può passare attraverso i vegetali non magici senza esserne rallentato e senza subire danni se tali vegetali presentano spine, aculei o altri pericoli simili.\nInfine, il druido dispone di vantaggio ai tiri salvezza contro i vegetali creati magicamente o manipolati per ostacolare il movimento, come quelli creati dall\'incantesimo intralciare.\n\n---\n\n**INTERDIZIONE** **DELLA** **NATURA**\nQuando il druido arriva al 10° livello, non può essere affascinato o spaventato dagli elementali o dai folletti ed è immune ai veleni e alle malattie.\n\n---\n\n**RIFUGIO** **DELLA** **NATURA**\nQuando il druido arriva al 14° livello, le creature del mondo naturale percepiscono il suo legame con la natura ed esitano ad attaccarlo.\nQuando una bestia o una creatura vegetale attacca il druido, quella creatura deve effettuare un tiro salvezza su Saggezza contro la **CD** degli incantesimi del druido.\nSe lo fallisce, deve scegliere un bersaglio diverso, altrimenti l\'attacco manca automaticamente.\nSe invece lo supera, la creatura è immune a questo effetto per 24 ore.\nLa creatura è consapevole di questo effetto prima di effettuare il suo attacco contro il druido.\n'),
  viaDeiQuattroElementi('Via dei quattro elementi',
      '**DISCEPOLO** **DEGLI** **ELEMENTI**\nQuando il monaco sceglie questa tradizione al 3° livello, inizia ad apprendere una serie di discipline magiche che imbrigliano il potere dei quattro elementi.\nOgni disciplina richiede un costo in punti ki ogni volta che il monaco la usa.\nIl monaco conosce la disciplina Sintonia Elementale e un\'altra disciplina elementale a sua scelta, descritta nella sezione seguente, "Discipline Elementali".\nApprende una disciplina elementale aggiuntiva a sua scelta al 6°, 11° e 17° livello.\nInoltre, ogni volta che il monaco apprende una nuova disciplina elementale, può sostituire una disciplina che già conosce con una disciplina diversa.\n---\n\n**LANCIARE** **INCANTESIMI** **ELEMENTALI**.\nAlcune discipline elementali consentono al monaco di lanciare incantesimi.\nVedi il capitolo 10 per le regole generali relative alla magia.\nPer lanciare uno di questi incantesimi, il monaco usa il tempo di lancio e le altre regole relative all\'incantesimo in questione, ma non è obbligato a fornire le componenti materiali che esso richiede.\nUna volta arrivato al 5° livello, il monaco può spendere ulteriori punti ki per aumentare il livello di una disciplina elementale da lui lanciata, purché l\'incantesimo possieda un effetto potenziato a un livello superiore, come per esempio mani brucianti.\nIl livello dell\'incantesimo aumenta di 1 per ogni punto ki aggiuntivo speso dal monaco.\nPer esempio, se un monaco di 5° livello utilizza Colpo della Cenere Turbinante per lanciare mani brucianti, può spendere 3 punti ki per lanciarlo come incantesimo di 2° livello (il costo base della disciplina, pari a 2 punti ki, più 1).\nIl numero massimo di punti ki che il monaco può spendere per lanciare un incantesimo in questo modo (incluso il suo costo base in punti ki e gli eventuali punti ki aggiuntivi che spende per aumentarne il livello) è determinato dal livello da monaco, come indicato nella tabella "Incantesimi e Punti Ki".\n\n---\n\n**INCANTESIMI** E **PUNTI** **KI**\n---\n\n**LIVELLI** **DA** **MONACO**      **PUNTI** **KI** **MASSIMI** **PER** **INCANTESIMO**\n5°-8°                           3\n9°-12°                          4\n13°-16°                         5\n17°-20°                         6\n\n---\n\n**DISCIPLINE** **ELEMENTALI**\nLe discipline elementali sono presentate in ordine alfabetico.\nSe una disciplina richiede un livello, il monaco deve avere raggiunto quel livello per apprendere la disciplina in questione.\n-Cavalcare il Vento (11° livello richiesto): Il monaco può spendere 4 punti ki per lanciare volare, bersagliando se stesso.\n-Colpo della Cenere Turbinante: Il monaco può spendere 2 punti ki per lanciare mani brucianti.\n-Difesa della Montagna Eterna (17° livello richiesto): Il monaco può spendere 5 punti ki per lanciare pelle di pietra bersagliando se stesso.\n-Fiamme della Fenice (11° livello richiesto): Il monaco può spendere 4 punti ki per lanciare palla di fuoco.\n-Fiume della Fiamma Famelica (17° livello richiesto): Il monaco pub spendere 5 punti ki per lanciare muro di fuoco.\n-Forma del Fiume Fluente: Con un azione, il monaco può spendere 1 punto ki per scegliere un\'area di ghiaccio o di acqua le cui dimensioni non superino i 9 metri per lato e situata entro 36 metri da lui.\nIl monaco può trasformare l\'acqua in ghiaccio e viceversa all\'interno di quell\'area, e può modellare il ghiaccio nella forma che preferisce.\nPuò aumentare o ridurre l\'elevazione del ghiaccio, scavare o riempire un canale, erigere o abbattere un muro o formare una colonna.\nL\'estensione di tali cambiamenti non può superare la metà della dimensione più grande dell\'area.\nPer esempio, se il monaco agisce su un quadrato con lato di 9 metri può creare una colonna alta fino a 4,5 metri, aumentare o ridurre l\'elevazione del quadrato di 4,5 metri, scavare una fossa profonda al massimo 4,5 metri e così via.\nNon può modellare il ghiaccio per intrappolare o infliggere danni a una creatura all\'interno dell\'area.\n-Frusta d\'acqua: Con un\'azione, il monaco può spendere 2 punti ki per creare una frusta d\'acqua che spinge e tira una creatura per farle perdere l\'equilibrio.\nUna creatura che il monaco sia in grado di vedere e che si trovi entro 9 metri da lui deve effettuare un tiro salvezza su destrezza.\nSe lo fallisce, subisce 3d10 danni contundenti, più 1d10 danni contundenti extra per ogni punto ki aggiuntivo speso dal monaco, che può farla cadere a terra prona o tirarla fino a 7,5 metri avvicinandola a sé.\nSe invece lo supera, la creatura subisce la metà dei danni, ma non viene tirata e non cade a terra prona.\n-Gong della Sommità (6° livello richiesto): Il monaco può spendere 3 punti ki per lanciare frantumare.\n-Morsa del Vento del Nord (6° livello richiesto): Il monaco può spendere 3 punti ki per lanciare blocca persone.\n-Onda della Terra Tumultuosa (17° 1ivello richiesto): Il monaco può spendere 6 punti ki per lanciare muro di pietra.\n-Postura della Nebbia (11° livello richiesto): Il monaco può spendere 4 punti ki per lanciare forma gassosa, bersagliando se stesso.\n-Pugno dei Quattro Tuoni: Il monaco può spendere 2 punti ki per lanciare onda tonante.\n-Pugno dell\'Aria Inviolabile: Il monaco può generare una scarica di aria compressa che colpisce con la forza di un pugno.\nCon un\'azione, il monaco può spendere 2 punti ki e scegliere una creatura entro 9 metri da lui.\nQuella creatura deve effettuare un tiro salvezza su Forza.\nSe lo fallisce, la creatura subisce 3d10 danni contundenti, più 1d10 danni crea contundenti extra per ogni punto ki aggiuntivo speso dal monaco; inoltre, il monaco può spingere la creatura fino a un massimo di 6 metri, allontanandola da sé e buttandola a terra prona.\nSe lo supera, la creatura subisce la metà di quei danni, ma non viene spinta e non cade a terra prona.\n-Sintonia Elementale: Il monaco può usare la sua azione per controllare brevemente le forze elementali vicine, provocando un effetto a sua scelta tra i seguenti:- Creare un effetto sensoriale innocuo e istantaneo correlato all\'acqua, all\'aria, al fuoco o alla terra, come uno spruzzo d\'acqua, uno sbuffo di vento, una pioggia di scintille o un leggero tremolio di alcune pietre.\n- Accendere o estinguere istantaneamente una torcia, una candela o un piccolo fuoco da campo.\n- Raffreddare o riscaldare fino a 0,5 kg di materiale non vivente per un massimo di 1 ora.\n- Generare terra, fuoco, acqua o foschia delle dimensioni massime di un cubo con spigolo di 30 cm e che assuma una rozza forma a sua scelta per un massimo di 1 minuto.\n-Soffio dell\'Inverno (17° livello richiesto): Il monaco può spendere 6 punti ki per lanciare cono di freddo.\n-Spiriti della Burrasca Impetuosa: Il monaco può spendere 2 punti ki per lanciare folata di vento.\n-Zanne del Serpente di Fuoco: Quando il monaco usa l\'azione di Attacco nel suo turno, può spendere 1 punto ki per generare dei tentacoli di fiamme dai suoi pugni e dai suoi piedi.\nLa portata dei suoi colpi senz\'armi aumentadi 3 metri per quell\'azione, nonché per il resto del turno.\n Quando un tale attacco colpisce, infligge danni da fuoco anziché danni contundenti, e se il monaco spende 1 punto ki quando l\'attacco colpisce, esso infligge anche 1d10 danni da fuoco extra.   '),
  viaDellaManoAperta('Via della mano aperta',
      '**TECNICA** **DELLA** **MANO** **APERTA**\nA partire da quando sceglie questa tradizione al 3° livello, il monaco può manipolare il ki del suo nemico quando imbriglia il proprio.\nOgni volta che il monaco colpisce una creatura con un attacco concessogli dalla sua Raffica di Colpi, può imporre a quel bersaglio uno degli effetti seguenti:\n- Deve superare un tiro salvezza su Destrezza, altrimenti cade a terra prono.\n- Deve superare un tiro salvezza su Forza.\nSe lo fallisce, il monaco può spingerlo di 4,5 metri allontanandolo da sé.\n- Non può effettuare reazioni fino alla fine del turno successivo del monaco.\n\nINTEGRITÀ **DEL** **CORPO**\nAl 6° livello, il monaco ottiene la capacità di curarsi.\nUsando un\'azione, recupera un ammontare di punti ferita pari a tre volte il suo livello da monaco.\nDeve completare un riposo lungo prima di poter utilizzare di nuovo questo privilegio.\n\nTRANQUILLITÀ\nA partire dall\'11° livello, il monaco può entrare in una speciale forma di meditazione, immergendosi in un\'aura di pace.\nAlla fine di un riposo lungo ottiene l\'effetto di un incantesimo santuario che dura fino all\'inizio del suo riposo lungo successivo (l\'incantesimo può terminare anticipatamente come di consueto).\nLa **CD** del tiro salvezza dell\'incantesimo è pari a 8 + il modificatore di Saggezza del monaco + il bonus di competenza del monaco.\n\n---\n\n**PALMO** **TREMANTE**\nAl 17° livello, il monaco ottiene la capacità di scatenare vibrazioni letali nel corpo di un altro.\nQuando il monaco colpisce una creatura con un colpo senz\'armi, può spendere 3 punti ki per dare il via a queste vibrazioni impercettibili, che durano un numero di giorni pari al suo livello da monaco.\nLe vibrazioni sono innocue, a meno che il monaco non usi la sua azione per interromperle.\nPer farlo, il monaco e il bersaglio devono trovarsi sullo stesso piano di esistenza.\nQuando il monaco usa questa azione, la creatura deve effettuare un tiro salvezza su Costituzione.\nSe lo fallisce, scende a 0 punti ferita, mentre se lo supera, subisce 10d10 danni necrotici.\nIl monaco può tenere soltanto una creatura alla volta sotto l\'effetto di questo privilegio.\nPuò scegliere di porre fine alle vibrazioni in modo innocuo senza usare un\'azione.'),
  viaDellOmbra('Via dell ombra',
      '**ARTI** **DELL**\'**OMBRA**\nA partire da quando sceglie questa tradizione al 3° livello, un monaco può usare il suo ki per duplicare gli effetti di certi incantesimi.\nCon un\'azione può spendere 2 punti ki per lanciare oscurità, passare senza tracce, scurovisione o silenzio senza fornire componenti materiali.\nInoltre ottiene il trucchetto illusione minore, se già non lo conosceva.\n\n---\n\n**PASSO** **DELL**\'**OMBRA**\nAl 6° livello, un monaco ottiene la capacità di passare da un\'ombra all\'altra.\nQuando si trova in condizioni di luce fioca o di oscurità, con un\'azione bonus può teletrasportarsi di un massimo di 18 metri fino a uno spazio libero che egli sia in grado di vedere e che si trovi a sua volta in condizioni di luce fioca o di oscurità.\nDispone poi di vantaggio al primo attacco in mischia che effettua prima della fine del turno.\n\n---\n\n**MANTO** **DI** **OMBRE**\nAll\'11° livello, il monaco è in grado di diventare tutt\'uno con le ombre.\nQuando si trova in un\'area di luce fioca o di oscurità, può usare la sua azione per diventare invisibile.\nRimane invisibile finché non effettua un attacco, non lancia un incantesimo o non si trova in un\'area di luce intensa.\n\n---\n\n**OPPORTUNISTA**\nAl 17° livello, un monaco impara ad approfittare della momentanea distrazione che una creatura subisce quando è colpita da un attacco.\nOgni volta che una creatura entro 1,5 metri dal monaco è colpita da un attacco effettuato da una creatura diversa dal monaco, quest\'ultimo può usare la sua reazione per effettuare un attacco in mischia contro quella creatura. '),
  giuramentoDegliAntichi('Giuramento degli antichi',
      '**DETTAMI** **DEGLI** **ANTICHI**\nI dettami del Giuramento degli Antichi sono stati preservati per innumerevoli secoli.\nQuesto giuramento enfatizza i principi del bene al di sopra di qualsiasi distinzione tra legge e caos.\nI suoi quattro principi centrali sono semplici.\n- Allimenta la Luce: Tramite i tuoi atti di misericordia, benevolenza e perdono, accendi la fiamma della speranza nel mondo, e scaccia la disperazione.\n- Proteggi la Luce: Là dove c\'è bontà, bellezza, amore e gioia nel mondo, opponiti alla perfidia che vorrebbe distruggerlo.\nLà dove c\'è vita, opponiti alle forze che vorrebbero vederla avvizzire.\nPreserva la Tua Luce: Trai gioia dal canto e dalle risate, dalla bellezza e dall\'arte.\nSe lasci che la luce nel tuo cuore si spenga, non potrai preservarla nel mondo.\n- Sii la Luce: Sii un fulgido faro per tutti coloro che vivono nella disperazione.\nLascia che la luce della tua gioia e del tuo coraggio risplenda in ogni tua azione.\n\n---\n\n**INCANTESIMI** **DI** **GIURAMENTO**\nIl paladino ottiene gli incantesimi seguenti ai livelli da paladino elencati.\n\n---\n\n**LIVELLO** **DA** **PALADINO**     **INCANTESIMI**\n3°              colpo intrappolante, parlare con gli animali\n5°              bagliore lunare, passo velato\n9°              crescita vegetale, protezione dall\'energia\n13°             pelle di pietra, tempesta di ghiaccio\n17°             comunione con la natura, traslazione arborea\n\n---\n\n**INCANALARE** DIVINITÀ\nQuando il paladino acquisisce questo giuramento al 3° livello, ottiene le due seguenti opzioni di Incanalare Divinità.\nCollera della Natura: Il paladino può utilizzare Incanalare Divinità per invocare le forze primordiali affinché intrappolino un nemico.\nCon un\'azione, può fare spuntare dal terreno dei rampicanti spettrali che si protendono e afferrano una creatura situata entro 3 metri dal paladino e che egli sia in grado di vedere.\nLa creatura deve superare un tiro salvezza su Forza o Destrezza (a sua scelta), altrimenti sarà trattenuta.\nFinché è trattenuta dai rampicanti, la creatura continua a ripetere il tiro salvezza alla fine di ogni suo turno.\nSe lo supera, riesce a liberarsi e i rampicanti svaniscono.\nScacciare gli Infedeli: li paladino può utilizzare Incanalare Divinità per pronunciare antiche parole che infliggono dolore ai folletti e agli immondi.\nCon un\'azione, il paladino brandisce il suo simbolo sacro e ogni folletto o immondo situato entro 9 metri da lui e in grado di sentirlo deve effettuare un tiro salvezza su Saggezza.\nSe lo fallisce, la creatura è scacciata per 1 minuto o finché non subisce danni.\nUna creatura scacciata deve spendere i suoi turni tentando di allontanarsi il più possibile dal paladino e non può volontariamente muoversi in uno spazio entro 9 metri dal paladino.\nInoltre, non può effettuare reazioni.\nCome sua azione può usare solo l\'azione di Scatto o tentare di ruggire da un effetto che gli impedisce di muoversi.\nSe non può muoversi in alcun luogo, la creatura può usare l\'azione di Schivata.\nSe la vera forma della creatura è celata da un\'illusione, una forma mutata o altri effetti analoghi, quella forma è rivelata quando la creatura viene scacciata.\n\n---\n\n**AURA** **DI** **INTERDIZIONE**\nA partire dal 7° livello, la magia antica scorre con tale potenza nel paladino da formare un\'interdizione soprannaturale.\nIl paladino e le creature amiche situate entro 3 metri da lui ottengono resistenza ai danni degli incantesimi.\nAl 18° livello, la gittata di questa aura aumenta a 9 metri.\n\n---\n\n**SENTINELLA** **IMPERITURA**\nA partire dal 15° livello, quando il paladino scende a O punti ferita ma non viene ucciso sul colpo, può decidere di rimanere a 1 punto ferita.\nIl paladino non può usare nuovamente questa capacità finché non completa un riposo lungo.\nNon subisce inoltre alcuno svantaggio dovuto alla vecchiaia e non può invecchiare magicamente.\n\n---\n\n**CAMPIONE** **DEGLI** **ANTICHI**\nAl 20° livello, il paladino può assumere la forma di un\'antica forza della natura, assumendo un aspetto a sua scelta.\nPer esempio, la sua pelle potrebbe diventare verde o ruvida e resistente come la corteccia, i suoi capelli potrebbero trasformarsi in fogliame o muschio, oppure dalla sua testa potrebbero spuntare le corna di un cervo o la criniera di un leone.\nUsando la sua azione, il paladino si sottopone a una trasformazione.\nPer 1 minuto ottiene i benefici seguenti:\n- All\'inizio di ogni suo turno recupera 10 punti ferita.\n- Ogni volta che lancia un incantesimo da paladino con un tempo di lancio di 1 azione, può lanciarlo usando invece un\'azione bonus.\n- Le creature nemiche situate entro 3 metri da lui subiscono svantaggio ai tiri salvezza contro i suoi incantesimi da paladino e le sue opzioni di Incanalare Divinità.\nUna volta utilizzato questo privilegio, il paladino non può più utilizzarlo finché non completa un riposo lungo.\n'),
  giuramentoDiDevozione('Giuramento di Devozione',
      '**DETTAMI** **DI** **DEVOZIONE**\n Sebbene le parole e gli obblighi esatti del Giuramento di Devozione possano variare, i paladini di questo giuramento condividono i seguenti precetti.\n -Onestà: Non mentire e non rubare.\n Che la tua parola sia vincolante come una promessa.\n -Coraggio: Non avere mai paura di agire, anche se la prudenza è sempre sinonimo di saggezza.\n -Compassione: Aiuta gli altri, proteggi i deboli e punisci coloro che li minacciano.\n Mostra pietà ai tuoi nemici, ma che la tua pietà sia accompagnata dalla saggezza.\n -Onore: Tratta gli altri con gentilezza e lascia che i tuoi atti onorevoli siano di esempio per loro.\n Fà tutto il bene possibile, provocando il minimo ammontare di danni.\n -Dovere: Sii responsabile delle tue azioni e delle loro conseguenze, proteggi coloro che sono stati affidati alle tue cure e obbedisci a chi esercita la sua legittima autorità su di te.\n \n **INCANTESIMI** **DI** **GIURAMENTO**\n Il paladino ottiene gli incantesimi seguenti ai livelli da paladino elencati.\n\n---\n\n**LIVELLO** **DA** **PALADINO**     **INCANTESIMI**\n3°              protezione dal bene e dal male, santuario\n5°              ristorare inferiore, zona di divinità\n9°              dissolvi magie, faro di speranza\n13°             guardiano della fede, libertà di movimento\n17°             colpo infuocato, comunione\n\n---\n\n**INCANALARE** DIVINITÀ\nQuando il paladino acquisisce questo giuramento al 3° livello, ottiene le due seguenti opzioni di Incanalare Divinità.\nArma Consacrata: Con un\'azione, il paladino può utilizzare Incanalare Divinità per infondere un flusso di energia positiva in un\'arma da lui impugnata.\nPer 1 minuto il paladino aggiunge il suo modificatore di Carisma ai tiri per colpire effettuati con quell\'arma (fino a un bonus minimo di +1).\nL\'arma emette inoltre luce intensa entro un raggio di 6 metri e luce fioca per ulteriori 6 metri.\nSe l\'arma non è già magica, diventa magica per questa durata.\nIl paladino può porre termine a questo effetto nel suo turno come parte di qualsiasi altra azione.\nSe non impugna o non trasporta più questa arma, o se cade privo di sensi, questo effetto termina.\nScacciare i Sacrileghi: Con un\'azione, il paladino può utilizzare Incanalare Divinità, brandire il suo simbolo sacro e pronunciare una preghiera di condanna nei confronti degli immondi e dei non morti.\nOgni immondo o non morto che sia in grado di vedere o sentire il paladino e che si trovi entro 9 metri da lui deve effettuare un tiro salvezza su Saggezza.\nSe lo fallisce, la creatura è scacciata per 1 minuto o finché non subisce danni.\nUna creatura scacciata deve spendere i suoi turni tentando di allontanarsi il più possibile dal paladino e non può volontariamente muoversi in uno spazio entro 9 metri dal paladino.\nInoltre, non può effettuare reazioni.\nCome sua azione può usare solo l\'azione di Scatto o tentare di fuggire da un effetto che gli impedisce di muoversi.\nSe non può muoversi in alcun luogo, la creatura può usare l\'azione di Schivata.\n\n---\n\n**AURA** **DI** **DEVOZIONE**\nA partire dal 7° livello, il paladino e le creature amiche entro 3 metri da lui non possono essere affascinate finché il paladino è cosciente.\nAl 18° livello, la gittata di questa aura aumenta a 9 metri.\n\n---\n\n**PUREZZA** **DI** **SPIRITO**\nA partire dal 15° livello, il paladino è sempre sotto l\'effetto di un incantesimo protezione dal bene e dal male.\n\n---\n\n**NUBE** **SACRA**\nAl 20° livello, con un\'azione, il paladino può emanare un\'aura di luce solare.\nPer 1 minuto, il paladino emette luce intensa attorno a sé entro un raggio di 9 metri e luce fioca per ulteriori 9 metri.\nOgni volta che una creatura nemica inizia il suo turno nella luce intensa, subisce 10 danni radiosi.\nInoltre, per la durata dell\'effetto, il paladino dispone di vantaggio ai tiri salvezza contro gli incantesimi lanciati dagli immondi o dai non morti.\nUna volta utilizzato questo privilegio, il paladino non può più utilizzarlo finché non completa un riposo lungo.\n'),
  giuramentoDellaVendetta('Giuramento della vendetta',
      '**DETTAMI** **DI** **VENDETTA**\n I dettami del Giuramento di Vendetta possono variare da un paladino all\'altro, ma tutti i precetti sono incentrati sulla necessità di punire i malfattori con ogni mezzo necessario.\n I paladini che osservano questi precetti sono disposti a sacrificare anche la loro rettitudine pur di impartire giustizia a chi commette un crimine, quindi i paladini di questo tipo sono spesso di allineamento neutrale o legale neutrale.\n I principi alla base di questi dettami sono brutalmente semplici.\n -Combattere il Male Peggiore: Se devi scegliere tra combattere contro i tuoi nemici giurati e combattere contro un male minore, scegli sempre il male peggiore.\n -Nessuna Pietà per i Malvagi: Gli avversari ordinari possono meritarsi la tua misericordia, ma i tuoi nemici giurati non la otterranno mai.\n Costi Quel Che Costi: Non avrai alcuno scrupolo di fronte a un\'occasione per sterminare i tuoi nemici.\n -Risarcimento: Se i tuoi avversari seminano la rovina per il mondo, lo fanno perché tu non sei riuscito a fermarli.\n Dovrai aiutare le vittime dei loro misfatti.\n \n **INCANTESIMI** **DI** **GIURAMENTO**\n Il paladino ottiene gli incantesimi seguenti ai livelli da paladino elencati.\n\n---\n\n**LIVELLO** **DA** **PALADINO**     **INCANTESIMI**\n3°              anatema, marchio del cacciatore\n5°              blocca persone, passo velato\n9°              protezione dall\'energia, velocità\n13°             esilio, porta dimensionale\n17°             blocca mostri, scrutare\n\n---\n\n**INCANALARE** DIVINITÀ\n Quando il paladino acquisisce questo giuramento al 3° livello, ottiene le due seguenti opzioni di Incanalare Divinità.\n Abiurare Nemico: Con un\'azione, il paladino brandisce il suo simbolo sacro e proclama una preghiera di denuncia utilizzando Incanalare Divinità.\n Il paladino sceglie una creatura situata entro 18 metri da lui e che egli sia in grado di vedere.\n Quella creatura deve effettuare un tiro salvezza su Saggezza, a meno che non sia immune all\'essere spaventata.\n Gli immondi e i non morti subiscono svantaggio a questo tiro salvezza.\n Se fallisce il tiro salvezza, la creatura è spaventata per 1 minuto o finché non subisce danni.\n Finché è spaventata, la creatura ha velocità O e non può trarre beneficio da alcun bonus alla sua velocità.\n Se supera il tiro salvezza, la creatura dimezza la sua velocità per 1 minuto o finché non subisce danni.\n Giuramento di Inimicizia: Utilizzando Incanalare Divinità come azione bonus, il paladino può formulare un giuramento di inimicizia contro una creatura situata entro 3 metri da lui e che egli sia in grado di vedere.\n Il paladino dispone di vantaggio ai tiri per colpire contro la creatura per 1 minuto o finché essa non scende a O punti ferita o cade priva di sensi.\n \n **VENDICATORE** **IMPLACABILE**\n Al 7° livello, grazie alla sua concentrazione soprannaturale, il paladino è in grado di bloccare la ritirata dei suoi nemici.\n Quando colpisce una creatura con un attacco di opportunità, può muoversi fino a metà della sua velocità immediatamente dopo l\'attacco e come parte della stessa reazione.\n Questo movimento non provoca attacchi di opportunità.\n \n **ANIMA** **DI** **VENDETTA**\n A partire dal 15° livello, l\'autorità al cui cospetto il paladino ha formulato il suo Giuramento di Inimicizia gli conferisce un potere superiore sul suo avversario.\n Quando una creatura sotto l\'effetto del Giuramento di Inimicizia del paladino effettua un attacco, il paladino può usare la sua reazione per effettuare un attacco con un\'arma da mischia contro quella creatura, se essa si trova entro portata.\n \n **ANGELO** **VENDICATORE**\n Al 20° livello, il paladino può assumere la forma di un vendicatore angelico.\n Usando la sua azione, il paladino si sottopone a una trasformazione.\n Per 1 ora ottiene i benefici seguenti:\n - Dalla sua schiena spunta un paio di ali che gli conferisce una velocità di volare di 18 metri.\n - Il paladino emana un\'aura di minaccia nel raggio di 9 metri.\n La prima volta che una creatura nemica entra nell\'aura o vi inizia il proprio turno durante una battaglia, la creatura deve superare un tiro salvezza su Saggezza, altrimenti sarà spaventata dal paladino per 1 minuto o finché non subisce danni.\n I tiri per colpire contro la creatura spaventata dispongono di vantaggio.\n Una volta utilizzato questo privilegio, il paladino non può più utilizzarlo finché non completa un riposo lungo.\n'),
  cacciatore('Cacciatore',
      '**PREDA** **DEL** **CACCIATORE**\nAl 3° livello, il ranger ottiene uno dei seguenti privilegi a sua scelta.\n-Devastatore dell\'Orda: Una volta per ogni suo turno, quando effettua un attacco con un\'arma, il ranger può effettuare un altro attacco con la stessa arma contro una creatura diversa situata entro 1,5 metri dal bersaglio originale ed entro la gittata della sua arma.\n-Sterminatore di Colossi: La tenacia del ranger può logorare anche il più potente degli avversari.\nQuando il ranger colpisce una creatura con un attacco con un\'arma, quella creatura subisce 1d8 danni extra se è al di sotto del suo massimo dei punti ferita.\nPuò infliggere questi danni extra solo una volta per turno.\n-Uccisore di Giganti: Quando una creatura di taglia Grande o superiore entro 1,5 metri dal ranger colpisce o manca il ranger con un attacco, quest\'ultimo può usare la sua reazione per attaccare la creatura immediatamente dopo il suo attacco, purché sia in grado di vederla.\n\n---\n\n**TATTICHE** **DIFENSIVE**\nAl 7° livello, il ranger ottiene uno dei seguenti privilegi a sua scelta.\n-Difesa dal Multiattacco: Quando una creatura colpisce il ranger con un attacco, il ranger ottiene un bonus di +4 alla **CA** contro tutti gli attacchi successivi effettuati da quella creatura per il resto del turno.\n-Sfuggire all\'Orda: Gli attacchi di opportunità contro il ranger subiscono svantaggio.\n-Volontà d\'Acciaio: Il ranger dispone da vantaggio ai tiri salvezza contro l\'essere spaventato.\n\n---\n\n**MULTIATTACCO**\nAll\'11° livello, il ranger ottiene uno dei seguenti privilegi a sua scelta.\n-Attacco Turbinante: Il ranger può usare la sua azione per effettuare un attacco in mischia contro un qualsiasi numero di creature entro 1,5 metri da sé, effettuando un tiro per colpire separato per ogni bersaglio.\n-Raffica: Il ranger può usare la sua azione per effettuare un attacco a distanza contro un qualsiasi numero di creature entro 3 metri da un punto che egli sia in grado di vedere e che si trovi entro la gittata della sua arma.\nIl ranger deve avere munizioni sufficienti per ogni bersaglio, come di consueto, ed effettua un taro per colpire separato per ogni bersaglio.\n\n---\n\n**DIFESA** **DEL** **CACCIATORE** **SUPERIORE**\nAl 15° livello, il ranger ottiene uno dei seguenti privilegi a sua scelta.\n-Elusione: Quando il ranger è soggetto a un effetto che gli consente di effettuare un tiro salvezza su Destrezza per dimezzare i danni, come il soffio di fuoco di un drago rosso o un incantesimo fulmine, non subisce alcun danno se supera il tiro salvezza, e soltanto la metà dei danni e lo fallisce.\n-Opporsi alla Marea: Quando una creatura ostile manca il ranger con un attacco in mischia, il ranger può usare la sua reazione per obbligare quella creatura a ripetere lo stesso attacco contro un\'altra creatura (che non sia essa stessa) a scelta del ranger.\n-Schivata Prodigiosa: Quando un attaccante che il ranger è in grado di vedere colpisce il ranger con un attacco, quest\'ultimo può usare la sua reazione per dimezzare i danni che subirebbe dall\'attacco.    '),
  signoreDelleBestie('Signore delle bestie',
      '**COMPAGNO** **DEL** **RANGER**\nAl 3° livello, il ranger ottiene una bestia compagna che lo accompagna nelle sue avventure ed è addestrata a combattere accanto a lui.\nIl ranger sceglie una bestia di taglia Media o inferiore con un grado di sfida pari o inferiore a 1/4 (l\'appendice D include le statistiche del falco, del mastino e della pantera come esempi).\nSi aggiunge il bonus di competenza del ranger alla **CA**, ai tiri per colpire e ai tiri per i danni della bestia, nonché agli eventuali tiri salvezza e abilità in cui essa possiede competenza.\nIl suo massimo dei punti ferita è pari a quello indicato nella sua scheda delle statistiche o al quadruplo del livello da ranger, scegliendo il valore maggiore.\nCome ogni creatura, la bestia compagna può spendere Dadi Vita durante un riposo breve per recuperare punti ferita.\nLa bestia obbedisce ai comandi del ranger al meglio delle sue possibilità.\nSvolge il suo turno all\'iniziativa del ranger, ma non effettua un\'azione a meno che il ranger non glielo ordini.\nNel proprio turno, il ranger può ordinare verbalmente alla bestia dove muoversi (nessuna azione richiesta).\nIl ranger può anche usare la sua azione per ordinare verbalmente alla bestia di effettuare l\'azione di Aiuto, Attacco, Disimpegno, Scatto o Schivata.\nUna volta ottenuto il privilegio di Attacco Extra, il ranger può effettuare un attacco con un\'arma mentre ordina alla bestia di effettuare l\'azione di Attacco.\nSe il ranger è incapacitato o assente, la bestia agisce da sola, concentrandosi sulla protezione del ranger e di se stessa.\nLa bestia non necessita del comando del ranger per usare la sua reazione, per esempio per effettuare un attacco di opportunità.\nQuando il ranger viaggia attraverso una regione del suo terreno prescelto in compagnia solamente della sua bestia, si muove furtivamente a passo normale.\nSe la bestia muore, il ranger può ottenere un nuovo compagno trascorrendo 8 ore a instaurare un legame magico con una bestia che non gli sia ostile e che soddisfi i requisiti.\n\n---\n\n**ADDESTRAMENTO** **STRAORDINARIO**\nA partire dal 7° livello, in un qualsiasi suo turno in cui la sua bestia compagna non attacca, il ranger può usare un\'azione bonus per ordinare alla bestia di effettuare l\'azione di Aiuto, Disimpegno, Scatto o Schivata nel proprio turno.\n\n---\n\n**FURIA** **BESTIALE**\nA partire dall\'11° livello, quando il ranger ordina alla sua bestia compagna di effettuare l\'azione di attacco, la bestia può effettuare due attacchi, oppure effettuare l\'azione di multiattacco se la possiede.\n\n---\n\n**CONDIVIDERE** **INCANTESIMI**\nA partire dal 15° livello, quando il ranger lancia un incantesimo che bersaglia se stesso, può influenzare con quell\'incantesimo anche la sua bestia compagna, purché essa si trovi entro 9 metri da lui.    '),
  discendenzaDraconica('Discendenza draconica',
      '**ANTENATO** **DRACONICO**\nAl 1° livello, lo stregone sceglie un tipo di drago come suo antenato.\nIl tipo di danno associato a ogni drago sarà utilizzato dai privilegi che lo stregone otterrà in seguito.\nLo stregone è in grado di parlare, leggere e scrivere in Draconico.\nInoltre, ogni volta che effettua una prova di Carisma per interagire con i draghi, il suo bonus di competenza raddoppia se è applicabile alla prova.\n\n---\n\n**ANTENATI** **DRACONICI**\n---\n\n**DRAGO**       **TIPO** **DI** **DANNO**\nArgento     Freddo\nBianco      Freddo\nBlu         Fulmine\nBronzo      Fulmine\nNero        Acido\nOro         Fuoco\nOttone      Fuoco\nRame        Acido\nRosso       Fuoco\nVerde       Veleno\n\n---\n\n**RESILIENZA** **DRACONICA**\nLa magia, scorrendo nel corpo dello stregone, fa emergere alcuni tratti fisici dei draghi suoi antenati.\nAl 1° livello, il massimo dei punti ferita dello stregone aumenta di 1 e aumenta di nuovo di l ogni volta che il personaggio acquisisce un livello in questa classe.\nInoltre, alcune parti della sua pelle si ricoprono di un sottile strato di scaglie simili a quelle di un drago.\nQuando lo stregone non indossa armature, fa sua **CA** è pari a 13 + il suo modificatore di Destrezza.\n\nAFFINITÀ **ELEMENTALE**\nA partire dal 6° livello, quando lo stregone lancia un incantesimo che inftigge danni del tipo associato al suo antenato draconico, può aggiungere il suo modificatore di Carisma a un tiro per i danni di quell\'incantesimo.\nAllo stesso tempo, lo stregone può spendere 1 punto stregoneria per ottenere resistenza a quel tipo di danno per 1 ora.\n\n---\n\n**ALI** **DI** **DRAGO**\nAl 14° livello, lo stregone sviluppa la capacità di generare un paio di ali di drago dalla sua schiena, ottenendo una velocità di volare pari alla sua velocità attuale.\nLo stregone può generare queste ali come azione bonus nel suo turno.\nLe ali durano finché lo stregone non le congeda con un\'azione bonus durante il proprio turno.\nLo stregone non può manifestare le sue ali mentre indossa un\'armatura, a meno che l\'armatura non sia concepita per accoglierle; i vestiti che non sono stati concepiti per accogliere le ali potrebbero essere distrutti quando lo stregone le manifesta.\n\n---\n\n**PRESENZA** **DRACONICA**\nA partire dal 18° livello, lo stregone può incanalare la presenza terrificante del suo antenato draconico, rendendo quelli attorno a lui affascinati o spaventati.\nCon un\'azione, lo stregone pub spendere 5 punti stregoneria per attingere a questo potere ed emanare un\'aura di soggezione o di paura (a sua scelta) entro una distanza di 18 metri.\nPer 1 minuto o finché non perde la sua concentrazione (come se stesse ranciando un incantesimo che richiede concentrazione), ogni creatura ostile che inizia il suo turno entro questa aura deve superare un tiro salvezza su Saggezza o sarà affascinata (se lo stregone ha scelto soggezione) o spaventata (se ha scelto paura) finché l\'aura non termina.\nUna creatura che supera questo tiro salvezza è immune all\'aura dello stregone per 24 ore.'),
  magiaSelvaggia('Magia selvaggia',
      '**IMPULSO** **DI** **MAGIA** **SELVAGGIA**\nA partire da quando sceglie questa origine al 1° livello, lo stregone può sprigionare impulsi di magia incontrollata quando lancia i suoi incantesimi.\nUna volta per turno il **DM** può chiedergli di tirare un d20 subito dopo avere lanciato un incantesimo da stregone di livello pari o superiore al 1°.\nSe ottiene un 1, deve tirare sulla tabella "Impulsi di Magia Selvaggia" per generare un effetto magico.\nSe quell\'effetto è un incantesimo, è troppo selvaggio per essere influenzato dalla sua Metamagia, e se normalmente richiede concentrazione, in questo caso non richiede concentrazione; l\'incantesimo permane per la sua durata completa.\n\n---\n\n**ONDE** **DI** **CAOS**\nA partire dal 1° livello, lo stregone può manipolare le forze della probabilità e del caos per ottenere vantaggio a un tiro per colpire, una prova di caratteristica o un tiro salvezza.\nUna volta che l\'ha fatto, deve completare un riposo lungo prima che possa utilizzare di nuovo questo privilegio.\nIn qualsiasi momento, prima di recuperare l\'utilizzo di questo privilegio, il **DM** può chiedere al giocatore di tirare sulla tabella "Impulsi di Magia Selvaggia" subito dopo che lo stregone ha lanciato un incantesimo di livello pari o superiore al 1°.\nPoi lo stregone recupera l\'utilizzo di questo privilegio.\n\n---\n\n**PIEGARE** **LA** **FORTUNA**\nA partire dal 6° livello, lo stregone sviluppa la capacità di alterare il fato usando la sua magia selvaggia.\nQuando un\'altra creatura che lo stregone sia in grado di vedere effettua un tiro per colpire, una prova di caratteristica o un tiro salvezza, lo stregone può usare la sua reazione e spendere 2 punti stregoneria per tirare 1d4 e applicare il risultato ottenuto come bonus o penalità (a sua scelta) al tiro della creatura.\nPuò farlo dopo che la creatura ha effettuato il tiro, ma prima che qualsiasi effetto del tiro si verifichi.\n\n---\n\n**CAOS** **CONTROLLATO**\nAl 14° livello, lo stregone ottiene un minimo di controllo sugli impulsi della sua magia selvaggia.\nOgni volta che tira sulla tabella "Impulsi di Magia Selvaggia\', può tirare due volte e scegliere quale numero usare.\n\n---\n\n**BOMBARDAMENTO** **MAGICO**\nA partire dal 18° livello, l\'energia dannosa degli incantesimi dello stregone si intensifica.\nQuando lo stregone tira per i danni di un incantesimo e ottiene il più alto numero possibile su qualsiasi dado, sceglie uno di quei dadi, lo tira di nuovo e aggiunge il nuovo risultato ai danni.\nPuò utilizzare questo privilegio soltanto una volta per turno.\n\n---\n\n**IMPULSI** **DI** **MAGIA** **SELVAGGIA**\n\nD100     Effetto\n1-2      Lo stregone tira su questa tabella all\'inizio di ogni suo turno per il minuto successivo, ignorando questo risultato ai tiri successivi.\n3-4      Per il minuto successivo, lo stregone è in grado di vedere qualsiasi creatura invisibile, se dispone di linea di vista fino a essa.\n5-6      Un modron scelto e controllato dal **DM** compare in uno spazio libero a l,S metri dallo stregone, poi scompare 1 minuto dopo.\n7-8      Lo stregone lancia palla di fuoco come incantesimo di 3° livello centrato su se stesso.\n9-10     Lo stregone lancia dardo incantato come incantesimo di 5° livello.\n11-12    Lo stregone tira un d1O. La sua altezza cambia di una misura pari a 2,5 cmx il risultato ottenuto. Se il risultato è dispari, si rimpicciolisce. Se è pari, cresce.\n13-14    Lo stregone lancia confusione centrato su se stesso.\n15-16    Per il minuto successivo, lo stregone recupera 5 punti ferita all\'inizio di ogni suo turno.\n17-18    Lo stregone sviluppa una lunga barba fatta di piume che rimane finché non starnutisce. Quando questo accade, le piume schizzano via dal suo volto in un\'esplosione innocua.\n19-20    Lo stregone lancia unto centrato su se stesso.\n21-22    Le creature subiscono svantaggio ai tiri salvezza contro il prossimo incantesimo che sia lanciato dallo stregone nel minuto successivo e che richieda un tiro salvezza.\n23-24    La pelle dello stregone si tinge di una vivace tonalità di azzurro. Un incantesimo rimuovi maledizione può porre termine a questo effetto.\n25-26    Un occhio appare sulla fronte dello stregone per il minuto successivo. Durante quel periodo, lo stregone dispone di vantaggio alle prove di Saggezza (Percezione) basate sulla vista.\n27-28    Per il minuto successivo, tutti gli incantesimi dello stregone con un tempo di lancio pari a 1 azione hanno un tempo di lancio di 1 azione bonus.\n29-30    Lo stregone si teletrasporta fino a 18 metri di distanza, in uno spazio libero a sua scelta che egli sia in grado di vedere.\n31-32    Lo stregone viene trasportato sul Piano Astrale fino alla fine del suo turno successivo, poi ritorna nello spazio che occupava in precedenza o nello spazio libero più vicino, se quello spazio è ora occupato.\n33-34    Lo stregone massimizza i danni del successivo incantesimo che infligge danni e che lancerà entro il minuto successivo.\n35-36    Lo stregone tira un d1O. La sua età cambia di un numero di anni pari al risultato del tiro. Se il risultato è dispari, lo stregone ringiovanisce (lino a un minimo di un anno di età). Se il tiro è pari, invecchia.\n37-38    1d6 flumph controllati dal **DM** appaiono su altrettanti spazi liberi entro 18 metri dallo stregone e sono spaventati da lui. Svaniscono dopo 1 minuto.\n39-40    Lo stregone recupera 2d10 punti ferita.\n41-42    Lo stregone si trasforma in una pianta in vaso fino all\'inizio del suo turno successivo. Finché è una pianta, è incapacitato e subisce vulnerabilità a tutti i danni. Se lo stregone scende a O punti ferita, il vaso si rompe e lo stregone torna alla sua forma normale.\n43-44    Per il minuto successivo, lo stregone può teletrasportarsi di un massimo di 6 metri come azione bonus in ognuno dei suoi turni.\n45-46    Lo stregone lancia levitazione su se stesso.\n47-48    Un unicorno controllato dal **DM** appare in uno spazio entro 1,5 metri dallo stregone, poi scompare 1 minuto dopo.\n49-50    Lo stregone non può parlare per il minuto successivo. Ogni volta che prova a farlo, alcune bolle rosa escono fluttuando dalla sua bocca.\n51-52    Uno scudo spettrale fluttua accanto allo stregone per il minuto successivo, conferendogli un bonus di +2 alla **CA** e l\'immunità a dardo incantato.\n53-54    Lo stregone è immune all\'intossicazione alcolica per i 5d6 giorni successivi.\n55-56    Lo stregone perde tutti i capelli, che però ricrescono nel giro di 24 ore.\n57-58    Per il minuto successivo, ogni oggetto infiammabile toccato dallo stregone e che non sia indossato o trasportato da un\'altra creatura prende fuoco.\n59-60    Lo stregone recupera lo slot incantesimo di livello più basso che ha speso.\n61-62    Per il minuto successivo, lo stregone deve gridare quando parla.\n63-64    Lo stregone lancia nube di nebbia centrato su se stesso.\n65-66    Fino a tre creature scelte dallo stregone e situate entro 9 metri da lui subiscono 4d10 danni da fulmine.\n67-68    Lo stregone è spaventato dalla creatura più vicina fino alta fine del proprio turno successivo.\n69-70    Ogni creatura entro 9 metri dallo stregone diventa invisibile per il minuto successivo. L\'invisibilità su una creatura termina quando quella creatura attacca o lancia un incantesimo.\n71-72    Lo stregone ottiene resistenza a tutti i danni per il minuto successivo.\n73-74    Una creatura casuale entro 18 metri dallo stregone diventa avvelenata per 1d4 ore.\n75-76    Lo stregone risplende di luce intensa entro un raggio di 9 metri per il minuto successivo. Ogni creatura che termina il suo turno entro l,5 metri dallo stregone è accecata fino alla fine del proprio turno successivo.\n77-78    Lo stregone lancia metamorfosi su se stesso. Se fallisce il tiro salvezza, si trasforma in una pecora per la durata dell\'incantesimo.\n79-80    Farfalle e petali di fiori illusori fluttuano nell\'aria entro 3 metri dallo stregone per il minuto successivo.\n81-82    Lo stregone può effettuare un\'azione aggiuntiva immediatamente.\n83-84    Ogni creatura entro 9 metri dallo stregone subisce 1d1O danni necrotici. lo stregone recupera un numero di punti ferita pari alla somma dei danni necrotici inferti.\n85-86    Lo stregone lancia immagine speculare.\n87-88    Lo stregone lancia volare su una creatura casuale situata entro 18 metri da lui.\n89-90    Lo stregone diventa Invisibile per il minuto successivo. Durante quel periodo le altre creature non possono udirlo. L\'invisibilità termina se lo stregone attacca o lancia un incantesimo.\n91-92    Se lo stregone muore entro il minuto successivo, torna in vita immediatamente, come per l\'effetto dell\'incantesimo reincarnazione.\n93-94    La taglia dello stregone aumenta di una categoria per il minuto successivo.\n95-96    Lo stregone e tutte le creature entro 9 metri da lui ottengono vulnerabilità ai danni perforanti per il minuto successivo.\n97-98    Lo stregone è circondato da una debole musica eterea per il minuto successivo.\n99-100   Lo stregone recupera tutti i punti stregoneria spesi.\n'),
  ilGrandeAntico('Il grande antico',
      '**LISTA** **AMPLIATA** **DEGLI** **INCANTESIMI**\nIl Grande Antico consente al warlock di accedere a una lista ampliata di incantesimi quando deve apprendere un incantesimo da warlock.\nIl warlock aggiunge gli incantesimi seguenti alla sua lista degli incantesimi da warlock.\n\n---\n\n**INCANTESIMI** **AMPLIATI** **DEL** **GRANDE** **ANTICO**\n---\n\n**LIVELLO**    **INCANTESIMI**\n1°      risata incontenibile di Tasha, sussurri dissonanti\n2°      allucinazione di forza, individuazione dei pensieri\n3°      chiaroveggenza, inviare\n4°      dominare bestie, tentacoli neri di Evard\n5°      dominare persone, telecinesi\n\n---\n\n**MENTE** **RISVEGLIATA**\nA partire dal 1° livello, il warlock può usare le sue conoscenze aliene per sfiorare le menti delle altre creature.\nPuò parlare telepaticamente con qualsiasi creatura che si trovi entro 9 metri da lui e che egli sia in grado di vedere.\nNon è necessario che condivida un linguaggio con la creatura affinché quest\'ultima capisca ciò che egli enuncia telepaticamente, ma la creatura deve essere in grado di capire almeno un linguaggio.\n\n---\n\n**INTERDIZIONE** **ENTROPICA**\nAl 6° livello, il warlock impara a proteggersi magicamente dagli attacchi e a trasformare il colpo fallito di un nemico in un colpo di fortuna per lui.\nQuando una creatura effettua un tiro per colpire contro di lui, il warlock può usare la sua reazione per infliggere svantaggio a quel tiro.\nSe l\'attacco lo manca, il successivo tiro per colpire del warlock contro la creatura dispone di vantaggio purché il warlock lo effettui entro la fine del proprio turno successivo.\nUna volta utilizzato questo privilegio, il warlock non può più utilizzarlo finché non completa un riposo breve o lungo.\n\n---\n\n**SCUDO** **DEL** **PENSIERO**\nA partire dal 10° livello, i pensieri del warlock non possono essere letti tramite telepatia o mezzi di altro tipo, a meno che il warlock non lo consenta.\nInoltre, il warlock dispone di resistenza ai danni psichici, e ogni volta che una creatura infligge danni psichici al warlock, essa subisce lo stesso ammontare di danni.\n\n---\n\n**CREARE** **SERVITORE**\nAl 14° livello, il warlock ottiene la capacità di contaminare la mente di un umanoide con la magia aliena del suo patrono.\nPuò usare la sua azione per toccare un umanoide incapacitato.\nQuella creatura diventa affascinata dal warlock finché su di essa non viene lanciato un incantesimo rimuovi maledizione, la condizione non viene rimossa, o il warlock non utilizza di nuovo questo privilegio.\nIl warlock può comunicare telepaticamente con la creatura affascinata fintanto che entrambi si trovano sullo stesso piano di esistenza.'),
  ilSignoreFatato('Il signore fatato',
      '**LISTA** **AMPLIATA** **DEGLI** **INCANTESIMI**\nIl Signore Fatato consente al warlock di accedere a una lista ampliata di incantesimi quando deve apprendere un incantesimo da warlock.\nIl warlock aggiunge gli incantesimi seguenti alla sua lista degli incantesimi da warlock.\n\n---\n\n**INCANTESIMI** **AMPLIATI** **DEL** **SIGNORE** **FATATO**\n---\n\n**LIVELLO**    **INCANTESIMI**\n1°      luminescenza, sonno\n2°      allucinazione di forza, calmare emozioni\n3°      crescita vegetale, intermittenza\n4°      dominare bestie, invisibilità superiore\n5°      dominare persone, sembrare\n\n---\n\n**PRESENZA** **FATATA**\nA partire dal 1° livello, il patrono conferisce al warlock la capacità di emanare la presenza seducente e inquietante tipica dei folletti.\nCon un\'azione, il warlock può obbligare ogni creatura entro un cubo con spigolo di 3 metri originato da lui a effettuare un tiro salvezza su Saggezza contro la **CD** degli incantesimi del warlock.\nLe creature che falliscono il loro tiro salvezza sono tutte affascinate o spaventate dal warlock (a scelta di quest\'ultimo) fino alla fine del suo turno successivo.\nUna volta utilizzato questo privilegio, il warlock non può più utilizzarlo finché non completa un riposo breve o lungo.\n\n---\n\n**FUGA** **VELATA**\nA partire dal 6° livello, il warlock può svanire in uno sbuffo di nebbia in risposta a un effetto dannoso.\nQuando il warlock subisce danni, può usare la sua reazione per diventare invisibile e teletrasportarsi di un massimo di 18 metri fino a uno spazio libero che egli sia in grado di vedere.\nRimane invisibile fino all\'inizio del suo turno successivo o finché non attacca o lancia un incantesimo.\nUna volta utilizzato questo privilegio, il warlock non può più utilizzarlo finché non completa un riposo breve o lungo.\n\n---\n\n**DIFESE** **SEDUCENTI**\nA partire dal 10° livello, il patrono insegna al warlock come ritorcere le magie di influenza mentale dei suoi nemici contro loro stessi.\nIl warlock non può essere affascinato e quando un\'altra creatura tenta di affascinarlo, il warlock può usare la sua reazione per ritorcere l\'effetto contro quella creatura.\nLa creatura deve superare un tiro salvezza su Saggezza contro la **CD** degli incantesimi del warlock, altrimenti sarà affascinata dal warlock per 1 minuto o finché non subisce danni.\n\n---\n\n**DELIRIO** **OSCURO**\nA partire dal 14° livello, il warlock può trascinare una creatura in un reame illusorio.\nCon un\'azione, il warlock sceglie una creatura situata entro 18 metri da lui e che egli sia in grado di vedere.\nQuella creatura deve effettuare un tiro salvezza su Saggezza contro la **CD** degli incantesimi del warlock.\nSe lo fallisce, diventa affascinata o spaventata dal warlock (a scelta di quest\'ultimo) per 1 minuto o finché la concentrazione del warlock non si interrompe (come se si stesse concentrando su un incantesimo).\nQuesto effetto termina anticipatamente se la creatura subisce danni.\nFinché questa illusione non termina, la creatura crede di essersi smarrita in un reame nebbioso, il cui aspetto è deciso dal warlock.\nLa creatura è in grado di vedere e sentire soltanto se stessa, il warlock e l\'illusione.\nPrima di utilizzare di nuovo questo privilegio, il warlock deve completare un riposo breve o lungo.'),
  lImmondo('L\' immondo',
      '**LISTA** **AMPLIATA** **DEGLI** **INCANTESIMI**\nL\'Immondo consente al warlock di accedere a una lista ampliata di incantesimi quando deve apprendere un incantesimo da warlock.\nIl warlock aggiunge gli incantesimi seguenti alla sua lista degli incantesimi da warlock.\n\n---\n\n**INCANTESIMI** **AMPLIATI** **DELL**\'**IMMONDO**\n---\n\n**LIVELLO**    **INCANTESIMI**\n1°      comando, mani brucianti\n2°      cecità/sordità, raggio rovente\n3°      nube maleodorante, palla di fuoco\n4°      muro di fuoco, scudo di fuoco\n5°      colpo infuocato, santificare\n\n---\n\n**BENEDIZIONE** **DELL**\'**OSCURO**\nA partire dal 1° livello, quando il warlock porta una creatura ostile a 0 punti ferita, ottiene un ammontare di punti ferita temporanei pari al proprio modificatore di Carisma + il proprio livello da warlock (fino a un minimo di 1).\n\n---\n\n**FORTUNA** **DELL**\'**OSCURO**\nA partire dal 6° livello, il warlock può appellarsi al suo patrono per alterare il fato in suo favore.\nQuando effettua una prova di caratteristica o un tiro salvezza, può utilizzare questo privilegio per aggiungere un d10 al suo tiro.\nPuò farlo dopo avere visto il tiro iniziale, ma prima che qualsiasi effetto del tiro sia applicato.\nUna volta utilizzato questo privilegio, il warlock non può più utilizzarlo finché non completa un riposo breve o lungo.\n\n---\n\n**RESILIENZA** **IMMONDA**\nA partire dal 10° livello, il warlock può scegliere un tipo di danno quando completa un riposo breve o lungo.\nOttiene resistenza a quel tipo di danno finché non ne sceglie uno diverso tramite questo privilegio.\nI danni delle armi magiche o delle armi argentate ignorano questa resistenza.\n\n---\n\n**SCAGLIARE** **ALL**\'**INFERNO**\nA partire dal 14° livello, quando il warlock colpisce una creatura con un attacco, può utilizzare questo privilegio per trascinare istantaneamente il bersaglio sui piani inferiori.\nLa creatura scompare e sfreccia attraverso un territorio da incubo.\nAlla fine del turno successivo del warlock, il bersaglio torna nello spazio che occupava in precedenza, o nello spazio libero più vicino.\nSe il bersaglio non è un immondo, subisce 10d10 psichici in quanto resta sconvolto da questa esperienza terrificante.\nUna volta utilizzato questo privilegio, il warlock non può più utilizzarlo finché non completa un riposo lungo.');

  @override
  final String title, description;

  const SubClass(this.title, this.description);
}

enum Class implements EnumWithTitle {
  barbaro(
      'Barbaro',
      [
        SubClass.camminoDelBerserker,
        SubClass.camminoDelCombattenteTotemico,
      ],
      false,
      [
        SubSkill.atletica,
        SubSkill.natura,
        SubSkill.addestrareAnimali,
        SubSkill.percezione,
        SubSkill.sopravvivenza,
        SubSkill.intimidire,
      ],
      2,
      [
        Mastery.armatureLeggere,
        Mastery.armatureMedie,
        Mastery.scudi,
        Mastery.armiSemplici,
        Mastery.armiDaGuerra
      ],
      0,
      [],
      [Skill.forza, Skill.costituzione],
      [
        {
          Weapon.alabarda: 1,
          Weapon.asciaBipenne: 1,
          Weapon.asciaDaBattaglia: 1,
          Weapon.falcione: 1,
          Weapon.frusta: 1,
          Weapon.lanciaDaCavaliere: 1,
          Weapon.maglio: 1,
          Weapon.martelloDaGuerra: 1,
          Weapon.mazzafrusto: 1,
          Weapon.morningStar: 1,
          Weapon.picca: 1,
          Weapon.picconeDaGuerra: 1,
          Weapon.scimitarra: 1,
          Weapon.spadaCorta: 1,
          Weapon.spadaLunga: 1,
          Weapon.spadone: 1,
          Weapon.stocco: 1,
          Weapon.tridente: 1,
        },
        {
          Weapon.ascia: 2,
          // Weapon.ascia:1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {Weapon.giavellotto: 4},
        {Equipment.dotazioneDaEsploratore: 1},
      ],
      'Un barbaro ottiene i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d12 per livello da barbaro\nPunti Ferita al 1° Livello: 12 + il modificatore di Costituzione del barbaro\nPunti Ferita ai Livelli Successivi: 1d12 (o 7) + il modificatore di Costituzione del barbaro per ogni livello da barbaro oltre il 1°\n\n---\n\n**COMPETENZE**\nArmature: Armature leggere, armature medie, scudi\nArmi: Armi semplici, armi da guerra\nStrumenti: Nessuno\nTiri Salvezza: Forza, Costituzione\nAbilità: Due a scelta tra Addestrare Animali, Atletica, Intimidire, Natura, Percezione e Sopravvivenza.\n\n---\n\n**EQUIPAGGIAMENTO**\nUn barbaro inizia con l\'equipaggiamento seguente,in aggiunta all\'equipaggiamento conferito dal suo background:\n(a) un\'ascia bipenne o (b) qualsiasi arma da guerra da mischia\n(a) due asce o (b) una qualsiasi arma semplice\nUna dotazione da esploratore e quattro giavellotti\n\n---\n\n**IRA**\nIn battaglia, un barbaro combatte animato da ferocia primordiale.\nNel suo turno, può entrare in ira con un’azione bonus.\nFinché è in ira, ottiene i seguenti benefici, se non indossa un\'armatura pesante:\n-Dispone di vantaggio alle prove di Forza e ai Tiri Salvezza su Forza.\n-Quando effettua un attacco con arma da mischia usando Forza, ottiene un bonus al tiro per i danni che aumenta man mano che egli ottiene nuovi livelli da barbaro, come indicato nella colonna \'Danni dell\'Ira" nella tabella "Barbaro".\n-Un barbaro dispone di resistenza ai danni contundenti, perforanti e taglienti.\n-Se un barbaro è in grado di lanciare incantesimi, non può lanciarli o concentrarsi su di essi quando è in ira.\nL\'Ira del barbaro dura 1 minuto.\nTermina anticipatamente se cade Privo di Sensi o se il suo turno termina e non ha attaccato alcuna creatura ostile dal suo ultimo turno o non ha subito danni da allora.\nUn barbaro può anche porre fine alla sua ira nel proprio turno, come un’azione bonus.\nUna volta entrato in ira per il numero di volte indicato dal suo livello di barbaro nella colonna "Ira" nella tabella "Barbaro", un barbaro deve completare un riposo lungo prima di poter entrare di nuovo in ira.\n\n---\n\n**DIFESA** **SENZA** **ARMATURA**\nFinché un barbaro non indossa alcuna armatura, la sua Classe Armatura è pari a 10 + il suo modificatore di Destrezza + il suo modificatore di Costituzione.\nUn barbaro può usare uno scudo e ottenere comunque questo beneficio.\n\n---\n\n**ATTACCO** **IRRUENTO**\nA partire dal 2° livello, un barbaro può ignorare ogni preoccupazione per la sua difesa e attaccare in preda a una feroce disperazione.\nQuando effettua il suo primo attacco nel suo turno, può decidere di sferrare un attacco irruento.\nCosì facondo dispone di vantaggio ai tiri per colpire in mischia che usano Forza durante questo turno, ma i tiri per colpire contro di lui dispongono di vantaggio fino a suo turno successivo.\n\n---\n\n**PERCEZIONE** **DEL** **PERICOLO**\nDal 2° livello, un barbaro ottiene un percezione prodigiosa di tutto ciò che nei paraggi non è come dovrebbe essere cosa che agevola quando deve schivare i pericoli.\nUn barbaro dispone di vantaggio ai Tiri Salvezza su Destrezza contro effetti che può vedere, come trappole e incantesimi.\nPer ottenere questo beneficio, non deve essere accecato, assordato o Incapacitato.\n\n---\n\n**CAMMINO** **PRIMORDIALE**\nAl 3° livello, un barbaro sceglie un Cammino Primordiale che definisce la natura della sua furia.\nQuesta scelta ti conferisce alcuni privilegi al 3° livello, e poi di nuovo al 6°, 10° e 14° livello.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello, e poi ancora all’8°, 12°, 16° e 19° livello, un barbaro può aumentare di 2 un punteggio di caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica a più di 20 utilizzando questo privilegio.\n\n---\n\n**ATTACCO** **EXTRA**\nA partire dal 5° livello, un barbaro può attaccare due volte anziché una, ogni volta che effettua l\'azione di Attacco nel proprio turno.\n\n---\n\n**MOVIMENTO** **VELOCE**\nA partire dal 5° livello, la velocità del barbaro aumenta di 3 metri purché il barbaro non indossi un\'armatura pesante.\n\n---\n\n**ISTINTO** **FERINO**\nAl 7° livello, gli istinti del barbaro sono talmente affinati da fornirgli vantaggio ai tiri per l\'iniziativa.\nInoltre, se il barbaro è sorpreso all\'inizio del combattimento e non è incapacitato, può agire normalmente nel suo primo turno, ma solo se entra in ira prima di fare qualsiasi altra cosa in quel turno.\n\n---\n\n**CRITICO** **BRUTALE**\nA partire dal 9° livello, un barbaro può tirare un dado dell\'arma aggiuntivo quando determina i danni extra di un colpo critico con un attacco in mischia.\nQuesto effetto aumenta a due dadi aggiuntivi al 13° livello e a tre dadi aggiuntivi al 17° livello.\n\n---\n\n**IRA** **IMPLACABILE**\nA partire dall\'11° livello, grazie alla sua ira il barbaro può continuare a combattere nonostante le ferite più gravi.\nSe scende a 0 punti ferita mentre è in ira e non è ucciso sul colpo, può effettuare un Tiro Salvezza su Costituzione con **CD** 10.\nSe lo supera, rimane invece a 1 punto ferita.\nOgni volta che utilizza questo privilegio dopo la prima, la **CD** aumenta di 5.\nQuando completa un riposo breve o lungo la **CD** è ripristinata a 10.\n\n---\n\n**IRA** **PERSISTENTE**\nA partire dal 15° livello, l\'ira del barbaro è talmente feroce che termina prematuramente solo se il barbaro cade privo di sensi o se decide di porvi termine.\n\n---\n\n**POTENZA** **INDOMABILE**\nA partire dal 18° livello, se il totale di una prova di Forza del barbaro è inferiore al suo punteggio di Forza, il barbaro può usare il suo punteggio di Forza al posto del totale.\n\n---\n\n**CAMPIONE** **PRIMORDIALE**\nAl 20° livello, il barbaro diventa un\'incarnazione del potere delle terre selvagge.\nI suoi punteggi di Forza e Costituzione aumentano di 4.\nIl suo massimo per quei punteggi diventa 24.'),
  bardo(
      'Bardo',
      [
        SubClass.collegioSapienza,
        SubClass.collegioValore,
      ],
      true,
      [
        SubSkill.atletica,
        SubSkill.acrobazia,
        SubSkill.furtivita,
        SubSkill.rapiditaDiMano,
        SubSkill.arcano,
        SubSkill.storia,
        SubSkill.indagare,
        SubSkill.natura,
        SubSkill.religione,
        SubSkill.addestrareAnimali,
        SubSkill.intuizione,
        SubSkill.medicina,
        SubSkill.percezione,
        SubSkill.sopravvivenza,
        SubSkill.inganno,
        SubSkill.intimidire,
        SubSkill.intrattenere,
        SubSkill.persuasione,
      ],
      3,
      [
        Mastery.armatureLeggere,
        Mastery.armiSemplici,
        Mastery.balestreAMano,
        Mastery.spadeCorte,
        Mastery.spadeLunghe,
        Mastery.stocchi
      ],
      3,
      [MasteryType.strumentiMusicali],
      [Skill.destrezza, Skill.carisma],
      [
        {
          Weapon.stocco: 1,
          Weapon.spadaLunga: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {
          Item.ciaramella: 1,
          Item.cornamusa: 1,
          Item.corno: 1,
          Item.dulcimer: 1,
          Item.flauto: 1,
          Item.flautoDiPan: 1,
          Item.lira: 1,
          Item.liuto: 1,
          Item.tamburo: 1,
          Item.viola: 1,
        },
        {Equipment.unArmaturaDiCuoioEUnPugnale: 1},
        {
          Equipment.dotazioneDaDiplomatico: 1,
          Equipment.dotazioneDaIntrattenitore: 1
        },
      ],
      'Un bardo ottiene i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d8 per ogni livello da bardo\nPunti Ferita al 1° Livello: 8 + il modificatore di Costituzione del bardo\nPunti Ferita ai Livelli Successivi: 1d8 (o 5) + il modificatore di Costituzione del bardo per ogni livello da bardo dopo il 1°\n\n---\n\n**COMPETENZE**\nArmature: Armature leggere\nArmi: Armi semplici, balestre a mano, spade corte, spade lunghe, stocchi\nStrumenti: Tre strumenti musicali a scelta del bardo\nTiri Salvezza: Destrezza, Carisma\nAbilità: Tre a scelta\n\n---\n\n**EQUIPAGGIAMENTO**\nUn bardo inizia con l\'equipaggiamento seguente, in aggiunta all\'equipaggiamento conferito dal suo background:\n(a) uno stocco, (b) una spada lunga o (c) una qualsiasi arma semplice\n(a) una dotazione da diplomatico o (b) una dotazione da intrattenitore\n(a) un liuto o (b) un qualsiasi altro strumento musicale\nUn\'armatura di cuoio e un pugnale\n\n---\n\n**INCANTESIMI**\nUn bardo ha imparato a districare e rimodellare la trama della realtà in armonia con i suoi desideri tramite la musica.\nI suoi incantesimi fanno parte del suo vasto repertorio come magie che il bardo può mettere in sintonia con le situazioni più disparate.\n\n---\n\n**TRUCCHETTI**\nUn bardo conosce due trucchetti a sua scelta tratti dalla lista degli incantesimi da bardo.\nApprende ulteriori trucchetti da bardo a sua scelta ai livelli successivi, come indicato dalla colonna \'Trucchetti Conosciuti" nella tabella.\n\n---\n\n**SLOT** **INCANTESIMO**\nLa tabella indica quanti slot incantesimo possiede un bardo per lanciare i suoi incantesimi di 1° livello e di livello superiore.\nPer lanciare uno di questi incantesimi, il bardo deve spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nIl bardo recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nPer esempio, se un bardo conosce l\'incantesimo di 1° livello Cura Ferite e possiede uno slot incantesimo di 1° livello e uno slot incantesimo di 2° livello, può lanciare Cura Ferite usando uno qualsiasi dei due slot.\n\n---\n\n**INCANTESIMI** **CONOSCIUTI** **DI** 1° **LIVELLO** E **DI** **LIVELLO** **SUPERIORE**\nUn bardo conosce quattro incantesimi di 1° livello a sua scelta dalla lista degli incantesimi da bardo.\nLa colonna "Incantesimi Conosciuti" nella tabella indica quando un bardo impara altri incantesimi da bardo a sua scelta.\nOgnuno di questi incantesimi deve appartenere a un livello di cui il bardo possiede degli slot incantesimo, come indicato nella tabella.\nPer esempio, quando un bardo arriva al 3° livello, può imparare un nuovo incantesimo di 1° o di 2° livello.\nInoltre, quando un bardo acquisisce un livello, può scegliere un incantesimo da bardo che conosce e sostituirlo con un altro incantesimo della lista degli incantesimi da bardo;\nanche il nuovo incantesimo deve essere di un livello di cui il bardo possiede degli slot incantesimo.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nCarisma è la caratteristica da incantatore per gli incantesimi da bardo.\nLa magia di un bardo fluisce dal cuore e dall\'anima che egli riversa in ogni esibizione della sua musica o della sua oratoria.\nUn bardo usa Carisma ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Carisma per definire la **CD** del tiro salvezza di un incantesimo da bardo da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell\'incantesimo = 8 + il bonus di competenza del bardo + il modificatore di Carisma del bardo.\nModificatore di attacco dell\'incantesimo = il bonus di competenza del bardo + il modificatore di Carisma del bardo.\n\n---\n\n**CELEBRARE** **RITUALI**\nUn bardo può lanciare qualsiasi incantesimo da bardo da lui conosciuto come rituale se quell\'incantesimo possiede il descrittore Rituale.\n\n---\n\n**FOCUS** **DA** **INCANTATORE**\nUn bardo può usare uno strumento musicale come focus da incantatore per i suoi incantesimi da bardo.\n\n---\n\n**ISPIRAZIONE** **BARDICA**\nUn bardo può ispirare gli altri tramite il lirismo delle sue parole o della sua musica.\nPer farlo usa un\'azione bonus nel suo turno per scegliere una creatura diversa da sé stesso, situata entro 18 metri da lui e in grado di sentirlo.\nQuella creatura ottiene un dado di Ispirazione Bardica, un d6.\nPer una volta entro i 10 minuti successivi, quella creatura può tirare il dado e aggiungere il risultato ottenuto a una prova di caratteristica, un tiro per colpire o un tiro salvezza da essa effettuato.\nLa creatura può aspettare di avere tirato il d20 prima di decidere se utilizzare il dado di Ispirazione Bardica, ma deve decidere se utilizzarlo o meno prima che il **DM** dichiari se il tiro abbia avuto successo o meno.\nUna volta tirato il dado di Ispirazione Bardica, quel dado è perduto.\nUna creatura può possedere un solo dado di Ispirazione Bardica alla volta.\nIl bardo può utilizzare questo privilegio un numero di volte pari al suo modificatore di Carisma (fino a un minimo di una volta).\nRecupera tutti gli utilizzi spesi quando completa un riposo lungo.\nIl dado di Ispirazione Bardica cambia quando il bardo raggiunge livelli superiori.\nIl dado diventa un d8 al 5° livello, un d10 al 10° livello e un d12 al 15° livello.\n\n---\n\n**FACTOTUM**\nA partire dal 2° livello, un bardo può aggiungere metà del suo bonus di competenza, arrotondato per difetto, a ogni prova di caratteristica da lui effettuata che non includa già il suo bonus di competenza.\n\n---\n\n**CANTO** **DI** **RIPOSO**\nDal 2° livello, un bardo può usare una musica o un\'orazione lenitiva per infondere nuova vita nei suoi alleati durante un riposo breve.\nSe il bardo o le eventuali creature amiche in grado di udire la sua esibizione recuperano punti ferita alla fine di un riposo breve spendendo uno o più Dadi Vita, ognuna di quelle creature recupera 1d6 punti ferita extra.\nI punti ferita extra aumentano quando il bardo raggiunge livelli superiori: 1d8 al 9° livello, 1d10 al 13° livello e 1d12 al 17° livello.\n\n---\n\n**COLLEGIO** **BARDICO**\nAl 3° livello, un bardo apprende le tecniche più avanzate di un collegio bardico a sua scelta come ad esempio il Collegio della Sapienza.\nIl collegio a sua scelta gli conferisce alcuni privilegi al 3° livello e poi di nuovo al 6° e al 14° livello.\n\n---\n\n**MAESTRIA**\nAl 3° livello, un bardo sceglie due tra le sue competenze nelle abilità.\nIl suo bonus di competenza raddoppia in ogni prova di caratteristica effettuata usando una delle competenza scelte.\nAl 10° livello, un bardo può scegliere altre due competenze nelle abilità per ottenere questo beneficio.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello e poi di nuovo all\'8°, 12°, 16° e 19° livello.\nun bardo può aumentare di 2 un punteggio di caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica a più di 20 utilizzando questo privilegio.\n\n---\n\n**FONTE** **DI** **ISPIRAZIONE**\nA partire dal 5° livello, un bardo recupera tutti i suoi utilizzi spesi di Ispirazione Bardica quando completa un riposo breve o lungo.\n\n---\n\n**CONTROFASCINO**\nAl 6° livello, un bardo ottiene la capacità di usare note musicali o parole del potere per interferire negli effetti di influenza mentale.\nCon un\'azione può iniziare un\'esibizione che dura fino alla fine del suo turno successivo.\nDurante quel periodo, il bardo e ogni creatura amica entro 9 metri da lui dispongono di vantaggio ai tiri salvezza per non essere affascinati o spaventati.\nUna creatura deve essere in grado di sentire il bardo per ottenere questo beneficio.\nL\'esibizione termina prematuramente se il bardo diventa incapacitato o è ridotto al silenzio, o se vi pone fine volontariamente (non è richiesta un\'azione per farlo).\n\n---\n\n**SEGRETI** **MAGICI**\nGiunto al 10° livello, un bardo ha attinto alle conoscenze magiche provenienti da una vasta gamma di discipline.\nIl bardo sceglie due incantesimi di qualsiasi classe, inclusa questa stessa classe.\nOgni incantesimo scelto deve essere di un livello che il bardo sia in grado di lanciare,come indicato nella tabella, oppure deve essere un trucchetto.\nGli incantesimi scelti contano come incantesimi da bardo e vanno inclusi nel numero specificato dalla colonna "Incantesimi Conosciuti" nella tabella.\nUn bardo apprende due incantesimi aggiuntivi di qualsiasi classe al 14° livello e poi di nuovo al 18° livello.\n\n---\n\n**ISPIRAZIONE** **SUPERIORE**\nAl 20° livello, quando il bardo tira per l\'iniziativa e non gli rimane alcun utilizzo di Ispirazione Bardica, ne recupera un utilizzo.'),
  chierico(
      'Chierico',
      [
        // SubClass.dominioDellaConoscenza,
        SubClass.dominioDellaGuerra,
        SubClass.dominioDellaLuce,
        SubClass.dominioDellaNatura,
        SubClass.dominioDellaTempesta,
        SubClass.dominioDellaVita,
        SubClass.dominioDellInganno,
      ],
      true,
      [
        SubSkill.storia,
        SubSkill.religione,
        SubSkill.intuizione,
        SubSkill.medicina,
        SubSkill.persuasione,
      ],
      2,
      [
        Mastery.armatureLeggere,
        Mastery.armiSemplici,
        Mastery.scudi,
        Mastery.armatureMedie,
      ],
      0,
      [],
      [Skill.saggezza, Skill.carisma],
      [
        {Weapon.mazza: 1, Weapon.martelloDaGuerra: 1},
        {
          Armor.corazzaDiScaglie: 1,
          Armor.armaturaDiCuoio: 1,
          Armor.cottaDiMaglia: 1,
        },
        {
          Equipment.unaBalestraLeggeraE20Quadrelli: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {
          Equipment.dotazioneDaSacerdote: 1,
          Equipment.dotazioneDaEsploratore: 1
        },
      ],
      'Un Chierico ottiene i seguenti privilegi di classe:\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d8 per ogni livello da chierico.\nPunti ferita al 1° livello: 8 + il modificatore di Costituzione del chierico.\nPunti ferita ai livelli successivi: 1d8 (o 5) + il modificatore di Costituzione del chierico per ogni livello da chierico dopo il 1°.\n\n---\n\n**COMPETENZE**\nArmatura: armatura leggera, armatura media, scudi\nArmi: armi semplici\nStrumenti: Nessuno\nTiri salvezza: Saggezza, Carisma\nAbilità: Due a scelta tra Medicina, Persuasione, Intuizione, Religione e Storia\n\n---\n\n**EQUIPAGGIAMENTO**\nUn Chierico inizia con l\'equipaggiamento seguente, in aggiunta all\'equipaggiamento conferito dal suo background:\n(a) una mazza o (b) un martello da guerra (se ha competenza)\n(a) una corazza di scaglie, (b) un\'armatura di cuoio o (c) una cotta di maglia (Se ha competenza)\n(a) una balestra leggera e 20 quadrelli o (b) una qualsiasi arma semplice\n(a) una dotazione da sacerdote o (b) una dotazione da esploratore\nUno scudo e un simbolo sacro\n\n---\n\n**INCANTESIMI**\nUn chierico è un tramite del potere divino, e come tale è in grado di lanciare incantesimi da chierico.\n\n---\n\n**TRUCCHETTI**\nAl 1° livello, un chierico conosce tre trucchetti a sua scelta tratti dalla lista degli incantesimi da chierico.\nApprende ulteriori trucchetti da chierico a sua scelta ai livelli successivi, come indicato nella colonna "Trucchetti Conosciuti" nella tabella "Chierico".\n\n---\n\n**PREPARARE** E **LANCIARE** **INCANTESIMI**\nLa tabella "Chierico" indica quanti slot incantesimo possiede un chierico per lanciare i suoi incantesimi di 1 ° livello e di livello superiore.\nPer Lanciare uno di questi incantesimi, è necessario spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nIl chierico recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nIl chierico prepara la lista degli incantesimi da chierico disponibili da lanciare scegliendoli dalla lista degli incantesimi da chierico.\nQuando lo fa, deve scegliere un numero di incantesimi da chierico pari al suo modificatore di Saggezza + il suo livello da chierico (fino a un minimo di un incantesimo).\nGli incantesimi devono essere di un livello di cui il chierico possiede degli slot incantesimo.\nAd esempio, un chierico di 3 ° livello, possiede quattro slot incantesimo di 1 ° livello e due slot incantesimo di 2 ° livello.\nCon Saggezza pari a 16, la lista dei suoi incantesimi preparati può includere sei incantesimi di 1° o 2° livello, in qualsiasi combinazione.\nSe prepara l\'incantesimo di 1° livello cura ferite , potrà lanciarlo usando uno slot incantesimo di 1° livello o di 2° livello.\nIl lancio di quell\'incantesimo non rimuove quell\'incantesimo dalla lista di incantesimi preparati.\nIl chierico può cambiare la tua lista dei suoi incantesimi preparati quando completa un lungo riposo.\nPer preparare una nuova lista di incantesimi da chierico è necessario un certo ammontare di tempo da trascorrere in preghiera e meditazione: almeno 1 minuto per livello di incantesimo per ogni incantesimo nella sua lista.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nSaggezza è la caratteristica da incantatore usata per gli incantesimi da chierico.\nIl potere degli incantesimi di un chierico deriva dalla sua devozione nei confronti della divinità.\nUn chierico usa saggezza ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Saggezza per definire la **CD** del tiro salvezza di un incantesimo da chierico da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell\'incantesimo = 8 + il bonus di competenza del chierico + il modificatore di saggezza del chierico.\nModificatore di attacco dell\'incantesimo = il bonus di competenza del chierico + il tuo modificatore di saggezza del chierico.\n\n---\n\n**CELEBRARE** **RITUALI**\nUn chierico può lanciare un incantesimo da chierico come rituale se quell\'incantesimo possiede il descrittore rituale e se il chierico ha preparato l\'incantesimo.\n\n---\n\n**FOCUS** **DA** **INCANTATORE**\nUn chierico può usare un simbolo sacro (vedi "Equipaggiamento") come focus da incantatore per i suoi incantesimi da chierico.\n\n---\n\n**DOMINIO** **DIVINO**\nIl chierico sceglie un dominio correlato alla sua divinità: Conoscenza, Guerra, Inganno, Luce, Natura, Tempesta o Vita.\nOgni dominio è descritto in dettagliato alla fine della sezione di questa classe e fornisce esempi di varie divinità a esso associate.\nQuesta scelta conferisce al chierico alcuni incantesimi di dominio e altri privilegi al 1° livello.\nConferisce inoltre ulteriori modi di utilizzare incanalare Divinità quando il chierico ottiene quel privilegio al 2° livello e ulteriori benefici al 6°, 8° e 17° livello.\n\n---\n\n**INCANTESIMI** **DI** **DOMINIO**\nA ogni dominio corrisponde una lista di incantesimi (gli incantesimi di dominio) che il chierico ottiene ai livelli da chierico indicati nella descrizione del dominio.\nQuando il chierico ottiene un incantesimo di dominio, quell\'incantesimo è sempre considerato preparato e non conta al fine di determinare il numero di incantesimi che il chierico può preparare ogni giorno.\nSe il chierico possiede un incantesimo di dominio che non compare sulla lista degli incantesimi da chierico, quell\'incantesimo è comunque considerato un incantesimo da chierico per lui.\n\n---\n\n**INCANALARE** DIVINITÀ\nAl 2° livello, un chierico ottiene la capacità di incanalare energia divina direttamente dalla sua divinità e usa quell\'energia per alimentare gli effetti magici.\nUn chierico parte con due effetti di questo tipo: Scacciare Non Morti e un effetto determinato dal suo dominio.\nAlcuni domini conferiscono al chierico degli effetti aggiuntivi man mano che avanza di livello, come indicato nella descrizione del dominio.\nQuando un chierico utilizza Incanalare Divinità, può scegliere quale effetto creare.\nDeve poi completare un breve o lungo riposo per utilizzare di nuovo Incanalare Divinità.\nAlcuni effetti di Incanalare Divinità richiedono dei tiri salvezza.\nQuando un chierico utilizza un tale effetto, la **CD** è pari alla **CD** del tiro salvezza dei suoi incantesimi da chierico.\nA partire dal 6° livello, un chierico può utilizzare Incanalare Divinità due volte tra un riposo e l\'altro, e a partire dal 18° livello, può utilizzarlo tre volte tra un riposo e l\'altro.\nQuando completa un breve o lungo riposo, recupera gli utilizzi spesi.\n\n---\n\n**INCANALARE** DIVINITÀ: **SCACCIARE** **NON** MORTOCon un\'azione, il chierico brandisce il suo simbolo sacro e pronuncia una preghiera di condanna nei confronti dei non morti.\nOgni non morto che è in grado di vedere o sentire il chierico e si trova entro 9 metri da lui deve effettuare un tiro salvezza su Saggezza.\nSe lo fallisce, la creatura è scacciata per 1 minuto o finché non subisce danni.\nUna creatura scacciata deve spendere i suoi turni tentando di allontanarsi il più lontano possibile dal chierico e non può volontariamente muoversi in uno spazio entro 9 metri dal chierico.\nInoltre, non può effettuare reazioni.\nCome sua azione, può usare solo l\'azione di scatto o tentare di fuggire da un effetto che gli impedisce di muoversi.\nSe non può muoversi in alcun luogo, la creatura può usare l\'azione di Schivata.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello, e poi di nuovo all\'8°, 12°, 16° e 19° livello, un chierico può aumentare di 2 un punteggio di caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica superiore a 20 utilizzando questo privilegio.\n\n---\n\n**DISTRUGGERE** **NON** **MORTI**\nA partire dal 5° livello, quando un non morto fallisce il suo tiro salvezza contro il privilegio Scacciare Non Morti del chierico, quella creatura viene immediatamente distrutta se il suo grado di sfida è pari o inferiore a una certa soglia.\n\n---\n\n**LIVELLO** **DA** **CHIERICO**       **DISTRUGGERE** I **NON** **MORTI** **DI** **GS**...\n         5°                        1/2 o inferiore\n         8°                        1 o inferiore\n         11°                       2 o inferiore\n         14°                       3 o inferiore\n         17°                       4 o inferiore\n\n---\n\n**INTERVENTO** **DIVINO**\nA partire dal 10° livello, un chierico può appellarsi alla propria divinità affinché intervenga a suo beneficio nel momento del bisogno.\nPer implorare l\'aiuto della sua divinità, il chierico deve usare un\'azione.\nDeve descrivere l\'assistenza che desidera ottenere e tirare un dado percentuale.\nSe ottiene con il tiro un numero pari o inferiore al suo livello da chierico, la divinità interviene.\nÈ Il **DM** a scegliere la natura dell\'intervento; l\'effetto di qualsiasi incantesimo da chierico o incantesimo da dominio clericale è appropriato.\nSe la divinità interviene, il chierico non può più utilizzare questo privilegio per 7 giorni.\nAltrimenti può utilizzarlo di nuovo dopo aver completato un lungo riposo.\nAl 20° livello, la richiesta di intervento del chierico ha successo automaticamente, senza che sia richiesto alcun tiro.'),
  druido(
      'Druido',
      [
        SubClass.circoloDellaLuna,
        SubClass.circoloDellaTerra,
      ],
      true,
      [
        SubSkill.arcano,
        SubSkill.natura,
        SubSkill.religione,
        SubSkill.addestrareAnimali,
        SubSkill.intuizione,
        SubSkill.medicina,
        SubSkill.percezione,
        SubSkill.sopravvivenza,
      ],
      2,
      [
        Mastery.armatureLeggere,
        Mastery.armatureMedie,
        Mastery.scudi,
        Mastery.bastoniFerrati,
        Mastery.dardi,
        Mastery.falcetti,
        Mastery.fionde,
        Mastery.giavellotti,
        Mastery.lance,
        Mastery.mazze,
        Mastery.pugnali,
        Mastery.randelli,
        Mastery.scimitarre,
        Mastery.strumentiDaErborista
      ],
      0,
      [],
      [Skill.intelligenza, Skill.saggezza],
      [
        {
          Armor.scudoDiLegno: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {
          Weapon.scimitarra: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
        },
        {Armor.armaturaDiCuoio: 1},
        {Equipment.dotazioneDaEsploratore: 1},
      ],
      'Un druido ottiene i seguenti privilegi di classe:\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d8 per livello da druido.\nPunti ferita al 1° livello: 8 + il tuo modificatore di Costituzione del druido.\nPunti ferita ai livelli successivi: 1d8 (o 5) + il modificatore di Costituzione del druido per ogni livello da druido dopo il 1°.\n\n---\n\n**COMPETENZE**\nArmature: Armature leggere, Armature medie, Scudi (i druidi non indossano armature e scudi fatti di metallo).\nArmi: mazza, pugnale, dardo, giavellotto, bastone ferrato, scimitarra, falcetto, fionda, lancia, randello.\nStrumenti: Borsa da Erborista.\nTiri Salvezza: Intelligenza e Saggezza.\nAbilità: Due a scelta tra Addestrare Animali, Arcano, Intuizione, Medicina, Natura, Percezione, Religione e Sopravvivenza.\n\n---\n\n**EQUIPAGGIAMENTO**\nUn druido inizia con il seguente equipaggiamento, in aggiunta all’ equipaggiamento fornito dal suo background:\n(a) uno scudo di legno o (b) una qualsiasi arma semplice.\n(a) una scimitarra o (b) una qualsiasi arma semplice da mischia.\nUn\'armatura di cuoio, una dotazione da esploratore e un focus druidico.\n\n---\n\n**DRUIDICO**\nUn druido conosce il Druidico, il linguaggio segreto del suo ordine: può parlare in quel linguaggio e usarlo per lasciare messaggi segreti.\nIl druido e coloro che conoscono questo linguaggio sono in grado di avvistare questi messaggi automaticamente.\nAltri possono notare la presenza di un messaggio in Druidico superando la prova Saggezza (Percezione) con **CD** 15, ma non possono decifrarlo senza l\'aiuto della magia.\n\n---\n\n**INCANTESIMI**\nUn druido attinge all\'essenza divina della natura stessa e può lanciare incantesimi che modellano tale essenza in base alla sua volontà.\nVedi il capitolo 10 per le regole generali relative alla magia e il capitolo 11 per la lista degli incantesimi da druido.\n\n---\n\n**TRUCCHETTI**\nAl 1° livello, un druido conosce due trucchetti a sua scelta dalla lista degli incantesimi da druido.\nApprende ulteriori trucchetti da druido a sua scelta ai livelli successivi, come indicato dalla colonna "Trucchetti Conosciuti" nella tabella.\n\n---\n\n**PREPARARE** E **LANCIARE** **INCANTESIMI**\nLa tabella indica quanti slot incantesimo possiede un druido per lanciare i suoi incantesimi di 1° livello e di livello superiore.\nPer lanciare uno di questi incantesimi, il druido deve spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nIl druido recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nIl druido prepara la lista degli incantesimi da druido disponibili da lanciare scegliendoli dalla lista degli incantesimi da druido.\nQuando lo fa, deve scegliere un numero di incantesimi da druido pari al suo modificatore di Saggezza + il suo livello da druido (fino a un minimo di un incantesimo).\nGli incantesimi devono essere di un livello di cui il druido possiede degli slot incantesimo.\nPer esempio, un druido di 3° livello possiede quattro slot incantesimo di 1° livello e due slot incantesimo di 2° livello.\nCon Saggezza pari a 16, la lista dei suoi incantesimi preparati può includere sei incantesimi di 1° o 2° livello, in qualsiasi combinazione.\nSe prepara l\'incantesimo di 1° livello cura ferite, potrà lanciarlo usando uno slot incantesimo di 1° livello o di 2° livello.\nIl lancio di quell\'incantesimo non rimuove quell\'incantesimo dalla lista di incantesimi preparati.\nIl druido può cambiare la lista dei suoi incantesimi preparati quando completa un riposo lungo.\nPer preparare una nuova lista di incantesimi da druido è necessario un certo ammontare di tempo da trascorrere in preghiera e meditazione: almeno 1 minuto per livello di incantesimo per ogni incantesimo nella sua lista.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nSaggezza è la caratteristica da incantatore usata per gli incantesimi da druido.\nIl potere dei suoi incantesimi deriva dalla sua devozione e dalla sua sintonia con la natura.\nUn druido usa Saggezza ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Saggezza per definire la **CD** del tiro salvezza di un incantesimo da druido da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell’incantesimo = 8 + il bonus di competenza del druido + il modificatore di Saggezza del druido.\nModificatore di attacco dell’incantesimo = il bonus di competenza del druido + il modificatore di Saggezza del druido.\n\n---\n\n**CELEBRARE** **RITUALI**\nUn druido può lanciare un incantesimo da druido come rituale se quell\'incantesimo possiede il descrittore rituale e il druido lo ha preparato.\n\n---\n\n**FOCUS** **DA** **INCANTATORE**\nUn druido può usare un focus druidico come focus da incantatore per i suoi incantesimi da druido.\n\n---\n\n**FORMA** **SELVATICA**\nA partire dal 2° livello, un druido può usare la sua azione per assumere magicamente la forma di una bestia che ha già visto in precedenza.\nPuò utilizzare questo privilegio due volte e recupera gli utilizzi spesi quando completa un riposo breve o lungo.\nIl livello da druido determina le bestie in cui egli può trasformarsi, come indicalo nella tabella "Forme Bestiali".\nAl 2° livello, per esempio, può trasformarsi in qualsiasi bestia che abbia un grado di sfida pari o inferiore a 1/4 che non abbia una velocità di nuotare o di volare.\nUn druido può rimanere in forma bestiale per un numero di ore pari alla metà del suo livello da druido (arrotondato per difetto), poi torna alla sua forma normale, a meno che non spenda un altro utilizzo di questo privilegio.\nPuò tornare alla sua forma normale anticipatamente usando un\'azione bonus nel suo turno.\nTorna automaticamente alla sua forma normale se cade privo di sensi, scende a 0 punti ferita o muore.\nFinché il druido è trasformato, si applicano le regole seguenti:- Le statistiche di gioco del druido vengono sostituite dalle statistiche della bestia, ma il druido conserva il proprio allineamento, personalità e punteggi di Intelligenza, Saggezza e Carisma.\nConserva inoltre tutte le sue abilità e competenze nei tiri salvezza, oltre a ottenere quelle della creatura.\nSe la creatura possiede una competenza che anche il druido possiede e il bonus nella sua scheda delle statistiche è superiore a quello del druido, egli usa il bonus della creatura anziché il proprio.\nSe la creatura possiede delle azioni leggendarie o di tana, il druido non può usarle.\n- Quando si trasforma, il druido assume i punti ferita e i Dadi Vita della bestia.\nQuando torna alla sua forma normale, torna al numero di punti ferita che possedeva prima della trasformazione.\nTuttavia, se torna alla sua forma normale per essere sceso a 0 punti ferita, gli eventuali danni in eccesso si trasmettono alla sua forma normale.\nPer esempio, se un druido in forma bestiale possiede 1 solo punto ferita e subisce 10 danni, egli torna alla sua forma normale e subisce 9 danni.\nFintanto che i danni in eccesso non portano la forma normale del druido a 0 punti ferita, il druido non cade privo di sensi.\n- Il druido non può lanciare incantesimi e la sua capacità di parlare o di intraprendere qualsiasi azione che richieda le mani è limitata alle capacità della sua forma bestiale.\nLa trasformazione non interrompe la concentrazione del druido su un incantesimo che egli ha già lanciato e non gli impedisce di effettuare azioni che fanno parte di un incantesimo già lanciato, come per esempio Invocare il Fulmine.\n- Un druido mantiene i benefici di tutti i privilegi forniti dalla sua classe, dalla sua razza e da qualsiasi altra fonte e può usarli se nella nuova forma è fisicamente in grado di farlo.\nTuttavia, non può usare nessuno dei suoi sensi speciali, come per esempio la scurovisione, a meno che non li possieda anche nella sua nuova forma.\n- Un druido può scegliere se lasciare cadere il suo equipaggiamento nel suo spazio, se tale equipaggiamento si fonde nella sua nuova forma o se indossarlo.\nL\'equipaggiamento indossato funziona normalmente, ma spetta al **DM** decidere se è pratico o meno che la nuova forma indossi ogni determinato oggetto di equipaggiamento, in base alla forma e alla taglia della creatura.\nL\'equipaggiamento del druido non cambia taglia o forma per adattarsi alla nuova forma, e ogni oggetto di equipaggiamento che la nuova forma non può indossare deve  cadere a terra o fondersi nella nuova forma del druido.\nL\'equipaggiamento fuso alla nuova forma non ha alcun effetto finché il druido non abbandona quella forma.\n\n---\n\n**FORME** **BESTIALI**\n---\n\n**LIVELLO**   **GS** **MAX**   **LIMITAZIONI**         **ESEMPIO**\n2°       1/4    nessuna velocità    Lupo\n         di nuotare o\n         di volare\n4°       1/2    nessuna velocità    Coccodrillo\n         di volare\n8°        1     ----------------    Aquila gigante\n\n---\n\n**CIRCOLO** **DRUIDICO**\nAl 2° livello, un druido sceglie di aderire a un circolo druidico, come quello della Terra.\nQuesta scelta gli conferisce alcuni privilegi al 2° livello e poi di nuovo al 6°, 10° e 14° livello.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello, e poi di nuovo all\'8°,12°,16° e 19° livello, un druido può aumentare di 2 un punteggio di caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica a più di 20 utilizzando questo privilegio.\n\n---\n\n**CORPO** **SENZA** **TEMPO**\nA partire dal 18° livello, la magia primordiale che fluisce nel druido rallenta il suo invecchiamento.\nPer ogni 10 anni trascorsi, il corpo del druido invecchia soltanto di 1 anno.\n\n---\n\n**INCANTESIMI** **BESTIALI**\nA partire dal 18° livello, un druido può lanciare molti dei suoi incantesimi da druido in qualsiasi forma assunta utilizzando Forma Selvatica.\nPuò fornire le componenti somatiche e verbali di un incantesimo da druido anche quando è in forma bestiale, ma non è in grado di fornire componenti materiali.\n\n---\n\n**ARCIDRUIDO**\nAl 20° livello, un druido può utilizzare Forma Selvatica un numero illimitato di volte.\nPuò inoltre ignorare le componenti verbali e somatiche dei suoi incantesimi da druido, nonché le eventuali componenti materiali prive di un costo e quelle che non sono consumate da un incantesimo.\nUn druido ottiene questo beneficio sia nella sua forma normale che nella forma bestiale assunta grazie a Forma Selvatica.'),
  guerriero(
      'Guerriero',
      [
        SubClass.campione,
        SubClass.maestroDiBattaglia,
        SubClass.cavaliereMistico,
      ],
      false,
      [
        SubSkill.atletica,
        SubSkill.acrobazia,
        SubSkill.storia,
        SubSkill.addestrareAnimali,
        SubSkill.intuizione,
        SubSkill.percezione,
        SubSkill.sopravvivenza,
        SubSkill.intimidire,
      ],
      2,
      [
        Mastery.tutteLeArmature,
        Mastery.scudi,
        Mastery.armiSemplici,
        Mastery.armiDaGuerra,
      ],
      0,
      [],
      [Skill.forza, Skill.costituzione],
      [
        {
          Armor.cottaDiMaglia: 1,
          Equipment.unArmaturaDiCuoioUnArcoLungoE20Frecce: 1
        },
        {
          Weapon.alabarda: 1,
          Weapon.asciaBipenne: 1,
          Weapon.asciaDaBattaglia: 1,
          Weapon.falcione: 1,
          Weapon.frusta: 1,
          Weapon.lanciaDaCavaliere: 1,
          Weapon.maglio: 1,
          Weapon.martelloDaGuerra: 1,
          Weapon.mazzafrusto: 1,
          Weapon.morningStar: 1,
          Weapon.picca: 1,
          Weapon.picconeDaGuerra: 1,
          Weapon.scimitarra: 1,
          Weapon.spadaCorta: 1,
          Weapon.spadaLunga: 1,
          Weapon.spadone: 1,
          Weapon.stocco: 1,
          Weapon.tridente: 1,
          Weapon.arcoLungo: 1,
          Weapon.balestraAMano: 1,
          Weapon.balestraPesante: 1,
          Weapon.cerbottana: 1,
          Weapon.rete: 1,
        },
        {
          Weapon.alabarda: 1,
          Weapon.asciaBipenne: 1,
          Weapon.asciaDaBattaglia: 1,
          Weapon.falcione: 1,
          Weapon.frusta: 1,
          Weapon.lanciaDaCavaliere: 1,
          Weapon.maglio: 1,
          Weapon.martelloDaGuerra: 1,
          Weapon.mazzafrusto: 1,
          Weapon.morningStar: 1,
          Weapon.picca: 1,
          Weapon.picconeDaGuerra: 1,
          Weapon.scimitarra: 1,
          Weapon.spadaCorta: 1,
          Weapon.spadaLunga: 1,
          Weapon.spadone: 1,
          Weapon.stocco: 1,
          Weapon.tridente: 1,
          Weapon.arcoLungo: 1,
          Weapon.balestraAMano: 1,
          Weapon.balestraPesante: 1,
          Weapon.cerbottana: 1,
          Weapon.rete: 1,
          Armor.scudo: 1,
        },
        {Equipment.unaBalestraLeggeraE20Quadrelli: 1, Weapon.ascia: 2},
        {
          Equipment.dotazioneDaAvventuriero: 1,
          Equipment.dotazioneDaEsploratore: 1
        },
      ],
      'Come guerriero, ottieni i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDado Vita: 1d10 per livello da guerriero\nPunti Ferita al 1° livello: 10 + il tuo modificatore di Costituzione\nPunti Ferita ai Livelli Più Alti: 1d10 (o 6) + il tuo modificatore di Costituzione per livello da guerriero oltre il 1°\n\n---\n\n**COMPETENZE**\nArmature: Tutte le armature, scudi\nArmi: Armi semplici, armi da guerra\nAttrezzi: Nessuno\nTiri Salvezza: Forza, Costituzione\nAbilità: Scegli due abilità tra Acrobazia, Addestrare Animali, Atletica, Intimidire, Intuizione, Percezione, Sopravvivenza e Storia\n\n---\n\n**EQUIPAGGIAMENTO**\nInizi con il seguente equipaggiamento, oltre all’equipaggiamento fornito dalla tuo background:\n(a) cotta di maglia o (b) armatura di cuoio, arco lungo e 20 frecce\n(a) un’arma da guerra e uno scudo o (b) due armi da guerra\n(a) una balestra leggera e 20 quadrelli o (b) due asce\n(a) uno zaino da speleologo o (b) uno zaino da esploratore\n\n---\n\n**STILE** **DI** **COMBATTIMENTO**\nCome tua specializzazione adotti un particolare stile di combattimento.\nScegli una delle seguenti opzioni.\Non puoi acquisire più di una volta lo stesso Stile di Combattimento, anche se in seguito ottieni una nuova scelta.\n\n---\n\n**COMBATTERE** **CON** **ARMI** **POSSENTI**\nQuando tiri 1 o 2 per il dado di danno di un attacco effettuato con un’arma da mischia che stai impugnando con due mani, puoi ritirare il dado e devi usare il nuovo risultato, anche se questo tiro fosse nuovamente 1 o 2.\nL’arma deve avere la proprietà due mani o versatile per farti ottenere questo beneficio.\n\n---\n\n**COMBATTERE** **CON** **DUE** **ARMI**\nQuando ti impegni nel combattimento con due armi, puoi sommare il tuo modificatore di caratteristica al danno del secondo attacco.\n\n---\n\n**DIFESA**\nQuando indossi un’armatura, ottieni un bonus di +1 alla **CA**.\n\n---\n\n**DUELLARE**\nQuando impugni un’arma da mischia in una mano e nessun’altra arma, ottieni un bonus di +2 ai tiri dei danni con quell’arma.\n\n---\n\n**PROTEZIONE**\nQuando una creatura che puoi vedere attacca un bersaglio diverso da te e che si trova entro 1,5 metri da te, puoi usare la tua reazione per imporre svantaggio al suo tiro per colpire.\nDevi impugnare uno scudo.\n\n---\n\n**TIRO**\nOttieni un bonus di +2 ai tiri per colpire effettuati con le armi a distanza.\n\n---\n\n**RECUPERARE** **ENERGIE**\nHai una fonte limitata di energia a cui puoi attingere per rimetterti dalle ferite.\nDurante il tuo turno, puoi usare un’azione bonus per recuperare punti ferita pari a 1d10 + il tuo livello da guerriero.\nUna volta impiegato questo privilegio, devi terminare un riposo breve o lungo prima di riutilizzarlo.\n\n---\n\n**AZIONE** **IMPETUOSA**\nA partire dal 2° livello, puoi spingerti oltre i tuoi normali limiti per brevi periodi di tempo.\nDurante il tuo turno, puoi eseguire un’azione aggiuntiva oltre alla tua normale azione e una possibile azione bonus.\nUna volta impiegato questo privilegio, devi terminare un riposo breve o lungo prima di riutilizzarlo.\nA partire dal 17° livello, puoi utilizzarlo due volte prima di riposare, ma solo una volta durante lo stesso turno.\n\n---\n\n**ARCHETIPO** **MARZIALE**\nAl 3° livello, puoi scegliere un archetipo da emulare con il tuo stile e le tue tecniche di combattimento, come quello del Campione.\nIl tuo archetipo ti conferisce privilegi al 3° livello e ancora al 7°, 10°, 15° e 18° livello.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando raggiungi il 4° livello, e poi ancora al 6°, 8°, 12°, 14°, 16° e 19° livello, puoi incrementare un tuo punteggio di caratteristica di 2, o incrementare due punteggi di caratteristica di 1.\nDi norma, utilizzando questo privilegio non puoi accrescere un punteggio di caratteristica oltre il 20.\n\n---\n\n**ATTACCO** **EXTRA**\nA partire dal 5° livello, puoi attaccare due volte, invece che una volta, ogni volta che effettui l’azione Attaccare durante il tuo turno.\nIl numero di attacchi incrementa a tre quando raggiungi l’11° livello in questa classe e a quattro quando raggiungi il 20° livello in questa classe.\n\n---\n\n**INDOMITO**\nA partire dal 9° livello, puoi ritirare un tiro salvezza che hai fallito.\nSe lo fai, devi usare il nuovo tiro, e non puoi più usare questo privilegio fino a quando non terminerai un riposo lungo.\nPuoi usare questo privilegio due volte tra ogni riposo lungo a partire dal 13° livello e tre volte tra ogni riposo lungo a partire dal 17° livello.'),
  ladro(
      'Ladro',
      [
        SubClass.furfante,
        SubClass.assassino,
        SubClass.mistificatoreArcano,
      ],
      false,
      [
        SubSkill.atletica,
        SubSkill.acrobazia,
        SubSkill.furtivita,
        SubSkill.rapiditaDiMano,
        SubSkill.storia,
        SubSkill.indagare,
        SubSkill.addestrareAnimali,
        SubSkill.intuizione,
        SubSkill.percezione,
        SubSkill.inganno,
        SubSkill.intimidire,
        SubSkill.persuasione,
      ],
      4,
      [
        Mastery.armatureLeggere,
        Mastery.armiSemplici,
        Mastery.balestreAMano,
        Mastery.spadeCorte,
        Mastery.spadeLunghe,
        Mastery.stocchi,
        Mastery.arnesiDaScasso,
      ],
      0,
      [],
      [Skill.destrezza, Skill.intelligenza],
      [
        {Weapon.stocco: 1, Weapon.spadaCorta: 1},
        {Equipment.unArcoCortoE20Frecce: 1, Weapon.spadaCorta: 1},
        {Equipment.unArmaturaDiCuoio2PugnaliEArnesiDaScasso: 1},
        {
          Equipment.dotazioneDaScassinatore: 1,
          Equipment.dotazioneDaAvventuriero: 1,
          Equipment.dotazioneDaEsploratore: 1,
        },
      ],
      'Come ladro, ottieni i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDado Vita: 1d8 per livello da ladro\nPunti Ferita al 1° livello: 8 + il tuo modificatore di Costituzione\nPunti Ferita ai Livelli Più Alti: 1d8 (o 5) + il tuo modificatore di Costituzione per livello da ladro oltre il 1°\n\n---\n\n**COMPETENZE**\nArmature: Armature leggere\nArmi: Armi semplici, balestre a mano, spade lunghe, stocchi, spade corte\nAttrezzi: Attrezzi da scasso\nTiri Salvezza: Destrezza, Intelligenza\nAbilità: Scegli quattro abilità tra Acrobazia, Atletica, Furtività, Indagare, Inganno, Intimidire, Intrattenere, Intuizione, Percezione, Persuasione, Rapidità di Mano\n\n---\n\n**EQUIPAGGIAMENTO**\nInizi con il seguente equipaggiamento, oltre all\’equipaggiamento fornito dalla tuo background:\n(a) uno stocco o (b) una spada corta\n(a) un arco corto e una faretra con 20 frecce o (b) una spada corta\n(a) uno zaino da rapinatore, (b) uno zaino da speleologo o (c) uno zaino da esploratore\nArmatura di cuoio, due pugnali, e attrezzi da ladro\n\n---\n\n**MAESTRIA**\nAl 1° livello, scegli due tue competenze nelle abilità, o una delle tue competenze nelle abilitàe la tua competenza con gli attrezzi da scasso.\nIl tuo bonus di competenza è raddoppiato per qualsiasi prova di caratteristica che usi una delle competenze scelte.\nAl 6° lIvello, puoi scegliere altre due competenze (in abilità o attrezzi da scasso) su cui applicare questo beneficio.\n\n---\n\n**ATTACCO** **FURTIVO**\nA partire dal 1° livello, impari a colpire con precisione e sfruttare le distrazioni dell’avversario.\nUna volta per turno, puoi infliggere 1d6 danni extra a una creatura che colpisci con un attacco se godi di vantaggio sul tiro per colpire.\nL’attacco deve impiegare un’arma di precisione o a distanza.\nNon hai bisogno di vantaggio sul tiro per colpire se un altro nemico del bersaglio si trova entro 1,5 metri da esso, quel nemico non è inabile, e non hai svantaggio sul tiro per colpire.\nL’ammontare di danno aggiuntivo aumenta con i tuoi livelli in questa classe come indicato nella colonna Attacco Furtivo della tabella Il Ladro.\n\n---\n\n**GERGO** **LADRESCO**\nDurante il tuo addestramento da ladro hai appreso il gergo dei ladri, una miscela segreta di dialetti, gergo e codici che ti permettono di nascondere dei messaggi in conversazioni apparentemente normali.\nSolo un’altra creatura che conosca il gergo dei ladri può comprendere questi messaggi.\nCi vuole il quadruplo del tempo per trasmettere un simile messaggio rispetto alla normale conversazione.\nInoltre, comprendi una serie di segni e simboli segreti impiegati per inviare messaggi semplici e brevi, per identificare un’area come pericolosa o territorio della gilda dei ladri, se c’è del bottino nelle vicinanze, o se le persone del luogo sono facili prede o possano fornire un rifugio ad un ladro in fuga.\n\n---\n\n**AZIONE** **SCALTRA**\nA partire dal 2° livello, pensiero rapido e grande coordinazione ti permettono di muoverti e agire velocemente.\nPuoi effettuare un’azione bonus durante ciascun tuo turno in combattimento.\nQuest’azione può essere usata solo per effettuare le azioni Disimpegnarsi, Nascondersi o Scattare.\n\n---\n\n**ARCHETIPO** **LADRESCO**\nAl 3° livello, puoi scegliere un archetipo da emulare nell’esercizio delle tue capacità ladresche, come quello del furfante.\nIl tuo archetipo conferisce privilegi al 3° livello e ancora al 9°, 13° e 17° livello.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando raggiungi il 4° livello, e poi ancora all’8°, 10°, 12°, 16° e 19° livello, puoi incrementare un tuo punteggio di caratteristica di 2, o incrementare due punteggi di caratteristica di 1.\nDi norma, utilizzando questo privilegio non puoi accrescere un punteggio di caratteristica oltre il 20.\n\n---\n\n**SCHIVATA** **PRODIGIOSA**\nA partire dal 5° livello, quando un attaccante che sei in grado di vedere ti colpisce con un attacco, puoi usare la tua reazione per dimezzare il danno dell’attacco effettuato contro di te.\n\n---\n\n**ELUSIONE**\nA partire dal 7° livello, puoi tirarti fuori rapidamente da certe aree di effetto, come quella del soffio infuocato di un drago rosso o l’incantesimo tempesta di ghiaccio.\nQuando sei vittima di un effetto che ti permette di compiere un tiro salvezza su Destrezza per dimezzare i danni, non subisci danni se superi il tiro salvezza, e solo metà danni se lo fallisci.\n\n---\n\n**DOTE** **AFFIDABILE**\nDall’11° livello, hai affinato le tue abilità prescelte quasi alla perfezione.\nOgni volta che devi compiere una prova di caratteristica che ti permette di sommare il tuo bonus di competenza, puoi trattare il risultato di 9 o meno su un d20 come fosse 10.\n\n---\n\n**PERCEZIONE** **CIECA**\nA partire dal 14° livello, se sei in grado di udirla, sei consapevole della posizione di qualsiasi creatura invisibile o nascosta entro 3 metri da te.\n\n---\n\n**MENTE** **SFUGGENTE**\nPer il 15° livello, la tua mente ha acquisito una grande forza.\nOttieni la competenza nei tiri salvezza su Saggezza.\n\n---\n\n**INAFFERABILE**\nA partire dal 18° livello, sei così evasivo che è difficile che gli avversari riescano a prenderti in fallo.\nNessun tiro per colpire gode di vantaggio contro di te, a meno che tu non sia inabile.\n\n---\n\n**COLPO** **DI** **FORTUNA**\nAl 20° livello, hai una prodigiosa predisposizione per riuscire nel momento del bisogno.\nSe il tuo attacco manca un bersaglio che si trovi nella tua gittata, puoi trasformarlo in un attacco riuscito.\nIn alternativa, se fallisci una prova di caratteristica, puoi trattare il risultato del d20 come se fosse 20.\nUna volta usato questo privilegio, non lo puoi riusare fino a quando non termini un riposo breve o lungo.'),
  mago(
      'Mago',
      [
        SubClass.abiurazione,
        SubClass.ammaliamento,
        SubClass.discendenzaDraconica,
        SubClass.evocazione,
        SubClass.illusione,
        SubClass.invocazione,
        SubClass.necromanzia,
        SubClass.trasmutazione,
      ],
      true,
      [
        SubSkill.arcano,
        SubSkill.storia,
        SubSkill.indagare,
        SubSkill.religione,
        SubSkill.intuizione,
        SubSkill.medicina,
      ],
      2,
      [
        Mastery.balestreLeggere,
        Mastery.bastoniFerrati,
        Mastery.dardi,
        Mastery.fionde,
        Mastery.pugnali,
      ],
      0,
      [],
      [Skill.intelligenza, Skill.saggezza],
      [
        {Weapon.bastoneFerrato: 1, Weapon.pugnale: 1},
        {Item.borsaPerComponenti: 1, Item.focusArcano: 1},
        {Item.libroDegliIncantesimi: 1},
        {Equipment.dotazioneDaStudioso: 1, Equipment.dotazioneDaEsploratore: 1},
      ],
      'Un mago ottiene i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d6 per ogni livello da mago\nPunti Ferita al 1° livello: 6 + il modificatore di Costituzione del mago\nPunti Ferita ai Livelli Successivi: 1d6 (o 4) + il modificatore di Costituzione del mago per ogni livello da mago dopo il 1°\n\n---\n\n**COMPETENZE**\nArmature: Nessuna\nArmi: Balestre leggere, bastoni ferrati, dardi, fionde, pugnali.\nStrumenti: Nessuno\nTiri Salvezza: Intelligenza, Saggezza\nAbilità: Due a scelta tra Arcano, Indagare, Intuizione, Medicina, Religione e Storia\n\n---\n\n**EQUIPAGGIAMENTO**\nUn mago inizia con l\'equipaggiamento seguente, in aggiunta all\'equipaggiamento conferito dal suo background:\n(a) un bastone ferrato o (b) un pugnale\n(a) una borsa per componenti o (b) un focus arcano\n(a) una dotazione da studioso o (b) una dotazione da esploratore\nUn libro degli incantesimi\n\n---\n\n**INCANTESIMI**\nUn mago è uno studioso di magia arcana: possiede un libro degli incantesimi in cui sono contenuti gli incantesimi che costituiscono le prime scintille del suo futuro potere.\n\n---\n\n**TRUCCHETTI**\nAl 1° livello, un mago conosce tre trucchetti a sua scelta dalla lista degli incantesimi da mago.\nApprende ulteriori trucchetti da mago a sua scelta ai livelli successivi.\n\n---\n\n**LIBRO** **DEGLI** **INCANTESIMI**\nAl 1° livello, un mago possiede un libro degli incantesimi che contiene sei incantesimi da mago di 1° livello a sua scelta.\nQuesto libro degli incantesimi contiene tutti gli incantesimi da mago conosciuti dal personaggio, ad eccezione dei suoi trucchetti, che sono impressi direttamente nella sua mente.\n\n---\n\n**PREPARARE** E **LANCIARE** **INCANTESIMI**\nLa tabella indica quanti slot incantesimo possiede un mago per lanciare i suoi incantesimi di 1° livello e di livello superiore.\nPer lanciare uno di questi incantesimi, il mago deve spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nIl mago recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nIl mago prepara la lista degli incantesimi da mago disponibili da lanciare scegliendoli dalla lista degli incantesimi da mago.\nQuando lo fa, deve scegliere un numero di incantesimi da mago dal suo libro degli incantesimi pari al suo modificatore di Intelligenza + il suo livello da mago (fino a un minimo di un incantesimo).\nGli incantesimi devono essere di un livello di cui il mago possiede degli slot incantesimo.\nPer esempio, un mago di 3° livello possiede quattro slot incantesimo di 1° livello e due slot incantesimo di 2° livello.\nCon Intelligenza pari a 16, la lista dei suoi incantesimi preparati può includere sei incantesimi di 1° o 2° livello, in qualsiasi combinazione, scelti dal suo libro degli incantesimi.\nSe prepara l\'incantesimo di 1° livello Dardo Incantato, potrà lanciarlo usando uno slot incantesimo di 1° livello o di 2° livello.\nIl lancio di quell\'incantesimo non rimuove quell\'incantesimo dalla lista di incantesimi preparati.\nIl mago può cambiare la lista dei suoi incantesimi preparati quando completa un riposo lungo.\nPer preparare una nuova lista di incantesimi da mago è necessario un certo ammontare di tempo da trascorrere studiando il libro degli incantesimi e memorizzando le formule e i gesti necessari per lanciare l\'incantesimo: almeno 1 minuto per livello di incantesimo per ogni incantesimo nella sua lista.\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nIntelligenza è la caratteristica da incantatore usata per gli incantesimi da mago, dal momento che egli impara i suoi incantesimi tramite lo studio costante e la memorizzazione.\nUn mago usa Intelligenza ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Intelligenza per definire la **CD** del tiro salvezza di un incantesimo da mago da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell\'incantesimo= 8 + il bonus di competenza del mago + il modificatore di Intelligenza del mago\nModificatore di attacco dell\'incantesimo= il bonus di competenza del mago + il modificatore di Intelligenza del mago\n\n---\n\n**CELEBRARE** **RITUALI**\nUn mago può lanciare un incantesimo da mago come rituale se quell\'incantesimo possiede il descrittore rituale.\nNon è necessario che abbia preparato quell\'incantesimo.\n\n---\n\n**FOCUS** **DA** **INCANTATORE**\nUn mago può usare un focus arcano come focus da incantatore per i suoi incantesimi da mago.\n\n---\n\n**IMPARARE** **INCANTESIMI** **DI** **LIVELLO** 1 E **DI** **LIVELLO** **SUPERIORE**\nOgni volta che il personaggio acquisisce un livello da mago, può aggiungere gratuitamente due incantesimi da mago a sua scelta al suo libro degli incantesimi.\nOgnuno di questi incantesimi deve essere di un livello di cui il mago possiede degli slot incantesimo, come indicato nella tabella.\nNel corso delle sue avventure potrebbe trovare altri incantesimi da aggiungere al suo libro.\n\n---\n\n**IL** **LIBRO** **DEGLI** **INCANTESIMI** **DEL** **MAGO**\nGli incantesimi che il mago aggiunge al suo libro man mano che acquisisce livelli derivano dalle ricerche arcane che conduce personalmente, nonché dalle scoperte intellettuali che riesce a fare sulla natura del multiverso.\nPotrebbe trovare altri incantesimi nel corso delle sue avventure,, magari scoprendone uno trascritto su una pergamena nascosta nel forziere di un mago malvagio o in un tomo polveroso custodito in un\'antica biblioteca.\n\n---\n\n**COPIARE** **UN** **INCANTESIMO** **NEL** **LIBRO**\nQuando il mago entra in possesso di un incantesimo da mago di livello pari o superiore al 1°, può aggiungerlo al suo libro, se si tratta di un incantesimo di un livello che egli può preparare e se dispone del tempo per decifrarlo e copiarlo.\nPer copiare un incantesimo nel libro è necessario riprodurre il formato basilare dell\'incantesimo per poi decifrare il sistema di trascrizione speciale usato dal mago che lo ha scritto.\nIl personaggio deve fare pratica con l\'incantesimo finché non comprende i suoni o i gesti richiesti, e poi trascriverlo nel proprio libro degli incantesimi usando il suo metodo personale di trascrizione.\nPer ogni livello dell\'incantesimo, il processo di trascrizione richiede 2 ore e costa 50 mo.\nIl costo rappresenta le componenti materiali consumate dal mago nel corso dei suoi esperimenti per padroneggiare l\'incantesimo, nonché gli inchiostri pregiati necessari per trascriverlo.\nUna volta speso l\'ammontare di tempo e il denaro necessario, il mago può preparare l\'incantesimo proprio come tutti gli altri suoi incantesimi.\n\n---\n\n**SOSTITUIRE** **IL** **LIBRO**\nUn mago può copiare un incantesimo dal suo libro degli incantesimi a un altro (per esempio, se desidera farne una copia di riserva).\nProcede come se copiasse un nuovo incantesimo nel proprio libro degli incantesimi, ma in modo più rapido e facile, dal momento che conosce già il proprio metodo di trascrizione e sa già come si lancia l\'incantesimo.\nDovrà spendere solo 1 ora e 10 mo per ogni livello dell\'incantesimo copiato.\nSe il mago perde il suo libro degli incantesimi, può usare la stessa procedura per trascrivere gli incantesimi che ha preparato in un nuovo libro degli incantesimi.\nPer completare il resto del suo libro degli incantesimi dovrà trovarne di nuovi come il consueto.\nÈ per questo motivo che molti maghi custodiscono delle copie di riserva dei loro libri degli incantesimi in luoghi sicuri.\n\n---\n\n**ASPETTO** **DEL** **LIBRO**\nIl libro degli incantesimi di un mago è una combinazione unica di incantesimi, dotato di rifiniture decorative e note a margine personali.\nPotrebbe trattarsi di un semplice e pratico volume rilegato in cuoio che il mago ha ricevuto in dono dal suo maestro, di un tomo finemente rilegato e decorato in oro rinvenuto in un\'antica biblioteca, o perfino di un cumulo disordinato di appunti messi assieme in tutta fretta dopo che il libro degli incantesimi precedenti è andato perduto in un incidente.\n\n---\n\n**RECUPERO** **ARCANO**\nUn mago impara a recuperare parte della sua energia magica studiando il suo libro degli incantesimi.\nUna volta al giorno, quando completa un riposo breve, il mago sceglie quali slot incantesimo spesi desidera recuperare.\nQuesti slot incantesimo possono avere un livello totale pari o inferiore alla metà del livello da mago (arrotondato per eccesso) e nessuno slot può essere di livello pari o superiore al 6°.\nPer esempio, un mago di 4° livello può recuperare slot incantesimo per un valore totale di due livelli.\nPotrà quindi recuperare uno slot di 2° livello o due slot di 1° livello.\n\n---\n\n**TRADIZIONE** **ARCANA**\nQuando un mago arriva al 2° livello, sceglie una tradizione arcana che modellerà la sua pratica della magia in base ai precetti di una delle otto scuole seguenti: Abiurazione, Ammaliamento, Divinazione, Evocazione, Illusione, Invocazione, Necromanzia, Trasmutazione, tutte descritte alla fine della sezione di questa classe.\nLa scuola scelta conferisce al mago alcuni privilegi al 2° livello e poi di nuovo al 6°, 10° e 14° livello.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello, e poi di nuovo all\'8°, 12°, 16° e 19° livello, un mago può aumentare di 2 un punteggio di caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto non è consentito aumentare un punteggio di caratteristica a più di 20 utilizzando questo privilegio.\n\n---\n\n**MAESTRIA** **NEGLI** **INCANTESIMI**\nAl 18° livello, il mago raggiunge una tale maestria nell\'uso di certi incantesimi da poterli lanciare a volontà.\nIl personaggio sceglie un incantesimo da mago di 1° livello e un incantesimo da mago di 2° livello contenuti nel suo libro degli incantesimi.\nPuò lanciare quegli incantesimi al loro livello più basso senza spendere uno slot incantesimo quando li ha preparati.\nSe desidera lanciare uno di quegli incantesimi a un livello superiore, deve spendere uno slot incantesimo come di consueto.\n\n---\n\n**INCANTESIMI** **PERSONALI**\nQuando il mago arriva al 20° livello, padroneggia due potenti incantesimi che sia in grado di lanciare con minimo sforzo.\nIl mago sceglie due incantesimi da mago di 3° livello contenuti nel suo libro degli incantesimi come suoi incantesimi personali.\nIl mago considera questi incantesimi sempre preparati, non li conta ai fini di determinare il numero di incantesimi preparati e può lanciare ognuno di quegli incantesimi una volta al 3° livello senza spendere uno slot incantesimo.\nQuando lo fa, non può farlo di nuovo finché non completa un riposo breve o lungo.\nSe desidera lanciare uno di quegli incantesimi a un livello superiore, deve spendere uno slot incantesimo come di consueto.'),
  monaco(
      'Monaco',
      [
        SubClass.viaDeiQuattroElementi,
        SubClass.viaDellaManoAperta,
        SubClass.viaDellOmbra,
      ],
      false,
      [
        SubSkill.atletica,
        SubSkill.acrobazia,
        SubSkill.furtivita,
        SubSkill.storia,
        SubSkill.religione,
        SubSkill.intuizione,
      ],
      2,
      [
        Mastery.armiSemplici,
        Mastery.spadeCorte,
      ],
      1,
      [MasteryType.strumentiArtigiano, MasteryType.strumentiMusicali],
      [Skill.destrezza, Skill.forza],
      [
        {
          Weapon.spadaCorta: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {Weapon.dardo: 10},
        {
          Equipment.dotazioneDaAvventuriero: 1,
          Equipment.dotazioneDaEsploratore: 1
        },
      ],
      'Come monaco, ottieni i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDado Vita: 1d8 per livello da monaco\nPunti Ferita al 1° livello: 8 + il tuo modificatore di Costituzione\nPunti Ferita ai Livelli Più Alti: 1d8 (o 5) + il tuo modificatore di Costituzione per livello da monaco oltre il 1°\n\n---\n\n**COMPETENZE**\nArmature: Nessuna\nArmi: Armi semplici, spade corte\nAttrezzi: Scegli un tipo di attrezzo da artigiano o uno strumento musicale\nTiri Salvezza: Forza, Destrezza\nAbilità: Scegli due abilità tra Acrobazia, Atletica, Furtività, Intuizione, Religione e Storia\n\n---\n\n**EQUIPAGGIAMENTO**\nInizi con il seguente equipaggiamento, oltre all’equipaggiamento fornito dal tuo background:\n(a) una spada corta o (b) qualsiasi arma semplice\n(a) uno zaino da speleologo o (b) uno zaino da esploratore\n10 dardi\n\n---\n\n**DIFESA** **SENZA** **ARMATURA**\nA partire dal 1° livello, finché un monaco non indossa alcuna armatura e non impugna uno scudo, la sua **CA** è pari a 10 + il suo modificatore di Destrezza + il suo modificatore di Saggezza.\n\n---\n\n**ARTI** **MARZIALI**\nAl 1° livello, grazie alla sua perizia nelle arti marziali, un monaco padroneggia uno stile di combattimento che fa uso di colpi senz\'armi e armi da monaco, vale a dire spade corte e qualsiasi arma da mischia semplice che non possieda la proprietà a due mani o la proprietà pesante.\nUn monaco ottiene i benefici seguenti finché è senz\'armi o impugna soltanto armi da monaco e finché non indossa alcuna armatura e non impugna uno scudo:\n- Un monaco può usare Destrezza anziché Forza per i tiri per colpire e i tiri per i danni dei suoi colpi senz\'armi e delle sue armi da monaco.\n- Un monaco può tirare un d4 al posto dei normali danni del suo colpo senz\'arma o della sua arma da monaco.\nQuesto dado cambia man mano che il personaggio acquisisce altri livelli da monaco, come indicato nella colonna "Arti marziali" nella tabella "Monaco".\n- Quando un monaco usa l\'azione di Attacco con un colpo senz\'armi o un\'arma da monaco nel suo turno, può effettuare un colpo senz\'armi come azione bonus.\nPer esempio, se il monaco effettua l\'azione di Attacco con un bastone ferrato, può anche effettuare un colpo senz\'armi come azione bonus, presumendo che non abbia già effettuato un\'azione bonus in quel turno.\nAlcuni monasteri utilizzano armi da monaco dalla forma particolare.\nPer esempio, un monaco potrebbe usare un randello composto da due sbarre in legno collegate da una breve catena(chiamato nunchaku) o un falcetto con una lama più corta e meno ricurva (chiamato kama).\nA prescindere dal nome usato per un\'arma da monaco, il monaco può usare le statistiche di gioco fornite dall\'arma nel capitolo 5,"Equipaggiamento".\n\n---\n\n**KI**\nA partire dal 2° livello, il monaco è in grado di imbrigliare l\'energia mistica del ki grazie al suo addestramento.\nIl suo accesso a questa energia è rappresentato da un certo numero di punti ki, determinato dal livello da monaco, come indicato nella colonna "Punti Ki" nella tabella "monaco".\nUn monaco può spendere questi punti per alimentare i vari privilegi del ki.\nInizialmente il monaco conosce tre di questi privilegi: Difesa del paziente, Passo del Vento e Raffica di colpi.\nApprenderà altri privilegi del ki,quel punto non è più disponibile finché il monaco non completa un riposo breve o lungo, alla fine del quale il monaco riassorbe in sé tutto il ki che aveva speso.\nIl monaco deve trascorrere almeno 30 minuti in meditazione durante il riposo per recuperare i suoi punti ki.\nAlcuni privilegi del ki di un monaco richiedono al bersaglio di effettuare un tiro salvezza per resistere ai loro effetti.\nLa **CD** del tiro salvezza viene definita nel modo seguente:\n\n---\n\n**CD** del tiro salvezza del Ki = 8 + il bonus di competenza del monaco + il bonus di saggezza del monaco\n\n---\n\n**DIFESA** **DEL** **PAZIENTE**\nUn monaco può spendere 1 punto ki per effettuare l\'azione di schivata come azione bonus nel suo turno.\n\n---\n\n**PASSO** **DEL** **VENTO**\nUn monaco può spendere 1 punto ki per effettuare l\'azione di Disimpegno o Scatto come azione bonus nel suo turno; inoltre, la sua distanza di salto raddoppia per quel turno.\n\n---\n\n**RAFFICA** **DI** **COLPI**\nSubito dopo aver effettuato l\'azione di attacco nel suo turno, il monaco può spendere 1 punto ki per sferrare due colpi senz\'armi come azione di bonus.\n\n---\n\n**MOVIMENTO** **SENZA** **ARMATURA**\nA partire dal 2° livello, la velocità di un monaco aumenta di 3 metri finché il monaco non indossa alcuna armatura o non impugna uno scudo.\nQuesto bonus aumenta man mano che il personaggio acquisisce altri livelli da monaco, come indicato nella tabella "Monaco".\nAl 9° livello, un monaco ottiene la capacità di muoversi lungo le superfici verticali e sulle superfici liquide durante il suo turno senza cadere durante il movimento.\n\n---\n\n**TRADIZIONE** **MONASTICA**\nQuando si raggiunge 3° livello, il monaco si vota a una tradizione monastica come la Via della Mano Aperta o la Via dell\'Ombra.\nLa tradizione scelta conferisce al monaco alcuni privilegi al 3° livello e poi di nuovo al 6°, 11° e 17° livello.\n\n---\n\n**DEVIARE** **PROIETTILI**\nA partire dal 3° livello, un monaco può usare la sua reazione per deviare o afferrare un proiettile quando viene colpito dall\'attacco con un\'arma a distanza.\nQuando lo fa, il danno che subisce dall\'attacco è ridotto di 1d10 + il suo modificatore di Destrezza + il suo livello da monaco.\nSe il monaco riduce i danni a 0, può afferrare il proiettile, se quest\'ultimo è abbastanza piccolo da essere tenuto in mano e se il monaco ha almeno una mano libera.\nSe il monaco afferra un proiettile in questo modo, può spendere 1 punto ki per effettuare un attacco a distanza con l\'arma o con la munizione che ha appena afferrato, come parte della stessa reazione.\nIl monaco effettua questo attacco con competenza, a prescindere dalle sue competenze nelle armi, e il proiettile è considerato un\'arma da monaco ai fini di questo attacco, con una gittata normale di 6 metri e una gittata lunga di 18 metri.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando si raggiunge 4° livello, e di nuovo al 8°, 12°, 16° e 19° livello, è possibile aumentare di 2 un punteggio di caratteristica a scelta, oppure è possibile aumentare di 1 due punteggi di caratteristica a scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica superiore a 20 utilizzando questo privilegio.\n\n---\n\n**CADUTA** **LENTA**\nA partire dal 4° livello, un monaco può usare la sua reazione quando cade per ridurre gli eventuali danni da caduta di un ammontare pari a cinque volte il suo livello da monaco.\n\n---\n\n**ATTACCO** **EXTRA**\nA partire dal 5° livello, un monaco può attaccare due volte, anziché una, ogni volta che effettua l\'azione di attacco nel proprio turno.\n\n---\n\n**COLPO** **STORDENTE**\nA partire da 5° livello, un monaco può interferire con il ki che fluisce nel corpo di un avversario.\nQuando il monaco colpisce un\'altra creatura con un attacco con un\'arma da mischia, può spendere 1 punto ki per tentare un colpo stordente.\nIl bersaglio deve superare un tiro salvezza su Costituzione, altrimenti sarà stordito fino alla fine del turno successivo del monaco.\n\n---\n\n**COLPI** **KI** **POTENZIATI**\nA partire dal 6° livello, i colpi senz\'armi del monaco sono considerati magici ai fini di oltrepassare la resistenza e l\'immunità agli attacchi e ai danni non magici.\n\n---\n\n**ELUSIONE**\nAl 7° livello, grazie alla sua agilità istintiva, il monaco può schivare certi effetti ad area, come il soffio di fulmine di un drago blu o un incantesimo palla di fuoco.\nQuando il monaco è soggetto a un effetto che gli consente di effettuare un tiro salvezza su Destrezza per dimezzare i danni, non subisce alcun danno se supera il tiro salvezza, e soltanto la metà dei danni se lo fallisce.\n\n---\n\n**MENTE** **LUCIDA**\nA partire dal 7° livello, un monaco può utilizzare l\'azione per porre fine a un effetto su te stesso che lo rende affascinato o spaventato.\n\n---\n\n**PUREZZA** **DEL** **CORPO**\nAl 1° livello, il monaco ha una tale padronanza del ki da diventare immune alle malattie e ai veleni.\n\n---\n\n**LINGUA** **DEL** **SOLE** E **DELLA** **LUNA**\nA partire dal 13° livello, un monaco impara a sfiorare il ki delle altre menti ed è in grado di comprendere tutti i linguaggi parlati.\nInoltre, qualsiasi creatura che sia in grado di capire ciò che il monaco dice.\n\n---\n\n**ANIMA** **ADAMANTINA**\nCominciando a 14° livello, il monaco ha una tale padronanza del ki da ottenere competenza in tutti i tiri salvezza.\nInoltre, ogni volta che effettua un tiro salvezza e fallisce, può spendere 1 punto ki per ripetere il tiro.\nDeve usare il nuovo risultato.\n\n---\n\n**CORPO** **SENZA** **TEMPO**\nAl 15° livello, il monaco è pervaso dal ki al punto che non è toccato dalla fragilità della vecchiaia e non può invecchiare magicamente.\nTuttavia, può sempre morire di vecchiaia.\n Inoltre, non ha più bisogno di bere o di mangiare.\n\n---\n\n**CORPO** **VUOTO**\nA partire dal 18° livello, il monaco può usare la sua azione per spendere 4 punti ki e diventare invisibile per 1 minuto.\nDurante quel periodo di tempo, ottiene anche resistenza a tutti danni, tranne ai danni da forza.\nInoltre, il monaco può spendere 8 punti ki in modo da lanciare incantesimo proiezione astrale, senza avere bisogno di componenti materiali.\nQuando lo fa, non può portare nessun\'altra creatura con sé.\n\n---\n\n**PERFEZIONE** **INTERIORE**\nAl 20° livello, quando il monaco tira per l\'iniziativa e non gli rimane alcun punto ki, recupera 4 punti ki.'),
  paladino(
      'Paladino',
      [
        SubClass.giuramentoDegliAntichi,
        // SubClass.giuramentoDiDevozione,
        SubClass.giuramentoDellaVendetta,
      ],
      true,
      [
        SubSkill.atletica,
        SubSkill.religione,
        SubSkill.intuizione,
        SubSkill.medicina,
        SubSkill.intimidire,
        SubSkill.persuasione,
      ],
      2,
      [
        Mastery.tutteLeArmature,
        Mastery.scudi,
        Mastery.armiSemplici,
        Mastery.armiDaGuerra,
      ],
      0,
      [],
      [Skill.saggezza, Skill.carisma],
      [
        {
          Weapon.giavellotto: 4,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          // Weapon.giavellotto:1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1
        },
        {
          Weapon.alabarda: 1,
          Weapon.asciaBipenne: 1,
          Weapon.asciaDaBattaglia: 1,
          Weapon.falcione: 1,
          Weapon.frusta: 1,
          Weapon.lanciaDaCavaliere: 1,
          Weapon.maglio: 1,
          Weapon.martelloDaGuerra: 1,
          Weapon.mazzafrusto: 1,
          Weapon.morningStar: 1,
          Weapon.picca: 1,
          Weapon.picconeDaGuerra: 1,
          Weapon.scimitarra: 1,
          Weapon.spadaCorta: 1,
          Weapon.spadaLunga: 1,
          Weapon.spadone: 1,
          Weapon.stocco: 1,
          Weapon.tridente: 1,
          Weapon.arcoLungo: 1,
          Weapon.balestraAMano: 1,
          Weapon.balestraPesante: 1,
          Weapon.cerbottana: 1,
          Weapon.rete: 1,
          Armor.scudo: 1,
        },
        {
          Weapon.alabarda: 1,
          Weapon.asciaBipenne: 1,
          Weapon.asciaDaBattaglia: 1,
          Weapon.falcione: 1,
          Weapon.frusta: 1,
          Weapon.lanciaDaCavaliere: 1,
          Weapon.maglio: 1,
          Weapon.martelloDaGuerra: 1,
          Weapon.mazzafrusto: 1,
          Weapon.morningStar: 1,
          Weapon.picca: 1,
          Weapon.picconeDaGuerra: 1,
          Weapon.scimitarra: 1,
          Weapon.spadaCorta: 1,
          Weapon.spadaLunga: 1,
          Weapon.spadone: 1,
          Weapon.stocco: 1,
          Weapon.tridente: 1,
          Weapon.arcoLungo: 1,
          Weapon.balestraAMano: 1,
          Weapon.balestraPesante: 1,
          Weapon.cerbottana: 1,
          Weapon.rete: 1,
        },
        {Armor.cottaDiMaglia: 1},
        {
          Equipment.dotazioneDaSacerdote: 1,
          Equipment.dotazioneDaEsploratore: 1
        },
      ],
      'Come paladino, ottieni i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDado Vita: 1d10 per livello da paladino.\nPunti Ferita al 1° livello: 10 + il tuo modificatore di Costituzione.\nPunti Ferita ai Livelli Più Alti: 1d10 (o 6) + il tuo modificatore di Costituzione per livello da paladino oltre il 1°.\n\n---\n\n**COMPETENZE**\nArmature: Tutte le armature, scudi.\nArmi: Armi semplici, armi da guerra.\nAttrezzi: Nessuno.\nTiri Salvezza: Saggezza, Carisma.\nAbilità: Scegli due abilità tra Atletica, Intimidire, Intuizione, Medicina, Persuasione e Religione.\n\n---\n\n**EQUIPAGGIAMENTO**\nInizi con il seguente equipaggiamento, oltre all\'equipaggiamento fornito dal tuo background:\n(a) un\'arma da guerra e uno scudo o (b) due armi da guerra.\n(a) cinque giavellotti o (b) qualsiasi arma semplice da mischia.\n(a) uno zaino da sacerdote o (b) uno zaino da esploratore.\nCotta di maglia e un simbolo sacro.\n\n---\n\n**PERCEZIONE** **DEL** **DIVINO**\nLa presenza di una forte malvagità viene percepita dai tuoi sensi come un odore nauseabondo, e un bene potente suona come musica celestiale nelle tue orecchie.\nCon unazione puoi espandere la tua consapevolezza per individuare queste forze.\nFino al termine del tuo prossimo turno, conosci la posizione di qualsiasi celestiale, immondo o non morto che si trovi entro 18 metri da te e che non sia dietro copertura totale.\nRiconosci il tipo (celestiale, immondo o non morto) di qualsiasi creatura di cui avverti la presenza, ma non la sua esatta identità (per esempio il vampiro Conte Strahd von Zarovich).\nAll\’interno della stesso raggio, puoi anche individuare la presenza di qualsiasi luogo o oggetto che sia stato consacrato o dissacrato, come per l’incantesimo santificare.\nPuoi usare questo privilegio un numero di volte pari ad 1 + il tuo modificatore di Carisma.\nQuando termini un riposo lungo, recuperi tutti gli usi consumati.\n\n---\n\n**IMPOSIZIONE** **DELLE** **MANI**\nIl tuo tocco benedetto può guarire le ferite.\nHai una riserva di potere curativo che si ripristina al termine di un riposo lungo.\nCon questa riserva, puoi curare un numero totale di punti ferita pari al tuo livello da paladino x 5.\nCon un\'azione, puoi attingere al potere della riserva per ripristinare i punti ferita di una creatura con cui sei in contatto, fino al massimo rimanente nella tua riserva.\nIn alternativa, puoi spendere 5 punti ferita dalla tua riserva di guarigione per curare il bersaglio di una malattia o neutralizzare un veleno che lo affligge.\nPuoi curare più malattie e neutralizzare più veleni con una singola Imposizione delle Mani, spedendo i punti ferita separatamente per ogni malanno.\nQuesto privilegio non ha effetto su non morti o costrutti.\n\n---\n\n**STILE** **DI** **COMBATTIMENTO**\nAl 2° livello, adotti un particolare stile di combattimento come tua specialità.\nScegli una delle seguenti opzioni.\nNon puoi acquisire più di una volta lo stesso Stile di Combattimento, anche se in seguito ottieni una nuova scelta.\n\n---\n\n**COMBATTERE** **CON** **ARMI** **POSSENTI**\nQuando tiri 1 o 2 per il dado di danno di un attacco effettuato con un\'arma da mischia che stai impugnando con due mani, puoi ritirare il dado e devi usare il nuovo risultato, anche se questo tiro fosse nuovamente 1 o 2.\nL\'arma deve avere la proprietà a due mani o versatile per farti ottenere questo beneficio.\n\n---\n\n**DIFESA**\nQuando indossi un\'armatura, ottieni un bonus di +1 alla **CA**.\n\n---\n\n**DUELLARE**\nQuando impugni un’arma da mischia in una mano e nessun\'altra arma, ottieni un bonus di +2 ai tiri dei danni con quell\'arma.\n\n---\n\n**PROTEZIONE**\nQuando una creatura che puoi vedere attacca un bersaglio diverso da te entro 1,5 metri da te, puoi usare la tua reazione per imporre svantaggio al suo tiro per colpire.\nDevi impugnare uno scudo.\n\n---\n\n**INCANTESIMI**\nAl 2° livello, impari ad attingere alla magia divina tramite la meditazione e la preghiera per lanciare incantesimi come fa un chierico.\nVedi La Magia per le regole generali sul lancio degli incantesimi.\nVedi Le Liste degli Incantesimi per la lista degli incantesimi da paladino.\n\n---\n\n**PREPARARE** E **LANCIARE** **INCANTESIMI**\nLa tabella Il Paladino mostra di quanti slot incantesimo disponi per lanciare i tuoi incantesimi.\nPer lanciare uno di questi incantesimi da paladino, devi spendere uno slot del livello dell\'incantesimo o più alto.\nRecupererai tutti gli slot incantesimo spesi al termine di un riposo lungo.\nPrepari la lista degli incantesimi da paladino da lanciare a tua disposizione, scegliendoli dalla lista degli incantesimi da paladino.\nQuando lo fai, scegli un numero di incantesimi da paladino uguale al tuo modificatore di Carisma + la metà del tuo livello da paladino (minimo 1 incantesimo).\nGli incantesimi devono essere di un livello per cui disponi slot incantesimo.\nPer esempio, se sei un paladino di 5° livello, hai quattro slot incantesimo di 1° livello e due di 2° livello.\nCon Carisma 14, la tua lista di incantesimi preparati può includere quattro incantesimi di 1° o 2° livello, in qualsiasi combinazione.\nSe prepari l\'incantesimo di 1° livello cura ferite, puoi lanciarlo usando uno slot di 1° o 2° livello.\nLanciare l\'incantesimo non lo rimuove dalla lista dei tuoi incantesimi preparati.\nPuoi cambiare la tua lista di incantesimi preparati al termine di un riposo lungo.\nPreparare una nuova lista di incantesimi da paladino necessita di tempo trascorso a pregare e meditare: almeno 1 minuto per livello di incantesimo per ogni incantesimo sulla tua lista.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nIl Carisma è la tua caratteristica da incantatore per gli incantesimi da paladino.\nIl potere dei tuoi incantesimi deriva dalla forza della tua dedizione.\nUsi il Carisma ogni volta che un incantesimo da paladino fa riferimento alla tua caratteristica da incantatore.\nInoltre, puoi usare il modificatore di Carisma quando stabilisci la **CD** del tiro salvezza di un incantesimo da paladino da te lanciato e quando effettui un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell’incantesimo = 8 + tuo bonus di competenza + tuo modificatore di Carisma.\nModificatore di attacco dell’incantesimo = tuo bonus di competenza + tuo modificatore di Carisma.\n\n---\n\n**FOCUS** **DA** **INCANTAMENTO**\nPuoi usare un simbolo sacro come focus di incantamento dei tuoi incantesimi da paladino.\n\n---\n\n**PUNIZIONE** **DIVINA**\nA partire dal 2° livello, quando colpisci una creatura con un attacco con arma da mischia, puoi spendere uno slot incantesimo per infliggere danno radiante al bersaglio, oltre al danno dell’arma.\nIl danno aggiuntivo è 2d8 per uno slot incantesimo di 1° livello, più 1d8 per ogni livello dell’incantesimo sopra al 1°, massimo 5d8.\nIl danno aumenta di 1d8 se il bersaglio è un non morto o un immondo.\n\n---\n\n**SALUTE** **DIVINA**\nDal 3° livello in poi, la magia divina che ti fluisce attraverso ti rende immune alle malattie.\n\n---\n\n**GIURAMENTO** **SACRO**\nQuando raggiungi il 3° livello, pronunci un giuramento che ti vincola come paladino per l’eternità.\nFino a questo momento hai affrontato un periodo di preparazione,devoto al sentiero ma ancora non vincolato ad esso.\nOra scegli un giuramento, come il Giuramento di Devozione.\nLa tua scelta ti conferisce dei privilegi al 3° livello e poi al 7°, 15° e 20° livello.\nQuesti privilegi includono gli incantesimi del giuramento e il privilegio Incanalare Divinità.\n\n---\n\n**INCANTESIMI** **DA** **GIURAMENTO**\nOgni giuramento è associato a una lista di incantesimi.\nOttieni accesso a questi incantesimi ai livelli specificati nella descrizione del giuramento.\nUna volta ottenuto accesso a un incantesimo di giuramento, questo sarà considerato sempre preparato.\nGli incantesimi del giuramento non sono conteggiati nel numero di incantesimi che puoi preparare ogni giorno.\nSe ottieni un incantesimo di giuramento che non appare sulla lista degli incantesimi da paladino, per te quell’incantesimo è comunque considerato un incantesimo da paladino.\n\n---\n\n**INCANALARE** DIVINITÀ\nIl tuo giuramento ti permette di incanalare energia divina per alimentare effetti magici.\nOgni opzione di Incanalare Divinità fornita dal tuo giuramento spiega come usarla.\nQuando usi Incanalare Divinità, scegli quale opzione creare.\nPrima di poter utilizzare di nuovo Incanalare Divinità dovrai completare un riposo breve o lungo.\nAlcuni effetti di Incanalare Divinità richiedono un tiro salvezza.\nQuando usi un effetto di questa classe, la **CD** è uguale alla **CD** dei tuoi incantesimi da paladino.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando raggiungi il 4° livello, e poi ancora all’8°, 12°, 16° e 19° livello, puoi incrementare un tuo punteggio di caratteristica di 2, o incrementare due punteggi di caratteristica di 1.\nDi norma, utilizzando questo privilegio non puoi accrescere un punteggio di caratteristica oltre il 20.\n\n---\n\n**ATTACCO** **EXTRA**\nA partire dal 5° livello, puoi attaccare due volte, invece che una volta, ogni volta che effettui l’azione Attaccare durante il tuo turno.\n\n---\n\n**AURA** **DI** **PROTEZIONE**\nA partire dal 6° livello, ogni qualvolta tu o una creatura amica entro 3 metri da te dovete effettuare un tiro salvezza, quella creatura ottiene un bonus al tiro salvezza pari al tuo modificatore di Carisma (con un bonus minimo +1).\nPer conferire questo bonus devi essere cosciente.\nAl 18° livello, la gittata di quest\'aura aumenta a 9 metri.\n\n---\n\n**AURA** **DI** **CORAGGIO**\nA partire dal 10° livello, tu e le creature tue amiche entro 3 metri da te non potete essere spaventati finché sei cosciente.\nAl 18° livello, la gittata di quest\'aura aumenta a 9 metri.\n\n---\n\n**PUNIZIONE** **DIVINA** **MIGLIORATA**\nPer l\'11° livello, sei così infuso di giusta potenza che tutti i tuoi colpi con arma da mischia convogliano potere divino.\nOgni qualvolta colpisci una creatura con un’arma da mischia, la creatura subisce 1d8 danni radianti aggiuntivi.\nSe usi la tua Punizione Divina assieme a un attacco, somma questo danno al danno aggiuntivo della Punizione Divina.\n\n---\n\n**TOCCO** **PURIFICANTE**\nA partire dal 14° livello, puoi usare la tua azione per porre termine a un incantesimo su di te o una creatura consenziente che puoi toccare.\nPuoi usare questo privilegio un numero di volte pari al tuo modificatore di Carisma (minimo di una volta).\nRecuperi gli usi spesi al termine di un riposo lungo.\n\n---\n\n**GIURAMENTI** **SACRI**\nDiventare un paladino vuol dire assumere voti che impegnano il paladino nella causa della giustizia e ad avere un ruolo attivo nel combattere la malvagità.\nIl giuramento finale, preso quando raggiunge il 3° livello, è il culmine dell\'addestramento del paladino.\nAlcuni personaggi di questa classe non si considerano dei veri paladini fino a quando hanno raggiunto il 3° livello e compiuto questo giuramento.\nPer gli altri, il vero e proprio atto del pronunciare il giuramento è solo una formalità, un riconoscimento ufficiale di ciò che è si è sempre celato nel cuore del paladino.\n\n---\n\n**INFRANGERE** **FIURAMENTO**\nUn paladino cerca di mantenere i più alti standard di condotta, ma anche il paladino più virtuoso è fallace.\nA volte la giusta via si dimostra troppo ardua, a volte una situazione chiede di scegliere tra il minore di due mali, e altre volte le emozioni fanno sì che il paladino trasgredisca i suoi giuramenti.\nUn paladino che infranga un voto di solito cerca l\'assoluzione da un chierico che condivide la sua fede o da un altro paladino dello stesso ordine.\nIl paladino può trascorrere un’intera notte di veglia in preghiera come penitenza, o sottoporsi a digiuno o simile atto di auto- punizione.\nDopo un rito di confessione e perdono, il paladino può agire libero dal peccato.\nSe un paladino viola volontariamente il suo giuramento e non mostra alcun segno di pentimento, le conseguenze possono essere molto più gravi.\nA discrezione del **DM**, un paladino impenitente potrebbe essere obbligato ad abbandonare questa classe e adottarne un\'altra.'),
  ranger(
      'Ranger',
      [
        SubClass.cacciatore,
        SubClass.signoreDelleBestie,
      ],
      true,
      [
        SubSkill.atletica,
        SubSkill.furtivita,
        SubSkill.indagare,
        SubSkill.natura,
        SubSkill.addestrareAnimali,
        SubSkill.intuizione,
        SubSkill.percezione,
        SubSkill.sopravvivenza,
      ],
      3,
      [
        Mastery.armatureLeggere,
        Mastery.scudi,
        Mastery.armiSemplici,
        Mastery.armiDaGuerra,
        Mastery.armatureMedie,
      ],
      0,
      [],
      [Skill.forza, Skill.destrezza],
      [
        {Armor.corazzaDiScaglie: 1, Armor.armaturaDiCuoio: 1},
        {
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.spadaCorta: 1,
        },
        {
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.spadaCorta: 1,
        },
        {Equipment.arcoLungoEFaretraCon20Frecce: 1},
        {
          Equipment.dotazioneDaAvventuriero: 1,
          Equipment.dotazioneDaEsploratore: 1
        },
      ],
      'Come ranger, ottieni i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDado Vita: 1d10 per livello da ranger.\nPunti Ferita al 1° livello: 10 + il tuo modificatore di Costituzione.\nPunti Ferita ai Livelli Più Alti: 1d10 (o 6) + il tuo modificatore di Costituzione per livello da ranger oltre il 1°.\n\n---\n\n**COMPETENZE**\nArmature: Armature leggere, armature medie, scudi Armi: Armi semplici, armi da guerra.\nAttrezzi: Nessuno.\nTiri Salvezza: Forza, Destrezza.\nAbilità: Scegli tre abilità tra Addestrare Animali, Atletica, Furtività, Indagare Intuizione, Natura, Percezione e Sopravvivenza.\n\n---\n\n**EQUPAGGIAMENTO**\nInizi con il seguente equipaggiamento, oltre all\'equipaggiamento fornito dal tuo background:\n(a) armatura a scaglie o (b) armatura di cuoio\n(a) due spade corte o (b) due armi semplici\n(a) uno zaino da speleologo o (b) uno zaino da esploratore\n\n---\n\n**NEMICO** **PRESCELTO**\nA partire dal 1° livello, hai sviluppato una significativa esperienza nello studio, seguire tracce, cacciare e anche parlare con un certo tipo di nemico.\nScegli un tipo di nemico prescelto: aberrazioni, bestie, celestiali, costrutti, draghi, elementali, fatati, giganti, immondi, melme, mostruosità, non morti o vegetali.\nIn alternativa puoi scegliere come nemico favorito due razze umanoidi (come gnoll e orchi).\nHai vantaggio sulle prove di Saggezza (Sopravvivenza) per seguire le tracce dei tuoi nemici favoriti, oltre che alle prove di Intelligenza per ricordare informazioni su di loro.\nQuando ottieni questo privilegio, apprendi anche un linguaggio di tua scelta che venga parlato dal nemico prescelto, se questi è in grado di parlare.\nScegli un ulteriore nemico prescelto, oltre che un linguaggio a esso associato, al 6° e 14° livello.\nCon l\'aumentare di livello, le tue scelte dovrebbero riflettere i tipi di mostri che hai incontrato nel corso delle tue avventure.\n\n---\n\n**ESPLORATORE** **NATO**\nSei particolarmente familiare con un tipo di ambiente naturale e sei esperto nel viaggiare e sopravvivere in questa regione.\nScegli un tipo di terreno prescelto: artico, costa, deserto, foresta, montagna, palude o pianura.\nQuando effettui una prova di Intelligenza o Saggezza collegata al tuo terreno prescelto, il tuo bonus di competenza viene raddoppiato se stai usando un\'abilità in cui sei competente.\nMentre viaggi per un\'ora o più sul tuo terreno prescelto, ottieni i seguenti benefici:\n-Il terreno difficile non rallenta il movimento del tuo gruppo.\n-Il tuo gruppo non può perdersi, se non a causa di effetti magici.\n-Anche quando sei impegnato in un\'altra attività durante il viaggio (come foraggiare, navigare o seguire tracce), sei sempre allerta dei pericoli.\n-Se stai viaggiando da solo, puoi muoverti furtivamente tenendo un\'andatura normale.\n-Quando foraggi, trovi il doppio del cibo che troveresti normalmente.\n-Mentre segui le tracce di altre creature, ne apprendi anche il numero esatto, la taglia e quanto tempo sia trascorso dal loro passaggio nell\'area.\nScegli un ulteriore terreno prescelto al 6° e al 10° livello.\n\n---\n\n**STILE** **DI** **COMBATTIMENTO**\nAl 2° livello come tua specializzazione adotti un particolare stile di combattimento.\nScegli una delle seguenti opzioni.\n Non puoi acquisire più di una volta lo stesso Stile di Combattimento, anche se in seguito ottieni una nuova scelta.\n\n---\n\n**COMBATTERE** **CON** 2 **ARMI**\nQuando ti impegni in combattimento con due armi, puoi sommare il tuo modificatore di caratteristica al danno del secondo attacco.\n\n---\n\n**DIFESA**\nQuando indossi un\'armatura, ottieni un bonus di +1 alla **CA**.\n\n---\n\n**DUELLARE**\nQuando impugni un\'arma da mischia in una mano e nessun\'altra arma, ottieni un bonus di +2 ai tiri dei danni con quell\'arma.\n\n---\n\n**TIRO**\nOttieni un bonus di +2 ai tiri per colpire effettuati con le armi a distanza.\n\n---\n\n**INCANTESIMI**\nQuando raggiungi il 2° livello, hai imparato ad usare l\'essenza magica della natura per lanciare incantesimi, in modo simile al druido.\nVedi La Magia per le regole generali sul lancio degli incantesimi e Le Liste degli Incantesimi per una selezione di incantesimi da ranger.\n\n---\n\n**SLOT** **INCANTESIMO**\nLa tabella Il Ranger mostra quanti slot incantesimo hai a disposizione per lanciare i tuoi incantesimi di 1° livello o più alto.\nPer lanciare questi incantesimi, devi spendere uno slot del livello dell\'incantesimo o più alto.\nRecuperi tutti gli slot incantesimo spesi al termine di un riposo lungo.\nPer esempio, se conosci l\'incantesimo di 1° livello amicizia con gli animali e hai uno slot incantesimo di 1° livello e uno di 2° livello, puoi lanciare amicizia con gli animali usando uno qualsiasi dei due slot.\n\n---\n\n**INCANTESIMI** **CONOSCIUTI** **DI** 1° **LIVELLO** O PIÙ **ALTO**\nConosci due incantesimi di 1° livello di tua scelta, presi dalla lista degli incantesimi da ranger.\nLa colonna Incantesimi Conosciuti della tabella Il Ranger, mostra quando apprenderai altri incantesimi da ranger di tua scelta.\nCiascuno di questi incantesimi deve essere di un livello di cui possiedi slot incantesimo.\nPer esempio, quando raggiungi il 5° livello in questa classe, puoi apprendere un nuovo incantesimo di 1° o 2° livello.\nInoltre, quando ottieni un livello in questa classe, puoi scegliere uno degli incantesimi da ranger che conosci e sostituirlo con un altro incantesimo dalla lista degli incantesimi da ranger, che deve essere comunque di un livello di cui possiedi slot incantesimo.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nLa Saggezza è la tua caratteristica da incantatore per gli incantesimi da ranger, dato che la tua magia deriva dalla tua sintonia con la natura.\nUsi la Saggezza ogni volta che un incantesimo da ranger fa riferimento alla tua caratteristica da incantatore.\nInoltre, usi il modificatore di Saggezza quando stabilisci la **CD** del tiro salvezza di un incantesimo da ranger da te lanciato e quando effettui un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell\'incantesimo = 8 + tuo bonus di competenza + tuo modificatore di Saggezza.\nModificatore di attacco dell\'incantesimo = tuo bonus di competenza + tuo modificatore di Saggezza.\n\n---\n\n**ARCHETIPO** **RANGER**\nA partire dal 3° livello, scegli un archetipo che cerchi di emulare, come il Cacciatore.\nQuesta scelta ti conferisce un privilegio al 3° livello, e un altro al 7°, 11° e 15° livello.\n\n---\n\n**CONSAPEVOLEZZA** **PRIMORDIALE**\nA partire dal 3° livello, puoi usare la tua azione e spendere uno slot incantesimo da ranger per concentrare la tua consapevolezza sulla regione circostante.\nPer 1 minuto per livello dello slot incantesimo speso, puoi percepire se le seguenti creature siano presenti entro 1,5 chilometri da te (o entro 10 chilometri se sei nel tuo terreno prescelto): aberrazioni, celestiali, draghi, elementali, fatati, immondi e non morti.\nQuesto privilegio non rivela la posizione o il numero delle creature.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando raggiungi il 4° livello, e poi ancora all\'8°, 12°, 16° e 19° livello, puoi incrementare un tuo punteggio di caratteristica di 2, o incrementare due punteggi di caratteristica di 1.\nDi norma, utilizzando questo privilegio non puoi accrescere un punteggio di caratteristica oltre il 20.\n\n---\n\n**ATTACCO** **EXTRA**\nA partire dal 5° livello, puoi attaccare due volte, invece che una volta, ogni volta che effettui l\'azione Attaccare durante il tuo turno.\n\n---\n\n**ANDATURA** **SUL** **TERRENO**\nA partire dall\'8° livello, muoversi attraverso terreno difficile non magico non ti costa più movimento aggiuntivo.\nPuoi attraversare i vegetali non magici senza esserne rallentato e senza subire danni da essi, se presentano spine, spuntoni o simili pericoli.\nInoltre, hai vantaggio sui tiri salvezza contro vegetali che sono stati creati o manipolati magicamente per impedire il movimento, come quelli creati dall\'incantesimo intralciare.\n\n---\n\n**NASCONDERSI** **IN** **PIENA** **VISTA**\nA partire dal 10° livello, puoi spendere 1 minuto a mimetizzarti.\nDevi avere accesso a fango fresco, terriccio, piante e fuliggine e altri materiali naturali con i quali creare il tuo camuffamento.\nUna volta mimetizzato in questo modo, puoi cercare di nasconderti appiattendoti contro una superficie solida, come un albero o un muro, che sia larga e alta almeno quanto te.\nOttieni un bonus di +10 alle prove di Destrezza (Furtività) finché rimani fermo senza muoverti o effettuare azioni.\nUna volta che ti muovi o effettui un\'azione o una reazione, ti devi mimetizzare di nuovo per ottenere questo beneficio.\n\n---\n\n**SVANIRE**\nA partire dal 14° livello, puoi usare l\'azione Nascondersi come azione bonus durante il tuo turno.\nInoltre, le tue tracce non possono essere rilevate se non con mezzi magici, a meno che tu non decida di lasciare una scia.\n\n---\n\n**SENSI** **FERINI**\nAl 18° livello, sviluppi dei sensi soprannaturali che ti aiutano a combattere le creature che non puoi vedere.\nQuando attacchi una creatura che non puoi vedere, la tua incapacità di vedere non comporta svantaggio ai tiri per colpire contro di essa.\nSei anche consapevole della posizione di qualsiasi creatura invisibile entro 9 metri da te, purché la creatura non sia nascosta a te, e tu non sia accecato o assordato.\n\n---\n\n**STERMINATORE** **DI** **NEMICI**\nAl 20° livello, diventi un insuperabile cacciatore dei tuoi nemici.\nUna volta durante ciascun tuo turno, puoi sommare il tuo modificatore di Saggezza al tiro per colpire o al tiro di danno di un attacco effettuato contro uno dei tuoi nemici prescelti.\nPuoi scegliere di usare questo privilegio prima o dopo il tiro, ma prima che qualsiasi risultato del tiro venga applicato.'),
  stregone(
      'Stregone',
      [
        SubClass.discendenzaDraconica,
        SubClass.magiaSelvaggia,
      ],
      true,
      [
        SubSkill.arcano,
        SubSkill.religione,
        SubSkill.intuizione,
        SubSkill.inganno,
        SubSkill.intimidire,
        SubSkill.persuasione,
      ],
      2,
      [
        Mastery.balestreLeggere,
        Mastery.bastoniFerrati,
        Mastery.dardi,
        Mastery.fionde,
        Mastery.pugnali,
      ],
      0,
      [],
      [Skill.costituzione, Skill.carisma],
      [
        {
          Equipment.unaBalestraLeggeraE20Quadrelli: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {Item.borsaPerComponenti: 1, Item.focusArcano: 1},
        {Weapon.pugnale: 2},
        {
          Equipment.dotazioneDaAvventuriero: 1,
          Equipment.dotazioneDaEsploratore: 1
        },
      ],
      'Uno stregone ottiene i seguenti privilegi di classe.\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d6 per ogni livello da stregone.\nPunti Ferita al 1° Livello: 6 + il modificatore di Costituzione dello stregone.\nPunti Ferita ai Livelli Successivi: 1d6 (o 4) + il modificatore di Costituzione dello stregone per ogni livello da stregone dopo il 1°.\n\n---\n\n**COMPETENZE**\nArmature: Nessuna.\nArmi: Balestre leggere, bastoni ferrati, dardi, fionde, pugnali.\nStrumenti: Nessuno.\nTiri Salvezza: Costituzione, Carisma.\nAbilità: Due a scelta tra Arcano, Inganno, Intimidire, Intuizione, Persuasione e Religione.\n\n---\n\n**EQUIPAGGIAMENTO**\nUno stregone inizia con l\'equipaggiamento seguente, in aggiunta all\'equipaggiamento conferito dal suo background:\n(a) una balestra leggera e 20 quadrelli o (b) una qualsiasi arma semplice\n(a) una borsa per componenti o (b) un focus arcano\n(a) una dotazione da avventuriero o (b) una dotazione da esploratore\nDue pugnali\n\nINCANTESIMIUn evento nel passato dello stregone o nella vita di un suo parente o antenato ha lasciato su di lui un segno indelebile, infondendogli una fonte di magia arcana.\nÈ questa fonte di magia, qualunque sia la sua origine, ad alimentare i suoi incantesimi.\nVedi il capitolo 10 per le regole generali relative alla magia e il capitolo 11 per la lista degli incantesimi da stregone.\n\n---\n\n**TRUCCHETTI**\nAl 1° livello, uno stregone conosce quattro trucchetti a sua scelta tratti dalla lista degli incantesimi da stregone.\nApprende ulteriori trucchetti da stregone a sua scelta ai livelli successivi, come indicato dalla colonna "Trucchetti Conosciuti" nella tabella.\n\n---\n\n**SLOT** **INCANTESIMO**\nLa tabella "Stregone" indica quanti slot incantesimo possiede uno stregone per lanciare i suoi incantesimi di 1° livello e di livello superiore.\nPer lanciare uno di questi incantesimi, lo stregone deve spendere uno slot incantesimo di livello pari o superiore al livello dell\'incantesimo.\nLo stregone recupera tutti gli slot incantesimo spesi quando completa un riposo lungo.\nPer esempio, se uno stregone conosce l\'incantesimo di 1° livello Mani Brucianti e possiede uno slot incantesimo di 1° livello e uno slot incantesimo di 2° livello, può lanciare Mani Brucianti usando uno qualsiasi dei due slot.\n\n---\n\n**INCANTESIMI** **CONOSCIUTI** **DI** 1° **LIVELLO** E **DI** **LIVELLO** **SUPERIORE**\nUno stregone conosce due incantesimi di 1° livello a sua scelta dalla lista degli incantesimi da stregone.\nLa colonna "Incantesimi Conosciuti" nella tabella "Stregone" indica quando uno stregone impara altri incantesimi da stregone a sua scelta.\nOgnuno di questi incantesimi deve appartenere a un livello di cui lo stregone possiede degli slot incantesimo, come indicato dalla tabella.\nPer esempio, quando uno stregone arriva al 3° livello, può imparare un nuovo incantesimo di 1° o di 2° livello.\nInoltre, quando uno stregone acquisisce un livello, può scegliere un incantesimo da stregone che conosce e sostituirlo con un altro incantesimo della lista degli incantesimi da stregone; anche il nuovo incantesimo deve essere di un livello di cui lo stregone possiede degli slot incantesimo.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nCarisma è la caratteristica da incantatore per gli incantesimi da stregone, dal momento che il potere magico di uno stregone dipende dall\'intensità con cui egli riesce a proiettare la sua volontà nel mondo esterno.\nUno stregone usa Carisma ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Carisma per definire la **CD** del tiro salvezza di un incantesimo da stregone da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell\'incantesimo = 8 + il bonus di competenza dello stregone + il modificatore di Carisma dello stregone\nModificatore di attacco dell\'incantesimo = il bonus di competenza dello stregone + il modificatore di Carisma dello stregone\n\n---\n\n**FOCUS** **DA** **INCANTATORE**\nUno stregone può usare un focus arcano come focus da incantatore per i suoi incantesimi da stregone.\n\n---\n\n**ORIGINE** **STREGONESCA**\nIl giocatore sceglie un\'origine stregonesca che definisca la fonte dei poteri magici innati dello stregone: Discendenza Draconica o Magia Selvaggia, entrambi descritti alla fine della sezione di questa classe.\nQuesta scelta conferisce allo stregone alcuni privilegi al 1° livello e poi di nuovo al 6°, 14° e 18° livello.\n\n---\n\n**FONTE** **DI** **MAGIA**\nAl 2° livello, uno stregone attinge a una profonda sorgente di magia interiore.\nEssa è rappresentata dai punti stregoneria, che gli consentono di creare una vasta gamma di effetti magici.\n\n---\n\n**PUNTI** **STREGONERIA**\nUno stregone parte con 2 punti stregoneria e ne ottiene altri ai livelli superiori, come indicato nella colonna "Punti Stregoneria" nella tabella "Stregone".\nUno stregone non può mai avere un numero di punti stregoneria superiore al numero indicato sulla tabella per il suo livello.\nLo stregone recupera tutti i punti stregoneria spesi quando completa un riposo lungo.\n\n---\n\n**INCANTESIMI** **FLESSIBILI**\nUno stregone può usare i suoi punti stregoneria per ottenere degli slot incantesimo aggiuntivi, oppure può sacrificare degli slot incantesimo per ottenere dei punti stregoneria aggiuntivi.\nApprende altri modi in cui usare i suoi punti stregoneria quando arriva ai livelli superiori.\n-Creare Slot Incantesimo: Usando un\'azione bonus nel proprio turno, uno stregone può trasformare i punti stregoneria non spesi in uno slot incantesimo.\nLa tabella "Creazione degli Slot Incantesimo" indica il costo di creazione di uno slot incantesimo di ogni livello.\nLo stregone non può creare slot incantesimo di livello superiore al 5°.\nOgni slot incantesimo creato tramite questo privilegio svanisce quando lo stregone completa un riposo lungo.\n-Convertire uno Slot Incantesimo in Punti Stregoneria: Come azione bonus nel proprio turno, uno stregone può spendere uno slot incantesimo per ottenere un numero di punti stregoneria pari al livello dello slot.\n\n---\n\n**LIVELLO** **DELLO** **SLOT** **INCANTESIMO**    **COSTO** **IN** **PUNTI** **STREGONERIA**\n         1°                              2\n         2°                              3\n         3°                              5\n         4°                              6\n         5°                              7\n\n---\n\n**METAMAGIA**\nAl 3° livello, uno stregone sviluppa la capacità di plasmare i suoi incantesimi per adattarli ai suoi bisogni e ottiene due delle seguenti opzioni di Metamagia a sua scelta.\nNe ottiene un\'altra al 10° livello e un\'altra al 17° livello.\nLo stregone può usare soltanto un\'opzione di Metamagia su un incantesimo quando lo lancia, a meno che non sia specificato diversamente.\n\n---\n\n**INCANTESIMO** **CELATO**\nQuando lo stregone lancia un incantesimo, può spendere 1 punto stregoneria per lanciarlo senza componenti somatiche o verbali.\n\n---\n\n**INCANTESIMO** **DISTANTE**\nQuando lo stregone lancia un incantesimo che ha una gittata pari o superiore a 1.\n5 metri, può spendere 1 punto stregoneria per raddoppiare la gittata dell\'incantesimo.\nQuando lancia un incantesimo che ha una gittata a contatto, può spendere 1 punto stregoneria per cambiare quella gittata in 9 metri.\n\n---\n\n**INCANTESIMO** **ESTESO**\nQuando lo stregone lancia un incantesimo di durata pari o superiore a 1 minuto, può spendere 1 punto stregoneria per raddoppiare la sua durata, fino a una durata massima di 24 ore.\n\n---\n\n**INCANTESIMO** **INTENSIFICATO**\nQuando lo stregone lancia un incantesimo che obbliga una creatura a effettuare un tiro salvezza per resistere ai suoi effetti, può spendere 3 punti stregoneria per infliggere svantaggio a un bersaglio dell\'incantesimo in occasione del primo tiro salvezza che effettuerà contro l\'incantesimo.\n\n---\n\n**INCANTESIMO** **POTENZIATO**\nQuando lo stregone tira per i danni di un incantesimo, può spendere 1 punto stregoneria per ripetere il tiro di un numero massimo di dadi pari al suo modificatore di Carisma (fino a un minimo di uno).\nDeve usare i nuovi risultati.\nLo stregone può utilizzare Incantesimo Potenziato anche se ha già utilizzato un\'opzione diversa di Metamagia durante il lancio dell\'incantesimo.\n\n---\n\n**INCANTESIMO** **PRECISO**\nQuando lo stregone lancia un incantesimo che obbliga altre creature a effettuare un tiro salvezza, può proteggere alcune di quelle creature dalla piena forza dell\'incantesimo.\nPer farlo spende 1 punto stregoneria e sceglie un numero massimo di creature pari al suo modificatore di Carisma (fino a un minimo di una creatura).\nOgni creatura scelta supera automaticamente il suo tiro salvezza contro l\'incantesimo.\n\n---\n\n**INCANTESIMO** **RADDOPPIATO**\nQuando lo stregone lancia un incantesimo che bersaglia una sola creatura e non ha una gittata di "incantatore", può spendere un numero di punti stregoneria pari al livello dell\'incantesimo per bersagliare con lo stesso incantesimo una seconda creatura entro gittata (1 punto stregoneria se l\'incantesimo è un trucchetto).\nAffinché si possa selezionare, un incantesimo non deve essere in grado di bersagliare più di una creatura al suo livello di incantesimo attuale.\nPer esempio, Dardo Incantato e Raggio Rovente non sono selezionabili, mentre Raggio di Gelo e Globo Cromatico lo sono.\n\n---\n\n**INCANTESIMO** **RAPIDO**\nQuando lo stregone lancia un incantesimo che ha un tempo di lancio pari a 1 azione, può spendere 2 punti stregoneria per cambiare il tempo di lancio a 1 azione bonus per quel lancio.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello, e poi di nuovo all\'8°, 12°, 16° e 19° livello, uno stregone può aumentare di 2 un punteggio dì caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica a più di 20 utilizzando questo privilegio.\n\n---\n\n**RIPRISTINO** **STREGONESCO**\nAl 20° livello, uno stregone recupera 4 punti stregoneria spesi ogni volta che completa un riposo breve.'),
  warlock(
      'Warlock',
      [
        SubClass.ilGrandeAntico,
        SubClass.ilSignoreFatato,
        SubClass.lImmondo,
      ],
      true,
      [
        SubSkill.arcano,
        SubSkill.storia,
        SubSkill.indagare,
        SubSkill.natura,
        SubSkill.religione,
        SubSkill.inganno,
        SubSkill.intimidire,
      ],
      2,
      [
        Mastery.armatureLeggere,
        Mastery.armiSemplici,
      ],
      0,
      [],
      [Skill.saggezza, Skill.carisma],
      [
        {
          Equipment.unaBalestraLeggeraE20Quadrelli: 1,
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {Item.borsaPerComponenti: 1, Item.focusArcano: 1},
        {
          Weapon.ascia: 1,
          Weapon.bastoneFerrato: 1,
          Weapon.falcetto: 1,
          Weapon.giavellotto: 1,
          Weapon.lancia: 1,
          Weapon.martelloLeggero: 1,
          Weapon.mazza: 1,
          Weapon.pugnale: 1,
          Weapon.randello: 1,
          Weapon.randelloPesante: 1,
          Weapon.arcoCorto: 1,
          Weapon.balestraAMano: 1,
          Weapon.dardo: 1,
          Weapon.fionda: 1,
        },
        {
          Equipment.dotazioneDaAvventuriero: 1,
          Equipment.dotazioneDaStudioso: 1
        },
      ],
      'Un Warlock ottieni i seguenti privilegi di classe:\n\n---\n\n**PUNTI** **FERITA**\nDadi Vita: 1d8 per livello da warlock.\nPunti ferita al 1° livello: 8 + il tuo modificatore di Costituzione del warlock.\nPunti ferita ai livelli successivi: 1d8 (o 5) + il modificatore di Costituzione del warlock per ogni livello da warlock dopo il 1°.\n\n---\n\n**COMPETENZE**\nArmature: Armature leggere.\nArmi: Armi semplici.\nStrumenti: Nessuno.\nTiri Salvezza: Carisma e Saggezza.\nAbilità: Due a scelta tra Arcano, Indagare, Inganno, Intimidire, Natura, Religione, Storia.\n\n---\n\n**EQUIPAGGIAMENTO**\nUn warlock inizia con il seguente equipaggiamento, in aggiunta all\' equipaggiamento conferito dal suo background:\n(a) una balestra leggera e 20 quadrelli o (b) una qualsiasi arma semplice.\n(a) una borsa per componenti o (b) un focus arcano.\n(a) una dotazione da studioso o (b) una dotazione da avventuriero.\nUn\'armatura di cuoio, una qualsiasi arma semplice e due pugnali.\n\n---\n\n**PATRONO** **ULTRATERRENO**\nAl 1° livello, un warlock stipula un patto con un essere extraplanare a sua scelta: il Signore Fatato, l\'Immondo o il Grande Antico, ognuno dei quali è descritto in dettaglio alla fine della sezione di questa classe.\nLa scelta del patrono gli conferisce alcuni privilegi al 1° livello e poi ancora al 6°, 10° e 14° livello.\n\n---\n\n**MAGIA** **DEL** **PATTO**\nLe ricerche arcane condotte dal warlock e l\'energia magica che il suo patrono gli conferisce rendono il warlock particolarmente abile nell\'uso degli incantesimi.\nVedi il capitolo 10 per le regole generali relative alla magia e il capitolo 11 per la lista degli incantesimi da warlock.\n\n---\n\n**TRUCCHETTI**\nUn warlock conosce due trucchetti a sua scelta tratti dalla lista degli incantesimi da warlock.\nApprende ulteriori trucchetti da warlock a sua scelta ai livelli successivi, come indicato dalla colonna "Trucchetti Conosciuti" nella tabella "Warlock".\n\n---\n\n**SLOT** **INCANTESIMO**\nLa tabella "Warlock" indica quanti slot incantesimo possiede un warlock.\nLa tabella indica anche il livello di quegli slot; tutti gli slot incantesimo da warlock sono dello stesso livello.\nPer lanciare un incantesimo pari o superiore 1°, il warlock deve spendere uno slot incantesimo.\nIl warlock recupera tutti gli slot incantesimo spesi quando completa un riposo breve o lungo.\nPer esempio, un warlock di 5° livello possiede due slot incantesimo di 3° livello.\nPer lanciare l\'incantesimo di 1° livello dardo stregato deve spendere uno di quegli slot e lanciarlo come incantesimo di 3° livello.\n\n---\n\n**INCANTESIMI** **CONOSCIUTI** **DI** 1° **LIVELLO** E **DI** **LIVELLO** **SUPERIORE**\nAl 1° livello, un warlock conosce due incantesimi di 1° livello a sua scelta dalla lista degli incantesimi da warlock.\nLa colonna "Incantesimi Conosciuti" nella tabella "Warlock" indica quando un warlock impara altri incantesimi da warlock a sua scelta, di 1° livello o superiore.\nOgnuno di questi incantesimi deve appartenere a un livello pari o inferiore al "Livello di Slot" relativo al livello attuale del warlock e indicato nella sua tabella.\nPer esempio, quando un warlock arriva al 6° livello apprende un nuovo incantesimo da warlock di 1°, 2° o 3° livello.\nInoltre, quando un warlock acquisisce un livello, può scegliere un incantesimo da warlock che conosce e sostituirlo con un altro incantesimo della lista degli incantesimi da warlock; anche il nuovo incantesimo deve essere di un livello di cui il warlock possiede degli slot incantesimo.\n\n---\n\n**CARATTERISTICA** **DA** **INCANTATORE**\nCarisma è la caratteristica da incantatore per gli incantesimi da warlock, quindi un warlock usa Carisma ogni volta che un incantesimo fa riferimento alla sua caratteristica da incantatore.\nUsa inoltre il suo modificatore di Carisma per definire la **CD** del tiro salvezza di un incantesimo da warlock da lui lanciato e quando effettua un tiro per colpire con un incantesimo.\n\n---\n\n**CD** del tiro salvezza dell\'incantesimo = 8 + il bonus di competenza del warlock + il modificatore di Carisma del warlock\nModificatore di attacco dell\'incantesimo = il bonus di competenza del warlock + il modificatore di Carisma del warlock\n\n---\n\n**FOCUS** **DA** **INCANTATORE**\nUn warlock può usare un focus (vedi il capitolo 5, "Equipaggiamento") come focus da incantatore per i suoi incantesimi da warlock.\n\n---\n\n**SUPPLICHE** **OCCULTE**\nDedicandosi allo studio delle scienze occulte, un warlock ha scoperto come usare alcune suppliche occulte, frammenti di conoscenze proibite che gli conferiscono persistenti doti magiche.\nAl 2° livello, il warlock ottiene due suppliche occulte a sua scelta.\nLe sue opzioni di invocazione sono descritte alla fine della sezione di questa classe.\nQuando il warlock raggiunge livelli superiori, ottiene ulteriori suppliche a sua scelta, come indicato nella colonna "Suppliche Conosciute" nella tabella "Warlock".\nInoltre, quando acquisisce un nuovo livello, il warlock può scegliere una delle suppliche che conosce e sostituirla con un\'altra che potrebbe imparare a quel livello.\n\n---\n\n**DONO** **DEL** **PATTO**\nAl 3° livello, il patrono ultraterreno elargisce al warlock un dono per ricompensarlo dei suoi fedeli servigi.\nIl warlock ottiene uno dei privilegi seguenti a sua scelta.\n\n---\n\n**PATTO** **DELLA** **CATENA**\nIl warlock impara l\'incantesimo trova famiglio e può lanciarlo come rituale.\nQuesto incantesimo non va conteggiato al fine di determinare il numero di incantesimi conosciuti dal warlock.\nQuando il warlock lancia l\'incantesimo può scegliere per il suo famiglio una delle forme normali o una delle forme speciali seguenti: imp, pseudodrago, quasit o spiritello.\nInoltre, quando effettua l\'azione di Attacco, il warlock può rinunciare a uno dei suoi attacchi per consentire al suo famiglio di effettuare un suo attacco individuale con la sua reazione.\n\n---\n\n**PATTO** **DELLA** **LAMA**\nIl warlock può usare la sua azione per fare apparire un\'arma del patto nella sua mano vuota.\nPuò scegliere la forma che questa arma da mischia assume ogni volta che la crea(vedi capito lo 5 per le armi disponibili).\nIl warlock è considerato competente nell\'arma fintanto che la impugna.\nQuesta arma è considerata magica al fine di oltrepassare la resistenza e l\'immunità agli attacchi e ai danni non magici.\nL\'arma del patto scompare se rimane per un minuto a più di 1,5 metri di distanza dal warlock.\nL\'arma scompare anche se il warlock utilizza di nuovo il privilegio, se la congeda (non è richiesta alcuna azione per farlo), o se muore.\nIl warlock può trasformare un\'arma magica nella sua arma del patto celebrando un rituale speciale mentre la impugna.\nIl rituale dura 1 ora e può essere completato durante un periodo di riposo breve.\nUna volta completato il rituale, il warlock può congedare l\'arma relegandola in uno spazio extradimensionale; da allora in poi compare ogni volta che il warlock crea la sua arma del patto.\nNon è possibile influenzare un artefatto o un\'arma senziente in questo modo.\nL\'arma cessa di essere l\'arma del patto se il warlock muore, se celebra un rituale di 1 ora su un\'altra arma o se celebra un altro rituale di 1 ora per spezzare il suo vincolo con l\'arma.\nSe l\'arma si trova nello spazio extradimensionale quando il vincolo viene spezzato, essa ricompare ai piedi del warlock.\n\n---\n\n**PATTO** **DEL** **TOMO**\nIl patrono dona al warlock un grimorio chiamato Libro dell Ombre.\nQuando ottiene questo privilegio, il warlock può scegliere tre trucchetti dalla lista degli incantesimi di qualsiasi classe (che non devono necessariamente appartenere nella stessa lista).\nQuando il warlock porta il libro con sè, può lanciare quei trucchetti a volontà.\nNon vengono conteggiati al fine di determinare il numero di trucchetti conosciuto dal warlock.\nAnche se non compaiono sulla lista degli incantesimi da warlock, sono comunque considerati incantesimi da warlock per lui.\nSe il Libro delle Ombre viene perduto, il warlock può effettuare un cerimoniale da 1 ora per ricevere un altro dal proprio patrono.\nTale cerimoniale può essere effettuato durante un periodo di riposo breve o lungo, e provoca la distruzione del vecchio libro.\nIl libro si riduce in polvere alla morte del warlock.\n\n---\n\n**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nQuando arriva al 4° livello, e poi di nuovo all\'8°,12°,16° e 19° livello, un warlock può aumentare di 2 un punteggio di caratteristica a sua scelta, oppure può aumentare di 1 due punteggi di caratteristica a sua scelta.\nCome di consueto, non è consentito aumentare un punteggio di caratteristica a più di 20 utilizzando questo privilegio.\n\n---\n\n**ARCANUM** **MISTICO**\nAll\'11° livello, il patrono rivela al warlock un segreto magico chiamato arcanum.\nIl warlock sceglie un incantesimo di 6° livello dalla lista degli incantesimi da warlock come arcanum.\nIl warlock può lanciare il suo incantesimo arcanum senza spendere uno slot incantesimo.\nDeve completare un riposo lungo prima di poterlo fare di nuovo.\nAi livelli successivi, il warlock ottiene altri incantesimi da warlock a sua scelta da lanciare in questo modo: un incantesimo di 7° livello al 13°livello, un incantesimo di 8° livello al 15° livello e un incantesimo di 9° livello al 17° livello.\nRecupera tutti gli utilizzi del suo Arcanum Mistico quando completa un riposo lungo.\n\n---\n\n**MAESTRO** **DELL**\'**OCCULTO**\nAl 20° livello, il warlock è in grado di attingere alla sua riserva interiore di potere mistico quando invoca il suo patrono per riottenere gli slot incantesimo spesi.\nIl warlock può trascorrere 1 minuto invocando l\'aiuto del suo patrono per riottenere tutti gli slot incantesimo concessi dal privilegio Magia del Patto che ha speso.\nUna volta riottenuti gli slot incantesimo tramite questo privilegio, il warlock deve completare un riposo lungo prima di poterlo fare di nuovo.\n\n---\n\n**SUPPLICHE** **OCCULTE**\nSe una supplica occulta prevede dei prerequisiti, il warlock deve soddisfarli per poterla apprendere.\nPuò apprendere quella supplica nel momento in cui ne soddisfa i prerequisiti.\nUn prerequisito di livello indica il livello nella classe del warlock.\n\n---\n\n**ARMATURA** **DELLE** **OMBRE**\nIl warlock può lanciare armatura magica su se stesso a volontà, senza spendere uno slot incantesimo o componenti materiali.\n\n---\n\n**BALZO** **ULTRATERRENO**\nPrerequisito: 9° livello.\nIl warlock può lanciare saltare su se stesso a volontà, senza spendere uno slot incantesimo o componenti materiali.\n\n---\n\n**CATENE** **DI** **CARCERI**\nPrerequisiti: 15° livello, privilegio Patto della Catena.\nIl warlock può lanciare blocca mostri a volontà (bersagliando un celestiale, un immondo o un elementale) senza spendere uno slot incantesimo o componenti materiali.\nDeve completare un riposo lungo prima che possa usare di nuovo questa supplica sulla stessa creatura.\n\n---\n\n**DEFLAGRAZIONE** **AGONIZZANTE**\nPrerequisito: trucchetto deflagrazione occulta.\nQuando il warlock lancia deflagrazione occulta, aggiunge il suo modificatore di Carisma ai danni che infligge quando colpisce il bersaglio.\n\n---\n\n**DEFLAGRAZIONE** **RESPINGENTE**\nPrerequisito: trucchetto deflagrazione occulta.\nQuando il warlock colpisce una creatura con deflagrazione occulta, può spingere la creatura fino a un massimo di 3 metri per allontanarla da sé in linea retta.\n\n---\n\n**FARDELLO** **MENTALE**\nPrerequisito: 5° livello.\nIl warlock può lanciare lentezza una volta usando uno slot incantesimo da warlock.\nNon può farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**INFLUENZA** **SEDUCENTE**\nIl warlock ottiene competenza nelle abilità Inganno e Persuasione.\n\n---\n\n**LADRO** **DEI** **CINQUE** **FATI**\nIl warlock può lanciare anatema una volta usando uno slot incantesimo da warlock.\nNon può farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**LAMA** **ASSETATA**\nPrerequisiti: 5° livello, privilegio Patto della Lama.\nOgni volta che effettua l\'azione di Attacco nel suo turno, il warlock può attaccare con la sua arma del patto due volte anziché una volta.\n\n---\n\n**LANCIA** **OCCULTA**\nPrerequisito: trucchetto deflagrazione occulta.\nQuando il warlock lancia deflagrazione occulta, la sua gittata è di 90 metri.\n\n---\n\n**LIBRO** **DEGLI** **ANTICHI** **SEGRETI**\nPrerequisito: privilegio Patto del Tomo.\nIl warlock può ora trascrivere i rituali magici nel suo Libro delle Ombre.\nSceglie due incantesimi di 1° livello con il descrittore rituale dalle liste di incantesimi di qualsiasi classe (non è necessario che i due incantesimi appartengano alla stessa lista).\nGli incantesimi compaiono nel libro e non contano ai fini di determinare il numero di incantesimi che il warlock conosce.\nQuando il warJock impugna il suo Libro delle Ombre, può lanciare gli incantesimi scelti come rituali.\nPuò lanciare quegli incantesimi soltanto come rituali, a meno che non li abbia appresi anche in altri modi.\nPuò inoltre lanciare un incantesimo da warlock che lui conosce come rituale, se tale incantesimo possiede il descrittore rituale.\nNel corso delle sue avventure, il warlock può aggiungere altri incantesimi rituali al suo Libro delle Ombre.\nQuando trova un incantesimo del genere, può aggiungerlo al libro se il livello dell\'incantesimo è pari o inferiore alla metà del suo livello da warlock (arrotondato per eccesso) e se dispone di abbastanza tempo da trascrivere l\'incantesimo.\nPer ogni livello dell\'incantesimo, il processo di trascrizione richiede 2 ore e costa 50 mo per gli inchiostri rari richiesti.\n\n---\n\n**LINGUE** **DELLE** **BESTIE**\nIl warlock può lanciare parlare con ali animali a volontà, senza spendere uno slot incantesimo.\n\n---\n\n**MAESTRO** **DI** **MILLE** **FORME**\nPrerequisito: 15° livello.\nIl warlock può lanciare alterare se stesso a volontà, senza spendere uno slot incantesimo.\n\n---\n\n**MASCHERA** **DEI** **MOLTI** **VOLTI**\nIl warlock può lanciare camuffare se stesso a volontà, senza spendere uno slot incantesimo.\n\n---\n\n**OCCHI** **DEL** **CUSTODE** **DELLE** **RUNE**\nIl warlock è in grado di leggere ogni forma di scrittura.\n\n---\n\n**PAROLA** **TEMIBILE**\nPrerequisito: 7° livello.\nIl warlock può lanciare confusione una volta usando uno slot incantesimo da warlock.\nNon pub farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**PASSO** **ASCENDENTE**\nPrerequisito: 9° livello.\nIl warlock pub lanciare levitazione su se stesso a volontà, senza spendere uno slot incantesimo o componenti materiali.\n\n---\n\n**PRESAGIO** **DI** **SVENTURA**\nPrerequisito: 5° livello.\nIl warlock può lanciare scagliare maledizione una volta usando uno slot incantesimo da warlock.\nNon può farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**SCULTORE** **DELLA** **CARNE**\nPrerequisito: 7° livello.\nIl warlock può lanciare metamorfosi una volta usando uno slot incantesimo da warlock.\nNon può farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**SERVITORI** **DEL** **CAOS**\nPrerequisito: 9° livello.\nIl warlock può lanciare evoca e/ementa/e una volta usando uno slot incantesimo da warlock.\nNon può farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**SGUARDO** **DELLE** **DUE** **MENTI**\nIl warlock può usare la sua azione per toccare un umanoide consenziente e percepire il mondo attraverso i suoi sensi fino alla fine del proprio turno successivo.\nFintanto che la creatura si trova sullo stesso piano di esistenza del warlock, quest\'ultimo può usare la sua azione nei turni successivi per mantenere questo legame, estendendo la durata fino alla fine del suo turno successivo.\nFinché percepisce il mondo attraverso i sensi dell\'altra creatura, il warlock beneficia degli eventuali sensi speciali posseduti da essa, ma è cieco e sordo riguardo a cib che accade attorno a lui.\n\n---\n\n**SUCCHIAVITA**\nPrerequisiti: 12° livello, privilegio Patto della Lama.\nQuando il warlock colpisce una creatura con la sua arma del patto, quella creatura subisce danni necrotici extra pari al modificatore di Carisma del warlock (fino a un minimo di 1).\n\n---\n\n**SUSSURRI** **DALLA** **TOMBA**\nPrerequisito: 9° livello.\nIl warlock può lanciare parlare con i morti a volontà, senza spendere uno slot incantesimo.\n\n---\n\n**SUSSURRI** **STREGATI**\nPrerequisito: 7° livello.\nIl warlock può lanciare compulsione una volta usando uno slot incantesimo da warlock.\nNon può farlo di nuovo finché non completa un riposo lungo.\n\n---\n\n**TUTT**\'**UNO** **CON** **LE** **OMBRE**\nPrerequisito: 5° livello.\nQuando il warlock si trova in un\'area di luce fioca o di oscurità, può usare la sua azione per diventare invisibile finché non si muove, effettua un\'azione o una reazione.\n\n---\n\n**VIGORE** **IMMONDO**\nIl warlock può lanciare vita falsata su se stesso a volontà come incantesimo di 1° livello, senza spendere uno slot incantesimo o componenti materiali.\n\n---\n\n**VISIONE** **DEI** **REAMI** **LONTANI**\nPrerequisito: 15° livello.\nIl warlock può lanciare occhio arcano a volontà, senza spendere uno slot incantesimo.\n\n---\n\n**VISIONI** **VELATE**\nIl warlock può lanciare immagine silenziosa a volontà, senza spendere uno slot incantesimo o componenti materiali.\n\n---\n\n**VISTA** **DEL** DIAVOLOIl warlock è in grado di vedere normalmente nell\'oscurità, sia magica che comune, fino a una distanza di 36 metri.\n\n---\n\n**VISTA** **DELL**\'**OCCULTO**\nIl warlock può lanciare individuazione del magico a volontà, senza spendere uno slot incantesimo.\n\n---\n\n**VISTA** **STREGATA**\nPrerequisito: 15° livello.\nIl warlock è in grado di vedere la vera forma di qualsiasi mutaforma o creatura celata da una magia di illusione o trasmutazione, fintanto che quella creatura si trova entro 9 metri da lui ed entro linea di vista.\n\n---\n\n**VOCE** **DEL** **SIGNORE** **DELLE** **CATENE**\nPrerequisito: privilegio Patto della Catena.\nIl warlock può comunicare telepaticamente con il suo famiglio e percepire il mondo attraverso i sensi di quest\'ultimo, purché entrambi si trovino sullo stesso piano di esistenza.\nInoltre, finché percepisce il mondo attraverso i sensi del suo famiglio, il warlock può anche parlare attraverso il famiglio con la propria voce anche se il suo famiglio normalmente non è in grado di parlare.\n');

  @override
  final String title, description;
  final List<SubClass> subClasses;
  final bool isEnchanter;
  final List<SubSkill> choiceableSubSkills;
  final int numChoiceableSubSkills, numChoiceableMasteries;
  final List<Mastery> defaultMasteries;
  final List<MasteryType> choiceableMasteryTypes;
  final List<Skill> savingThrowSkills;
  final List<Map<InventoryItem, int>> choiceableItems;

  const Class(
      this.title,
      this.subClasses,
      this.isEnchanter,
      this.choiceableSubSkills,
      this.numChoiceableSubSkills,
      this.defaultMasteries,
      this.numChoiceableMasteries,
      this.choiceableMasteryTypes,
      this.savingThrowSkills,
      this.choiceableItems,
      this.description);

  String get subClassesInfo => subClasses.isEmpty
      ? 'Nessuna sottoclasse'
      : subClasses.map((e) => e.title).join(', ');
}

enum SubRace implements EnumWithTitle {
  elfoAlto(
      'Elfo alto',
      1,
      {Skill.intelligenza: 1},
      [
        Mastery.spadeCorte,
        Mastery.spadeLunghe,
        Mastery.archiCorti,
        Mastery.archiLunghi
      ],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di Intelligenza aumenta di 1.\n\n---\n\n**ADDESTRAMENTO** **NELLE** **ARMI** **ELFICHE**\nAvete competenza con spada lunga, spada corta, arco corto e arco lungo.\n\n---\n\n**TRUCCHETTO**\nConoscete un trucchetto a vostra scelta dalla lista degli incantesimi da mago.\nL\'Intelligenza è la caratteristica chiave per lanciare questo incantesimo.\n\n---\n\n**LINGUAGGI** **EXTRA**\nPotete parlare, leggere e scrivere un linguaggio extra a vostra scelta.\n'),
  elfoDeiBoschi(
      'Elfo dei boschi',
      0,
      {Skill.saggezza: 1},
      [
        Mastery.spadeCorte,
        Mastery.spadeLunghe,
        Mastery.archiCorti,
        Mastery.archiLunghi
      ],
      10.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di saggezza di un elfo dei boschi aumenta di 1.\n\n---\n\n**ADDESTRAMENTO** **NELLE** **ARMI** **ELFICHE**\nUn elfo dei boschi ha competenza nelle spade corte, nelle spade lunghe, negli archi corti e negli archi lunghi.\n\n---\n\n**PIEDE** **LESTO**\nLa velocità base sul terreno di un elfo dei boschi aumenta a 10,5 metri.\n\n---\n\n**MASCHERA** **DELLA** **SELVA**\nUn elfo dei boschi può tentare di nascondersi alla vista altrui anche quando è leggermente oscurato da fogliamo, pioggia fitta, neve, foschia e altri fenomeni naturali'),
  elfoOscuro(
      'Elfo oscuro',
      0,
      {Skill.carisma: 1},
      [Mastery.spadeCorte, Mastery.stocchi, Mastery.balestreAMano],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di carisma di un elfo oscuro aumenta di 1.\n\n---\n\n**SCUROVISIONE** **SUPERIORE**\nLa scurovisione di un elfo oscuro arriva fino a 36 metri.\n\nSENSIBILITà **ALL** **LUCE** **DEL** **SOLE**\nUn elfo oscuro dispone di svantaggio ai tiri per colpire e alle prove di saggezza(Percezione) basate sulla vista quando l\'elfo in questione, il bersaglio del suo attacco o l\'oggetto da percepire si trovano in piena luce del sole.\n\n---\n\n**MAGIA** **DROW**\nUn elfo oscuro conosce il trucchetto "luci danzanti".\nQuando raggiunge il 3° livello, può lanciare l\'incantesimo "luminescenza" una volta con questo tratto e recuperare la capacità di farlo quando completa un riposo lungo.\nQuando raggiunge il 5° livello, può lanciare l\'incantesimo "oscurità" una volta con questo tratto e recuperà la capacità di farlo quando completa un riposo lungo.\nLa caratteristica da incantatore per questi incantesimi è carisma.'),
  gnomoDelleForeste('Gnomo delle foreste', 0, {Skill.destrezza: 1}, [], 7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di Destrezza di uno gnomo delle foreste aumenta di 1.\n\n---\n\n**ILLUSIONISTA** **NATO**\nUno gnomo delle foreste conosce il trucchetto illusione minore.\nLa caratteristica da incantatore usata per questo trucchetto è Intelligenza.\n\n---\n\n**PARLARE** **CON** **LE** **PICCOLE** **BESTIE**\nUno gnomo delle foreste può usare suoni e gesti per comunicare i concetti più semplici alle bestie di taglia Piccola o inferiore.\nGli gnomi delle foreste amano gli animali e spesso tengono presso di loro scoiattoli, tassi, conigli, talpe, picchi e altre creature simili come animali da compagnia.'),
  gnomoDelleRocce('Gnomo delle rocce', 0, {Skill.costituzione: 2}, [], 7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di Costituzione aumenta di 2.\n\n---\n\n**SAPERE** **DA** **ARTEFICE**\nOgni volta che fate una prova di Intelligenza (Storia) relativa ad oggetti magici, oggetti alchemici o dispositivi tecnologici, potete aggiungere il doppio del bonus di competenza, invece di qualsiasi bonus di competenza applichiate normalmente.\n\n---\n\n**INVENTORE**\nAvete competenza con strumenti da artigiano (strumenti da inventore).\nUsando questi strumenti, potete spendere 1 ora e materiali del valore di 10 mo per costruire un congegno ad orologeria Minuscolo (**CA** 5, 1 pf).\nIl congegno cessa di funzionare dopo 24 ore (a meno che spendiate 1 ora a ripararlo per mantenerlo in funzione) o quando usate un\'azione per smantellarlo; in quel caso potete recuperare i materiali usati per crearlo.\nPotete avere fino a tre di tali congegni attivi nello stesso momento.\nQuando create un congegno, scegliete una delle seguenti opzioni:\n-Giocattolo ad orologeria: Questo giocattolo è un animale, mostro o persona ad orologeria, come una rana, un topo, un uccello, un drago o un soldato.\nUna volta posizionato sul terreno, il giocattolo si muove di 1,5 m sul terreno in ognuno dei vostri turni in una direzione casuale.\nFa rumore come appropriato per la creatura che rappresenta.\n-Accendino: Il dispositivo produce una fiamma in miniatura, che potete usare per accendere una candela, una torcia o un fuoco da campo.\nUsare il congegno richiede un\'azione.\n-Scatola Musicale: Una volta aperta, questa scatola musicale suona una singola canzone ad un volume moderato.\nLa scatola finisce di suonare quando raggiunge la fine della canzone o quando viene chiusa.'),
  halflingPiedelesto('Halfling piedelesto', 0, {Skill.carisma: 1}, [], 7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di Carisma di un halfling piedelesto aumenta di 1.\n\nFURTIVITÀ **INNATA**\nUn halfling piedelesto può tentare di nascondersi anche se è oscurato solo da una singola creatura, purché questa sia più grande di lui di almeno una taglia.'),
  halflingTozzo('Halfling tozzo', 0, {Skill.costituzione: 1}, [], 7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di Costituzione di un halfling tozzo aumenta di 1.\n\n---\n\n**RESILIENZA** **DEI** **TOZZI**\nUn halfling tozzo dispone di vantaggio ai tiri salvezza contro il veleno e di resistenza ai danni da veleno.'),
  nanoDelleColline('Nano delle colline', 0, {Skill.saggezza: 1}, [], 7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di Saggezza aumenta di 1.\n\n---\n\n**ROBUSTEZZA** **NANICA**\nIl massimo dei punti ferita aumenta di 1 ed aumenta di 1 ogni volta che guadagnate un livello.'),
  nanoDelleMontagne(
      'Nano delle montagne',
      0,
      {Skill.forza: 2},
      [Mastery.armatureLeggere, Mastery.armatureMedie],
      7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\nIl punteggio di forza di un nano delle montagne aumenta di 2.\n\n---\n\n**ADDESTRAMENTO** **NELLE** **ARMATURE** **NANICHE**\nUn nano delle montagne ha competenza nelle armature leggere e medie.'),
  dragoDArgento("Drago d\'argento", 0, {}, [], 9, null),
  dragoBianco("Drago bianco", 0, {}, [], 9, null),
  dragoBlu("Drago blu", 0, {}, [], 9, null),
  dragoDiBronzo("Drago di bronzo", 0, {}, [], 9, null),
  dragoNero("Drago nero", 0, {}, [], 9, null),
  dragoDOro("Drago d\'oro", 0, {}, [], 9, null),
  dragoDOttone("Drago d\'ottone", 0, {}, [], 9, null),
  dragoDiRame("Drago di rame", 0, {}, [], 9, null),
  dragoRosso("Drago rosso", 0, {}, [], 9, null),
  dragoVerde("Drago verde", 0, {}, [], 9, null),
  ;

  @override
  final String title;
  final String? _description;
  final int numChoiceableLanguages;
  final Map<Skill, int> defaultSkills;
  final double defaultSpeed;
  final List<Mastery> defaultMasteries;

  const SubRace(this.title, this.numChoiceableLanguages, this.defaultSkills,
      this.defaultMasteries, this.defaultSpeed, this._description);

  String get description =>
      _description ??
      Race.values.firstWhere((e) => e.subRaces.contains(this)).description;

  Race get race => Race.values.firstWhere((e) => e.subRaces.contains(this));
}

enum Race implements EnumWithTitle {
  umano(
      'Umano',
      [],
      [
        Language.comune,
      ],
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
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**.\n\nOgnuno dei punteggi di caratteristica aumenta di 1.\n\n---\n\n**ETÀ**\n\nGli umani raggiungono la maturità nel secondo decennio e vivono meno di un secolo.\n\n---\n\n**ALLINEAMENTO**.\n\nGli umani non tendono verso nessun allineamento particolare.\n\nTra loro si trova il meglio ed il peggio.\n\n---\n\n**TAGLIA**.\n\nGli umani variano molto in peso e corporatura, da appena 150 cm a ben più di 180 cm.\n\nA prescindere dalla posizione in tale intervallo, la taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 9 metri.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune ed un linguaggio extra a vostra scelta.\n\nGli umani imparano tipicamente i linguaggi degli altri popoli con cui fanno affari, inclusi oscuri dialetti.\n\nGli piace disseminare il loro discorso di parole prese in prestito da altre lingue: maledizioni Orchesche, espressioni musicali Elfiche, frasi militari Naniche e così via.\n\n'),
  nano(
      'Nano',
      [
        SubRace.nanoDelleColline,
        SubRace.nanoDelleMontagne,
      ],
      [
        Language.comune,
        Language.nanico,
      ],
      false,
      {
        Skill.costituzione: 2,
      },
      0,
      0,
      [
        Mastery.scorteDaMescitore,
        Mastery.strumentiDaCostruttore,
        Mastery.strumentiDaFabbro
      ],
      7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Costituzione aumenta di 2.\n\n---\n\n**ETÀ**\n\nI nani maturano allo stessa velocità degli umani, ma sono considerati giovani finché raggiungono l\'età di 50 anni.\n\nIn media, vivono circa 350 anni.\n\n---\n\n**ALLINEAMENTO**\n\nLa maggior parte dei nani sono legali, credendo fermamente nei benefici di una società ben organizzata.\n\nTendono anche al bene, con un forte senso di correttezza e una convinzione che ognuno meriti di partecipare ai benefici di un ordine retto.\n\n---\n\n**TAGLIA**\n\nI nani sono alti tra 120 e 150 cm e pesano circa 70 kg.\n\nLa taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 7,5 metri.\n\nLa velocità non viene ridotta indossando armature pesanti.\n\n---\n\n**SCUROVISIONE**\n\nAbituati alla vita sotterranea, avete una vista superiore in condizioni di buio o luce debole.\n\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\n\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.\n\n---\n\n**RESILIENZA** **NANICA**\n\nAvete vantaggio nei tiri salvezza contro il veleno ed avete resistenza contro i danni da veleno (spiegato nel capitolo 9).\n\n---\n\n**ADDESTRAMENTO** **NEL** **COMBATTIMENTO** **NANICO**\n\nAvete competenza con l\'ascia da battaglia, l\'ascia da lancio, il martello da lancio e il martello da guerra.\n\n---\n\n**COMPETENZA** **NEGLI** **STRUMENTI**\n\nGuadagnate competenza con strumenti da artigiano a vostra scelta: strumenti da fabbro, forniture da birraio o strumenti da muratore.\n\n---\n\n**ESPERTO** **MINATORE**\n\nOgni volta che effettuate una prova di Intelligenza (Storia) relativa all\'origine di opere in muratura, venite considerati competenti nell\'abilità Storia ed aggiungete il doppio del bonus di competenza alla prova, invece del normale bonus di competenza.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune e Nanico.\n\nIl Nanico è pieno di consonanti dure e suoni gutturali e tali caratteristiche si riversano in qualunque altro linguaggio un nano possa parlare.\n\n'),
  elfo(
      'Elfo',
      [
        SubRace.elfoAlto,
        SubRace.elfoDeiBoschi,
        SubRace.elfoOscuro,
      ],
      [
        Language.comune,
        Language.elfico,
      ],
      false,
      {
        Skill.destrezza: 2,
      },
      0,
      0,
      [],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Destrezza aumenta di 2.\n\n---\n\n**ETÀ**\n\nSebbene gli elfi raggiungano la maturità fisica circa alla stessa età degli umani, la cultura elfica dell\'età adulta va oltre la crescita fisica per racchiudere l\'esperienza terrena.\n\nUn elfo rivendica tipicamente l\'età adulta ed un nome da adulto attorno all\'età di 100 anni e può vivere fino a 750 anni.\n\n---\n\n**ALLINEAMENTO**\n\nGli elfi amano la libertà, la diversità e l\'espressione di se stessi, quindi tendono fortemente agli aspetti più moderati del caos.\n\nStimano e proteggono la libertà degli altri come la propria e sono di solito buoni.\n\nI drow sono un\'eccezione: il loro esilio nel Sottosuolo li ha resi maligni e pericolosi.\n\nI drow sono di solito malvagi.\n\n---\n\n**TAGLIA**\n\nGli elfi sono alti tra meno di 150 e più di 180 cm ed hanno corporature snelle.\n\nLa taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 9 metri.\n\n---\n\n**SCUROVISIONE**\n\nAbituati a foreste in penombra ed al cielo notturno, avete una vista superiore in condizioni di buio o luce debole.Abituati a foreste in penombra ed al cielo notturno, avete una vista superiore in condizioni di buio o luce debole.\n\nPossono vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\n\nNon possono discernere i colori nell\'oscurità, solo sfumature di grigio.\n\n---\n\n**SENSI** **ACUTI**\n\nSi ottiene competenza nell\'abilità Percezione.\n\n---\n\n**STIRPE** **FATATA**\n\nSi ha vantaggio nei tiri salvezza contro l\'essere affascinati e la magia non può farvi addormentare.\n\n---\n\n**TRANCE**\n\nGli elfi non hanno bisogno di dormire.\n\nInvece meditano profondamente, rimanendo semi-coscienti, per 4 ore al giorno.\n\nMentre meditano, possono in qualche modo sognare: tali sogni sono in realtà esercizi mentali che sono divenuti riflessivi attraverso anni di pratica.\n\nDopo aver riposato in questo modo, guadagnate lo stesso beneficio che un umano ottiene da 8 ore di sonno.\n\n---\n\n**LINGUAGGI**\n\nPossono parlare, leggere e scrivere in Comune ed Elfico.\n\nL\'Elfico è fluido, con intonazioni delicate e una grammatica intricata.\n\nLa letteratura elfica è ricca e varia e le loro canzoni e i poemi sono famosi tra le altre razze.\n\nMolti bardi imparano il loro linguaggio così da poter aggiungere le ballate in Elfico ai loro repertori.\n\n'),
  dragonide(
      'Dragonide',
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
      false,
      {
        Skill.forza: 2,
        Skill.carisma: 1,
      },
      0,
      0,
      [],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Forza aumenta di 2 e il punteggio di Carisma aumenta di 1.\n\n---\n\n**ETÀ**\n\nI dragonidi giovani crescono velocemente.\n\nCamminano ore dopo la schiusa, raggiungono la taglia e lo sviluppo di un bambino umano di 10 anni all\'età di 3 anni e raggiungono la maturità a 15.\n\nVivono circa fino a 80 anni.\n\n---\n\n**ALLINEAMENTO**\n\nI dragonidi tendono agli estremi, facendo una scelta cosciente per un lato o l\'altro nella guerra cosmica tra bene e male (rappresentati rispettivamente da Bahamut e Tiamat).\n\nMolti dragonidi sono buoni, ma quelli che si schierano con Tiamat possono essere nemici terribili.\n\n---\n\n**TAGLIA**\n\nI dragonidi sono più alti e più pesanti degli umani, essendo alti ben più di 180 cm e pesando circa 115kg.\n\nLa taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 9 metri.\n\n| Sotto razza | Tipo di danno |    Arma a soffio     | Tiro salvezza |\n|:----------:|:-------------:|:--------------------:|:-------------:|\n|   Bianco   |    Freddo     |    Cono di 4,5 m     | Costituzione  |\n|    Blu     |  Elettricità  | Lineare da 1,5 a 9 m |   Destrezza   |\n|   Bronzo   |  Elettricità  | Lineare da 1,5 a 9 m |   Destrezza   |\n|    Nero    |     Acido     | Lineare da 1,5 a 9 m |   Destrezza   |\n|    Oro     |     Fuoco     |    Cono di 4,5 m     |   Destrezza   |\n|   Ottone   |     Fuoco     | Lineare da 1,5 a 9 m |   Destrezza   |\n|    Rame    |     Acido     | Lineare da 1,5 a 9 m |   Destrezza   |\n|   Rosso    |     Fuoco     |    Cono di 4,5 m     |   Destrezza   |\n|   Verde    |    Veleno     |    Cono di 4,5 m     | Costituzione  |\n\nAvete una discendenza draconica.\n\nScegliete un tipo di drago dalla tabella Discendenza Draconica.\n\nL\'arma a soffio e la resistenza al danno sono determinate dal tipo di drago, come mostrato nella tabella.\n\n---\n\n**ARMA** A **SOFFIO**\n\nPotete usare la vostra azione per esalare energia distruttiva.\n\nLa discendenza draconica determina dimensione, forma e tipo di danno dell\'esalazione.\n\nQuando usate l\'arma a soffio, ogni creatura nell\'area dell\'esalazione deve effettuare un tiro salvezza, il cui tipo è determinato dalla vostra discendenza draconica.\n\nLa **CD** per questo tiro salvezza è pari a 8 + modificatore di Costituzione + bonus di competenza.\n\nUna creatura subisce 2d6 danni con un tiro fallito e metà danni con un successo.\n\nIl danno aumenta a 3d6 al 6° livello, 4d6 all\'11° livello e 5d6 al 16° livello.\n\nDopo aver usato la vostra arma a soffio, non potete usarla di nuovo finché non completate un riposo breve o lungo.\n\n---\n\n**RESISTENZE** **AL** **DANNO**\n\nAvete resistenza al tipo di danno associato con la vostra discendenza draconica.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune e Draconico.n\Il Draconico si pensa sia uno dei linguaggi più vecchi ed è spesso usato nello studio della magia.\n\nIl linguaggio suona duro alla maggior parte delle altre creature e include numerose consonanti dure e sibilanti.\n\n'),
  gnomo(
      'Gnomo',
      [
        SubRace.gnomoDelleForeste,
        SubRace.gnomoDelleRocce,
      ],
      [
        Language.comune,
        Language.gnomesco,
      ],
      false,
      {
        Skill.intelligenza: 2,
      },
      0,
      0,
      [],
      7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Intelligenza aumenta di 2.\n\n---\n\n**ETÀ**\n\nGli gnomi maturano alla stessa velocità degli umani e ci si aspetta che molti si accingano alla vita adulta attorno ai 40 anni.\n\nPossono vivere da 350 a quasi 500 anni.\n\n---\n\n**ALLINEAMENTO**\n\nGli gnomi sono più spesso buoni.\n\nQuelli che tendono verso la legge sono saggi, ingegneri, ricercatori, studiosi, investigatori o inventori.\n\nQuelli che tendono verso il caos sono menestrelli, imbroglioni, vagabondi o fantasiosi gioiellieri.\n\nGli gnomi sono di buon cuore e persino gli imbroglioni tra loro sono più scherzosi che maligni.\n\n---\n\n**TAGLIA**\n\nGli gnomi sono alti tra 90 e 120 cm e pesano in media 18 kg.\n\nLa taglia è Piccola.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 7,5 metri.\n\n---\n\n**SCUROVISIONE**\n\nAbituati alla vita sotterranea, avete una vista superiore in condizioni di buio o luce debole.\n\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\n\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.\n\n---\n\n**ASTUZIA** **GNOMESCA**\n\nAvete vantaggio in tutti i tiri salvezza su Intelligenza, Saggezza e Carisma contro la magia.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune e Gnomesco.\n\nIl linguaggio Gnomesco, che usa l\'alfabeto Nanico, è rinomato per i suoi trattati tecnici e i suoi cataloghi di conoscenza sul mondo naturale.\n\n---\n\n**SOTTORAZZA**\n\nSi trovano due sottorazze di gnomi tra i mondi di D&amp;D: gnomi delle foreste e gnomi delle rocce.\n\nScegliete una di queste sottorazze.\n\n'),
  halfling(
      'Halfling',
      [
        SubRace.halflingPiedelesto,
        SubRace.halflingTozzo,
      ],
      [
        Language.comune,
        Language.halfling,
      ],
      false,
      {
        Skill.destrezza: 2,
      },
      0,
      0,
      [],
      7.5,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Destrezza aumenta di 2.\n\n---\n\n**ETÀ**\n\nUn halfling raggiunge la maturità all\'età di 20 anni e generalmente vive fino a metà del suo secondo secolo.\n\n---\n\n**ALLINEAMENTO**\n\nMolti halfling sono legali buoni.\n\nCome regola, sono di buon cuore e gentili, odiano vedere gli altri in pena e non tollerano l\'oppressione.\n\nSono anche molto ordinati e tradizionali e si appoggiano pesantemente al supporto delle loro comunità e al conforto delle loro tradizioni.\n\n---\n\n**TAGLIA**\n\nGli halfling raggiungono circa 90 cm e pesano circa 18 kg.\n\nLa taglia è Piccola.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 7,5 metri.\n\n---\n\n**FORTUNATO**\n\nQuando ottenete un 1 ad un tiro per colpire, prova caratteristica o tiro salvezza, potete ritirare il dado e dovete usare il nuovo risultato.\n\n---\n\n**CORAGGIOSO**\n\nAvete vantaggio nei tiri salvezza contro l\'essere spaventato.\n\nVERSATILITÀ **HALFLING**\n\nPotete muovervi attraverso lo spazio di qualunque creatura che è di una taglia più grande di voi.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune e Halfling.\n\nIl linguaggio Halfling non è segreto, ma gli halfling sono restii a condividerlo con altri.\n\nScrivono molto poco, per cui non hanno una ricca letteratura. Comunque la loro tradizione orale è molto forte.\n\nPraticamente tutti gli halfling parlano il Comune per conversare con la gente delle terre in cui abitano o attraverso cui stanno viaggiando.\n\n---\n\n**SOTTORAZZA**\n\nI due tipi principali di halfling, piedelesto e tozzo, sono più come famiglie strettamente imparentate che vere sottorazze.\n\nScegliete una di queste sottorazze.\n\n'),
  mezzelfo(
      'Mezzelfo',
      [],
      [
        Language.comune,
        Language.elfico,
      ],
      true,
      {},
      2,
      2,
      [],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Carisma aumenta di 2 ed altri due punteggi di caratteristica a vostra scelta aumentano di 1.\n\n---\n\n**ETÀ**\n\nI mezzelfi maturano allo stesso ritmo degli umani e raggiungono la maturità attorno all\'età di 20 anni.\n\nVivono però molto più a lungo degli umani, spesso sforando i 180 anni.\n\n---\n\n**ALLINEAMENTO**\n\nI mezzelfi condividono l\'inclinazione caotica della loro eredità elfica.\n\nValorizzano sia la libertà personale che l\'espressione creativa, non dimostrando né amore per i capi né desiderio di seguaci.\n\nSi irritano per le regole, se la prendono per le richieste altrui ed a volte si dimostrano inaffidabili o almeno imprevedibili.\n\n---\n\n**TAGLIA**\n\nI mezzelfi hanno la stessa taglia degli umani, spaziando da 150 a 180 cm.\n\nLa taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 9 metri.\n\n---\n\n**SCUROVISIONE**\n\nGrazie al sangue elfico, avete una vista superiore in condizioni di buio o luce debole.\n\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\n\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.\n\n---\n\n**STIRPE** **FATATA**\n\nAvete vantaggio nei tiri salvezza contro l\'essere affascinati e la magia non può farvi addormentare.\n\nVERSATILITÀ\n\nGuadagnate competenza in due abilità a vostra scelta.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune, Elfico ed un linguaggio extra a vostra scelta.\n\n'),
  mezzorco(
      'Mezzorco',
      [],
      [Language.comune, Language.orchesco],
      false,
      {
        Skill.forza: 2,
        Skill.costituzione: 1,
      },
      0,
      0,
      [],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Forza aumenta di 2 ed il punteggio di Costituzione aumenta di 1.\n\n---\n\n**ETÀ**\n\nI mezzorchi maturano poco più velocemente degli umani, raggiungendo la maturità a circa 14 anni.\n\nInvecchiano visibilmente prima e raramente vivono oltre i 75.\n\n---\n\n**ALLINEAMENTO**\n\nI mezzorchi ereditano una tendenza verso il caos dai loro genitori orchi e non sono molto inclini al bene.\n\nI mezzorchi cresciuti tra gli orchi e che vogliono vivere tra loro sono di solito malvagi.\n\n---\n\n**TAGLIA**\n\nI mezzorchi sono un po\' più grandi e massicci degli umani e sono alti tra 150 e ben più di 180 cm.\n\nLa taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 9 metri.\n\n---\n\n**SCUROVISIONE**\n\nGrazie al sangue orchesco, avete una vista superiore in condizioni di buio o luce debole.\n\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\n\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.\n\n---\n\n**MINACCIOSO**\n\nGuadagnate competenza nell\'abilità Intimidire.\n\n---\n\n**RESISTENZA** **INESORABILE**\n\nQuando siete ridotti a 0 punti ferita ma non uccisi sul colpo, potete invece tornare ad 1 punto ferita.\n\nNon potete usare questo privilegio nuovamente finché non completate un riposo lungo.\n\n---\n\n**ATTACCHI** **SELVAGGI**\n\nQuando ottenete un colpo critico con un attacco con arma da mischia, potete tirare uno dei dadi del danno da arma una volta in più e aggiungerlo al danno extra del colpo critico.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune ed Orchesco.\n\nL\'Orchesco è un linguaggio duro e stridente con consonanti dure.\n\nNon ha un suo alfabeto ma viene scritto con l\'alfabeto Nanico.\n\n'),
  tiefling(
      'Tiefling',
      [],
      [
        Language.comune,
        Language.infernale,
      ],
      false,
      {
        Skill.intelligenza: 1,
        Skill.carisma: 2,
      },
      0,
      0,
      [],
      9,
      '**INCREMENTO** **DEI** **PUNTEGGI** **CARATTERISTICA**\n\nIl punteggio di Intelligenza aumenta di 1 e il punteggio di Carisma aumenta di 2.\n\n---\n\n**ETÀ**\n\nI tiefling maturano allo stesso ritmo degli umani ma vivono qualche anno più a lungo.\n\n---\n\n**ALLINEAMENTO**\n\nI tiefling possono non avere una tendenza innata verso il male, ma molti di loro finiscono lì.\n\nMalvagi o no, una natura indipendente fa propendere molti tiefling verso un allineamento caotico.\n\n---\n\n**TAGLIA**\n\nI tiefling hanno circa la stessa taglia e corporatura degli umani.\n\nLa taglia è Media.\n\n---\n\n**VELOCITÀ**\n\nLa velocità base sul terreno è 9 metri.\n\n---\n\n**SCUROVISIONE**\n\nGrazie all\'eredità infernale, avete una vista superiore in condizioni di buio o luce debole.\n\nPotete vedere con luce debole entro 18 metri come se fosse luce intensa e nell\'oscurità come fosse luce debole.\n\nNon potete discernere i colori nell\'oscurità, solo sfumature di grigio.\n\n---\n\n**RESISTENZA** **DIABOLICA**\n\nAvete resistenza al danno da fuoco.\n\n---\n\n**RETAGGIO** **INFERNALE**\n\nConoscete il trucco taumaturgia.\n\nUna volta raggiunto il 3° livello, potete lanciare l\'incantesimo rimprovero diabolico una volta al giorno come incantesimo di 2° livello.\n\nUna volta raggiunto il 5° livello, potete anche lanciare l\'incantesimo oscurità una volta al giorno.\n\nIl Carisma è la caratteristica chiave per questi incantesimi.\n\n---\n\n**LINGUAGGI**\n\nPotete parlare, leggere e scrivere in Comune ed Infernale.');

  @override
  final String title, description;
  final List<SubRace> subRaces;
  final List<Language> defaultLanguages;
  final bool canChoiceLanguage;
  final Map<Skill, int> defaultSkills;
  final int numChoiceableSkills, numChoiceableSubSkills; // solo mezzelfo
  // final List<Mastery> defaultMasteries **QUI** **NO**! (**VERIFICATO**)
  final double defaultSpeed;
  final List<Mastery> choiceableMasteries; // ce l'ha il nano

  const Race(
      this.title,
      this.subRaces,
      this.defaultLanguages,
      this.canChoiceLanguage,
      this.defaultSkills,
      this.numChoiceableSkills,
      this.numChoiceableSubSkills,
      this.choiceableMasteries,
      this.defaultSpeed,
      this.description);

  String get subRacesInfo => subRaces.isEmpty
      ? 'Nessuna sottorazza'
      : subRaces.map((e) => e.title).join(', ');
}

enum Skill implements EnumWithTitle {
  forza('Forza', 'png/strength', Color(0xFFe5737c), [SubSkill.atletica],
      'La Forza misura la potenza del proprio corpo, l\'addestramento fisico e l\'efficaciacon cui un personaggio è in grado di esercitare la propria potenza fisica.\nUna prova di forza può rappresentareogni tentativo di sollevare, spingere, tirareo spezzare qualcosa,di farsi strada atraverso uno spazio, o di applicare in altri modi la forza bruta a una situazione.\nL\'abilità atletica rappresenta una maggiore prestanza in certi tipi di prove di forza.'),
  destrezza(
      'Destrezza',
      'png/dexterity',
      Color(0xFFe5ac73),
      [
        SubSkill.acrobazia,
        SubSkill.furtivita,
        SubSkill.rapiditaDiMano,
      ],
      'La Destrezza misura l\'agilità, i riflessi e l\'equilibrio.\nUna prova di destrezza può rappresentar ogni tentativo di muoversi agilmente, rapidamente o silenziosamente, o di evitare di cadere quando ci si muove su una superficie precaria.\nLe abilità acrobazia, furtività e rapidità di mano rappresentano una maggiore bravura in certi tipi di prove di destrezza.'),
  costituzione('Costituzione', 'png/costitution', Color(0xFFe5e573), [],
      'La Costituzione misura la salute, la resistenza fisica e l\'energia vitale del personaggio.\nLe prove di costituzione sono rare: nessuna abilità viene applicata alle prove di costituzione, in quanto la resistenza fisica rappresenta da questa caratteristica è principalmente una dote passiva e non richiede uno sforzo specifico da parte di un personaggio o di un mostro.\nUna prova di costituzione può tuttavia rappresentare il tentativo di un personaggio di spingersi oltre i propri limiti.'),
  intelligenza(
      'Intelligenza',
      'png/intelligence',
      Color(0xFF6cd9a2),
      [
        SubSkill.arcano,
        SubSkill.storia,
        SubSkill.indagare,
        SubSkill.natura,
        SubSkill.religione,
      ],
      'L\'Intelligenza misura l\'acume mentale, la precisione della memoria e le capacità logiche.\nUna prova di Intelligenza entra in gioco quando un personaggio ricorre alla logica, all\'istruzione, alla memoria o al ragionamento deduttivo.\nLe abilità arcano, indagare, natura, religione e storia rappresentano una preparazione superiore in certi tipi di prove di intelligenza.'),
  saggezza(
      'Saggezza',
      'png/wisdom',
      Color(0xFF7979f2),
      [
        SubSkill.addestrareAnimali,
        SubSkill.intuizione,
        SubSkill.medicina,
        SubSkill.percezione,
        SubSkill.sopravvivenza,
      ],
      'La Saggezza rappresenta la percezione, l\'intuizione e il grado di sintonia del personaggio con il mondo circostante.\nUna prova di saggezza rappresenta un tentativo di interpretare il linguaggio corporeo o le emozioni di qualcuno, notare qualcosa nell\'ambiente o prendersi cura di una persona ferita.\nLe abilità addestrare animali, intuizione, medicina, percezione e sopravvivenza rappresentano una maggiore sensibilità in certi tipi di prove di saggezza.'),
  carisma(
      'Carisma',
      'png/carisma',
      Color(0xFFd273e5),
      [
        SubSkill.inganno,
        SubSkill.intimidire,
        SubSkill.intrattenere,
        SubSkill.persuasione,
      ],
      'Il Carisma misura la capacità del personaggio di interagire con successo con gli altri.\nInclude fattori come la sua sicurezza e la sua eloquenza e può rappresentare una personalità accattivante o imperiosa.\nUn personaggio può effettuare una prova di carisma quando cerca di influenzare o di intrattenere gli altri, quando tenta di impressionare qualcuno o di raccontare una bugia convincente, o quando deve destreggiarsi in una situazione sociale spinosa.\nLe abilità Inganno, Intimidire, Intrattenere e Persuasione rappresentano una maggiore disinvoltura in certi tipi di prove di Carisma.');

  @override
  final String title;
  final String iconPath, description;
  final List<SubSkill> subSkills;
  final Color color;

  const Skill(
      this.title, this.iconPath, this.color, this.subSkills, this.description);
}

enum SubSkill implements EnumWithTitle {
  // Forza
  atletica('Atletica'),
  // Destrezza
  acrobazia('Acrobazia'),
  furtivita('Furtività'),
  rapiditaDiMano('Rapidità di mano'),
  // Intelligenza
  arcano('Arcano'),
  storia('Storia'),
  indagare('Indagare'),
  natura('Natura'),
  religione('Religione'),
  // Saggezza
  addestrareAnimali('Addestrare Animali'),
  intuizione('Intuizione'),
  medicina('Medicina'),
  percezione('Percezione'),
  sopravvivenza('Sopravvivenza'),
  // Carisma
  inganno('Inganno'),
  intimidire('Intimidire'),
  intrattenere('Intrattenere'),
  persuasione('Persuasione');

  @override
  final String title;

  const SubSkill(this.title);
}

enum MasteryType {
  strumentiMusicali([
    Mastery.ciaramella,
    Mastery.cornamusa,
    Mastery.corno,
    Mastery.dulcimer,
    Mastery.flauto,
    Mastery.flautoDiPan,
    Mastery.lira,
    Mastery.liuto,
    Mastery.tamburo,
    Mastery.viola,
  ]),
  strumentiArtigiano([
    Mastery.scorteDaAlchimista,
    Mastery.scorteDaCalligrafo,
    Mastery.scorteDaMescitore,
    Mastery.strumentiDaCalzolaio,
    Mastery.strumentiDaCartografo,
    Mastery.strumentiDaConciatore,
    Mastery.strumentiDaFabbro,
    Mastery.strumentiDaFalegname,
    Mastery.strumentiDaGioielliere,
    Mastery.strumentiDaIntagliatore,
    Mastery.strumentiDaInventore,
    Mastery.strumentiDaPittore,
    Mastery.strumentiDaSoffiatore,
    Mastery.strumentiDaTessitore,
    Mastery.strumentiDaVasaio,
    Mastery.utensiliDaCuoco,
  ]),
  nonSceglibili([]);

  final List<Mastery> masteries;

  const MasteryType(this.masteries);
}

enum Mastery implements EnumWithTitle {
  // strumentiMusicali
  ciaramella('Ciaramella'),
  cornamusa('Cornamusa'),
  corno('Corno'),
  dulcimer('Dulcimer'),
  flauto('Flauto'),
  flautoDiPan('Flauto di Pan'),
  lira('Lira'),
  liuto('Liuto'),
  tamburo('Tamburo'),
  viola('Viola'),

  // strumentiArtigiano
  scorteDaAlchimista('Scorte da alchimista'),
  scorteDaCalligrafo('Scorte da calligrafo'),
  scorteDaMescitore('Scorte da mescitore'),
  strumentiDaCalzolaio('Strumenti da calzolaio'),
  strumentiDaCartografo('Strumenti da cartografo'),
  strumentiDaConciatore('Strumenti da conciatore'),
  strumentiDaFabbro('Strumenti da fabbro'),
  strumentiDaCostruttore('Strumenti da costruttore'),
  strumentiDaFalegname('Strumenti da falegname'),
  strumentiDaGioielliere('Strumenti da gioielliere'),
  strumentiDaIntagliatore('Strumenti da intagliatore'),
  strumentiDaInventore('Strumenti da inventore'),
  strumentiDaPittore('Strumenti da pittore'),
  strumentiDaSoffiatore('Strumenti da soffiatore'),
  strumentiDaTessitore('Strumenti da tessitore'),
  strumentiDaVasaio('Strumenti da vasaio'),
  utensiliDaCuoco('Utensili da cuoco'),

  // Not choiceable
  spadeCorte('Spade Corte'),
  spadeLunghe('Spade Lunghe'),
  archiCorti('Archi Corti'),
  archiLunghi('Archi Lunghi'),
  ascieDaBattaglia('Ascie da Battaglia'),
  martelliDaGuerra('Martelli da Guerra'),
  martelliLeggeri('Martelli Leggeri'),
  armatureLeggere('Armature Leggere'),
  armatureMedie('Armature Medie'),
  scudi('Scudi'),
  armiSemplici('Armi Semplici'),
  armiDaGuerra('Armi da Guerra'),
  balestreAMano('Balestre a Mano'),
  balestreLeggere('Balestre Leggere'),
  stocchi('Stocchi'),
  arnesiDaScasso('Arnesi da Scasso'),
  ascie('Ascie'),
  tutteLeArmature('Tutte le Armature'),
  bastoniFerrati('Bastoni Ferrati'),
  dardi('Dardi'),
  fionde('Fionde'),
  pugnali('Pugnali'),
  falcetti('Falcetti'),
  giavellotti('Giavellotti'),
  lance('Lance'),
  mazze('Mazze'),
  randelli('Randelli'),
  scimitarre('Scimitarre'),
  strumentiDaErborista('Strumenti da Erborista');

  @override
  final String title;

  const Mastery(this.title);
}

enum Language implements EnumWithTitle {
  gigante('Gigante'),
  gnomesco('Gnomesco'),
  goblin('Goblin'),
  halfling('Halfling'),
  nanico('Nanico'),
  orchesco('Orchesco'),
  abissale('Abissale'),
  celestiale('Celestiale'),
  draconico('Draconico'),
  gergoDelleProfondita('Gergo delle profondità'),
  infernale('Infernale'),
  primordiale('Primordiale'),
  silvano('Silvano'),
  sottocomune('Sottocomune'),
  elfico('Elfico'),
  comune('Comune');

  @override
  final String title;

  const Language(this.title);
}

enum Status {
  accecato('Accecato'),
  affascinato('Affascinato'),
  afferrato('Afferrato'),
  assordato('Assordato'),
  avvelenato('Avvelenato'),
  incapacitato('Incapacitato'),
  invisibile('Invisibile'),
  paralizzato('Paralizzato'),
  pietrificato('Pietrificato'),
  privo('Privo'),
  prono('Prono'),
  spaventato('Spaventato'),
  stordito('Stordito'),
  trattenuto('Trattenuto');

  final String title;

  const Status(this.title);
}

enum Alignment implements EnumWithTitle {
  legaleBuono('Legale buono', 'LB',
      'Creature su cui si può contare facciano la cosa corretta da fare secondo la società civile. Draghi d’oro, paladini e la maggior parte dei nani sono legali buoni.'),
  neutraleBuono('Neutrale buono', 'NB',
      'Creature che cercano di fare del loro meglio per aiutare il prossimo nelle sue necessità. Molti celestiali, alcuni giganti delle nuvole e la maggior parte degli gnomi sono neutrali buoni.'),
  caoticoBuono('Caotico buono', 'CB',
      'Creature che agiscono secondo la propria coscienza, con poca considerazione delle aspettative altrui. Draghi di rame, molti elfi e gli unicorni sono caotici buoni'),
  legaleNeutrale('Legale neutrale', 'LN',
      'Individui che agiscono secondo leggi, tradizioni o codici personali. Molti monaci e alcuni maghi sono legali neutrali.\n\nNeutrale (N) è l’allineamento di coloro che preferiscono evitare le questioni morali e non schierarsi, facendo quella che sembra la cosa migliore da fare in quel momento. I lucertoloidi, la maggior parte dei druidi e molti umani sono neutrali.'),
  neutralePuro('Neutrale puro', 'NN',
      'Un personaggio neutrale fa sempre ciò che gli sembra essere una buona idea. Quando si tratta del male e del bene, della legge e del caos non ha particolari tendenze dall’una o dall’altra parte.'),
  caoticoNeutrale('Caotico neutrale', 'CN',
      'Creature che seguono il proprio istinto, e che considerano la libertà personale al di sopra di tutto. Molti barbari e ladri, e alcuni bardi, sono caotici neutrali.'),
  legaleMalvagio('Legale malvagio', 'LM',
      'Creature che metodicamente prendono ciò che vogliono entro i limiti di un codice di tradizioni, della lealtà o dell’ordine. Diavoli, draghi blu e hobgoblin sono legali malvagi.'),
  neutraleMalvagio('Neutrale malvagio', 'NM',
      'E’ l’allineamento di coloro che agiscono in qualsiasi modo ritengano più opportuno, senza compassione o scrupoli. Molti elfi oscuri, alcuni giganti delle nuvole e i goblin sono neutrali malvagi.'),
  caoticoMalvagio('Caotico malvagio', 'CM',
      'Creature che agiscono in base ad un’arbitraria violenza, alimentata da avidità, odio o sete di sangue. Demoni, draghi rossi e orchi sono caotici malvagi.'),
  nessuno('Nessun allineamento', null,
      'La maggior parte delle creature prive di pensiero razionale non hanno allineamenti: sono senza allineamento. Una creatura del genere è incapace di effettuare scelte etiche o morali e agisce secondo la sua natura bestiale. Per dire, gli squali sono selvaggi predatori, ma non sono malvagi; non hanno alcun allineamento.');

  @override
  final String title;
  final String description;
  final String? initials;

  const Alignment(this.title, this.initials, this.description);

  static const _initials = {
    'L': 'Legale',
    'N': 'Neutrale',
    'C': 'Caotico',
    'B': 'Buono',
    'M': 'Malvagio'
  };

  List<String> get fullInitials => switch (this) {
        Alignment.nessuno => ['Nessuno'],
        Alignment.neutralePuro => ['Neutrale', 'Puro'],
        _ => initials!.split('').map((e) => _initials[e]!).toList(),
      };
}

@JsonSerializable(constructor: 'jsonConstructor')
class Character with Comparable<Character> implements JSONSerializable, WithUID {
  int regDateTimestamp;
  String? campaignUID;
  String authorUID;
  @JsonKey(includeFromJson: true, includeToJson: true)
  String _name;
  Class class_;
  SubClass subClass;
  Race race;
  SubRace? subRace;
  @JsonKey(includeFromJson: true, includeToJson: true)
  Map<Skill, int> _chosenSkills = {};
  Map<Skill, int> rollSkills = {};
  Map<SubSkill, int> subSkills = {};
  Set<Mastery> masteries = {};
  Set<Language> languages = {};
  Set<Skill> savingThrows = {};
  Status? status;
  Alignment alignment;
  int level;
  @JsonKey(includeFromJson: true, includeToJson: true)
  Map<String, int> _inventory = {};

  String get name => _name;

  set name(String value) {
    if (value.length < 3) {
      throw const FormatException('Il nome deve avere almeno 3 caratteri');
    }
    _name = value;
  }

  Map<Skill, int> get chosenSkills => _chosenSkills;

  set chosenSkills(Map<Skill, int> value) {
    _chosenSkills =
        value.map((key, value) => MapEntry(key, max(3, min(18, value))));
  }

  Character.jsonConstructor(
      this.regDateTimestamp,
      this.campaignUID,
      this.authorUID,
      this._name,
      this._inventory,
      this.class_,
      this.subClass,
      this.race,
      this.subRace,
      Map<Skill, int>? _chosenSkills,
      Map<Skill, int>? rollSkills,
      Map<SubSkill, int>? subSkills,
      Set<Mastery>? masteries,
      Set<Language>? languages,
      Set<Skill>? savingThrows,
      this.status,
      this.alignment,
      this.level)
      : _chosenSkills = _chosenSkills ?? {},
        rollSkills = rollSkills ?? {},
        subSkills = subSkills ?? {},
        masteries = masteries ?? {},
        languages = languages ?? {},
        savingThrows = savingThrows ?? {} {
    for (var qta in _inventory.values) {
      assert(qta > 0);
    }
  }

  Character()
      : _name = '',
        authorUID = AccountManager().user.uid!,
        level = 0,
        subClass = Class.barbaro.subClasses[0],
        regDateTimestamp = DateTime.now().millisecondsSinceEpoch,
        class_ = Class.barbaro,
        race = Race.umano,
        alignment = Alignment.nessuno;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String? uid;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<InventoryItem, int> get inventory => _inventory
      .map((key, value) => MapEntry(InventoryItem.fromName(key), value));

  set inventory(Map<InventoryItem, int> value) =>
      _inventory = value.map((key, value) => MapEntry(key.toString(), value));

  DateTime get dateReg => DateTime.fromMillisecondsSinceEpoch(regDateTimestamp);

  double get defaultSpeed => subRace?.defaultSpeed ?? race.defaultSpeed;

  Map<Skill, int> get skills =>
      rollSkills +
      _chosenSkills +
      race.defaultSkills +
      (subRace?.defaultSkills ?? {});

  Map<Skill, int> get skillsModifier =>
      skills.map((skill, value) => MapEntry(skill, (value - 10) ~/ 2));

  addLoot(Loot loot) {
    loot.content.forEach((item, qta) {
      inventory += {item: qta};
    });
  }

  @override
  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  @override
  Map<String, dynamic> toJSON() => _$CharacterToJson(this);

  @override
  String toString() {
    return json.encode(toJSON());
  }

  @override
  // Compare first by level then by name
  int compareTo(Character other) =>
      level.compareTo(other.level) == 0
          ? name.compareTo(other.name)
          : level.compareTo(other.level);
}
