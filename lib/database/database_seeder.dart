import '../manager/data_manager.dart';
import '../manager/database_manager.dart';

abstract class Seeder<T> {
  List<T> get seeds;

  Function() get deleteCollection => DatabaseManager().deleteCollection<T>();
}

List<Seeder> seeders = [];

/// Seed the database. Clear existing instances if [fresh].
seedDatabase({bool fresh = true}) async {
  for (Seeder seeder in seeders) {
    if (fresh) {
      await seeder.deleteCollection();
    }
    var seeds = seeder.seeds;
    for (var seed in seeds) {
      await DataManager().save(seed);
    }
  }
}
