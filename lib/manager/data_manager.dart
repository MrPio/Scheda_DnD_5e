import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:scheda_dnd_5e/extension/function/int_extensions.dart';
import 'package:scheda_dnd_5e/interface/identifiable.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/user.dart';

import '../model/campaign.dart';

enum SaveMode { post, put }

class DataManager {
  static final DataManager _instance = DataManager._();

  factory DataManager() => _instance;

  DataManager._();

  static const pageSize = 100;

  final anonymous = User();
  List<User> cachedUsers = [];
  late final List<Enchantment> enchantments;

  fetchData() async {
    // Loading enchantments ============================================
    // Check if I have already downloaded the enchantments before 7 days ago
    final enchantmentsTimestamp =
        await IOManager().get<int>('enchantments_timestamp') ?? 0;
    if (enchantmentsTimestamp.elapsedTime().inDays >= 7) {
      print('Scarico gli enchantments');
      enchantments = await DatabaseManager()
              .getList<Enchantment>('enchantments', pageSize: 9999) ??
          [];
      IOManager().serializeObjects('enchantments', enchantments);
    } else {
      print('Leggo localmente gli enchantments');
      enchantments =
          await IOManager().deserializeObjects<Enchantment>('enchantments');
    }
  }

  // Load a single User object from a given uid
  Future<User> loadUser(String? uid, {bool force = false}) async {
    if (!force) {
      // Is anonymous?
      if (uid == null) {
        return anonymous;
      }

      // Already cached?
      User? cachedUser =
          cachedUsers.firstWhereOrNull((user) => user.uid == uid);
      if (cachedUser != null) return cachedUser;

      // Is current User?
      if (AccountManager().user.uid == uid) return AccountManager().user;
    }

    // Ask the database for the user and caching it
    User? user = User.fromJson(await DatabaseManager().get("users/$uid"));
    user.uid = uid;
    // loadUserPosts(user);
    cachedUsers.add(user);
    return user;
  }

  // Save Model objects
  save(Object model, [SaveMode mode = SaveMode.put]) async {
    String path = {
          User: 'users/',
          Campaign: 'campaigns/',
          Character: 'characters/',
          Enchantment: 'enchantments/',
        }[model.runtimeType] ??
        '';
    if (mode == SaveMode.put) {
      if (model is Identifiable) {
        path += model.uid ?? '';
      } else if (model is Enchantment) {
        path += model.name.replaceAll('/', ' ');
      }
    }

    // Query the FirebaseRD
    if (model is JSONSerializable) {
      if (mode == SaveMode.put) {
        DatabaseManager().put(path, model.toJSON());
      } else {
        String? uid = await DatabaseManager().post(path, model.toJSON());
        if (uid != null) {
          // Any operations to be performed with the retrieved uid
        }
      }
    }
  }
}
