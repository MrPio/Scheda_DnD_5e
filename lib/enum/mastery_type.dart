import '../annotation/localized_annotation.dart';
import '../interface/enum_with_title.dart';
import 'mastery.dart';

@Localized(['title'])
enum MasteryType implements EnumWithTitle {
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
  ], 'png/music'),
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
  ], 'png/artisan'),
  armiEArmature([
    Mastery.spadeCorte,
    Mastery.spadeLunghe,
    Mastery.archiCorti,
    Mastery.archiLunghi,
    Mastery.ascieDaBattaglia,
    Mastery.martelliDaGuerra,
    Mastery.martelliLeggeri,
    Mastery.armatureLeggere,
    Mastery.armatureMedie,
    Mastery.scudi,
    Mastery.armiSemplici,
    Mastery.armiDaGuerra,
    Mastery.balestreAMano,
    Mastery.balestreLeggere,
    Mastery.stocchi,
    Mastery.arnesiDaScasso,
    Mastery.ascie,
    Mastery.tutteLeArmature,
    Mastery.bastoniFerrati,
    Mastery.dardi,
    Mastery.fionde,
    Mastery.pugnali,
    Mastery.falcetti,
    Mastery.giavellotti,
    Mastery.lance,
    Mastery.mazze,
    Mastery.randelli,
    Mastery.scimitarre,
    Mastery.strumentiDaErborista,
  ], 'png/other_tools');

  final List<Mastery> masteries;
  final String iconPath;

  const MasteryType(this.masteries, this.iconPath);
}
