import 'package:scheda_dnd_5e/database/seeders/inventory_items_seeder.dart';

import '../interface/with_uid.dart';
import '../manager/data_manager.dart';
import '../manager/database_manager.dart';

abstract class Seeder<T> {
  List<T> get seeds;

  get deleteCollection => DatabaseManager().deleteCollection<T>;
}

List<Seeder> seeders = [
  WeaponSeeder(),
  ArmorSeeder(),
  ItemSeeder(),
  CoinSeeder(),
  EquipmentSeeder(),
];

/// Seed the database. Clear existing instances if [fresh].
seedDatabase({bool fresh = true}) async {
  for (Seeder seeder in seeders) {
    print('⬆️ I\'ve seeded the ${seeder.seeds[0].runtimeType}s');

    if (fresh) await seeder.deleteCollection();
    var seeds = seeder.seeds;
    for (var seed in seeds) {
      await DataManager().save(seed as WithUID);
    }
  }
}
