import 'package:scheda_dnd_5e/model/loot.dart';
import 'package:scheda_dnd_5e/model/setting.dart';

import '../database_seeder.dart';

class SettingSeeder extends Seeder<SettingMenu> {
  @override
  List<SettingMenu> get seeds => [
    SettingMenu('png/background_off', 'Setting Menu',
        subtitle: 'Questo è un setting menu di prova', settings: [Setting.test, Setting.test]),
    SettingMenu('png/background_off', 'Setting Menu',
        subtitle: 'Questo è un setting menu di prova', settings: [Setting.test, Setting.test]),
    SettingMenu('png/background_off', 'Setting Menu',
        subtitle: 'Questo è un setting menu di prova', settings: [Setting.test, Setting.test]),
  ];
}
