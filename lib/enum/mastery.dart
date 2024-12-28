import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';
import 'mastery_type.dart';

@Localized(['title'])
enum Mastery implements EnumWithTitle {
  // strumentiMusicali
  ciaramella,
  cornamusa,
  corno,
  dulcimer,
  flauto,
  flautoDiPan,
  lira,
  liuto,
  tamburo,
  viola,

  // strumentiArtigiano
  scorteDaAlchimista,
  scorteDaCalligrafo,
  scorteDaMescitore,
  strumentiDaCalzolaio,
  strumentiDaCartografo,
  strumentiDaConciatore,
  strumentiDaFabbro,
  strumentiDaCostruttore,
  strumentiDaFalegname,
  strumentiDaGioielliere,
  strumentiDaIntagliatore,
  strumentiDaInventore,
  strumentiDaPittore,
  strumentiDaSoffiatore,
  strumentiDaTessitore,
  strumentiDaVasaio,
  utensiliDaCuoco,

  // Not choiceable
  spadeCorte,
  spadeLunghe,
  archiCorti,
  archiLunghi,
  ascieDaBattaglia,
  martelliDaGuerra,
  martelliLeggeri,
  armatureLeggere,
  armatureMedie,
  scudi,
  armiSemplici,
  armiDaGuerra,
  balestreAMano,
  balestreLeggere,
  stocchi,
  arnesiDaScasso,
  ascie,
  tutteLeArmature,
  bastoniFerrati,
  dardi,
  fionde,
  pugnali,
  falcetti,
  giavellotti,
  lance,
  mazze,
  randelli,
  scimitarre,
  strumentiDaErborista;

  MasteryType get masteryType => MasteryType.values
      .firstWhere((e) => e.masteries.contains(this), orElse: () => MasteryType.armiEArmature);
}
