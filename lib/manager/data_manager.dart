import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/interface/json_serializable.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/user.dart';
import 'dart:core' as core show Type;
import 'dart:core' hide Type;
import '../model/campaign.dart';

enum SaveMode { post, put }

class DataManager {
  static final DataManager _instance = DataManager._();

  factory DataManager() => _instance;

  DataManager._();

  static const pageSize = 100;

  final anonymous = User();
  List<User> cachedUsers = [];
  List<Character> cachedCharacters = [];
  List<Character> cachedCampaigns = [];
  ValueNotifier<List<Enchantment>?> enchantments = ValueNotifier(null);

  Map<core.Type, List<WithUID>> get caches => {
        User: cachedUsers,
        Campaign: cachedCampaigns,
        Character: cachedCharacters,
      };
  Map<core.Type, Function()> get cachesDeserializer => {
    User: ()=>IOManager().deserializeObjects<User>(DatabaseManager.collections[User]!),
    Campaign: ()=>IOManager().deserializeObjects<Campaign>(DatabaseManager.collections[Campaign]!),
    Character: ()=>IOManager().deserializeObjects<Character>(DatabaseManager.collections[Character]!),
  };

  /// This should be called after obtaining the auth
  fetchData() async {
    print('========================================');
    // Loading enchantments ============================================
    // Check if I have already downloaded the enchantments before 7 days ago
    final enchantmentsTimestamp =
        await IOManager().get<int>('enchantments_timestamp') ?? 0;
    if (enchantmentsTimestamp.elapsedTime().inDays >= 7) {
      print('⬇️ Scarico gli enchantments');
      enchantments.value = await DatabaseManager().getList<Enchantment>(
              DatabaseManager.collections[Enchantment]!,
              pageSize: 9999) ??
          [];
      IOManager().serializeObjects(
          DatabaseManager.collections[Enchantment]!, enchantments.value!);
    } else {
      enchantments.value = await IOManager().deserializeObjects<Enchantment>(
          DatabaseManager.collections[Enchantment]!);
      print('📘 Ho letto localmente ${enchantments.value!.length} Enchantments');
    }
    for (var cache in caches.entries) {
      final path = DatabaseManager.collections[cache.key]!.replaceAll('/', '');
      if ((await IOManager().get<int>('${path}_timestamp') ?? 0)
              .elapsedTime()
              .inMinutes <
          10) {
        caches[cache.key]!.clear();
        caches[cache.key]!.addAll(await cachesDeserializer[cache.key]!());
        print('📘 Ho letto localmente ${caches[cache.key]!.length} ${cache.key}s');
      }else{
        await IOManager().remove(path);
        await IOManager().remove('${path}_timestamp');
        print('❗ Cache invalidata per ${cache.key}');
      }
    }
    print('========================================');
  }

  /// Load a single object from a given UID
  Future<T> load<T extends WithUID>(String uid, {bool useCache = true}) async {
    if (useCache) {
      if (T.runtimeType == User) {
        // Is current User?
        if (AccountManager().user.uid == uid) return AccountManager().user as T;
      }
      WithUID? obj = caches[T]?.firstWhereOrNull((e) => e.uid == uid);
      if (obj != null) return obj as T;
    }

    // Ask the database for the object and caching it
    T obj =
        await DatabaseManager().get<T>(DatabaseManager.collections[T]!, uid);
    caches[T]?.removeWhere((e) => e.uid == uid);
    caches[T]?.add(obj);
    // Write cache to disk
    await IOManager().serializeObjects(DatabaseManager.collections[T]!, caches[T]!);
    print('📙 Ho scritto su disco ${caches[T]!.length} ${T}s');
    return obj;
  }

  /// Load a multiple objects from a given list of UIDs
  Future<List<T>> loadList<T extends WithUID>(List<String> uids,
      {bool useCache = true}) async {
    List<T> objects = [];
    if (useCache) {
      for (var uid in uids) {
        if (T.runtimeType == User) {
          // Is current User?
          if (AccountManager().user.uid == uid) {
            objects.add(AccountManager().user as T);
            uids.removeWhere((e) => e == uid);
          }
        }
        WithUID? obj = caches[T]?.firstWhereOrNull((e) => e.uid == uid);
        if (obj != null) {
          objects.add(obj as T);
        }
      }
      uids.removeWhere((e) => objects.map((e1) => e1.uid).contains(e));
    }

    // Ask the database for the objects and caching it
    if (uids.isNotEmpty) {
      objects.addAll(await DatabaseManager()
              .getListFromUIDs<T>(DatabaseManager.collections[T]!, uids) ??
          []);
      caches[T]?.removeWhere((e) => uids.contains(e.uid));
      caches[T]?.addAll(objects);
      // Write cache to disk
      await IOManager().serializeObjects(DatabaseManager.collections[T]!, caches[T]!);
      print('📙 Ho scritto su disco ${caches[T]!.length} ${T}s');
    }
    return objects;
  }

  /// Load the characters of a given user
  loadUserCharacters(User user) async =>
      user.characters.value = await loadList(user.charactersUIDs);

  /// Save Model objects
  Future<String?> save(JSONSerializable model,
      [SaveMode mode = SaveMode.put]) async {
    String path = DatabaseManager.collections[model.runtimeType] ?? '';
    if (mode == SaveMode.put) {
      if (model is WithUID) {
        path += (model).uid ?? '';
      } else if (model is Enchantment) {
        path += model.name.replaceAll('/', ' ');
      }
    }

    String? newUID;
    // Query the FirebaseRD
    if (mode == SaveMode.put) {
      DatabaseManager().put(path, model.toJSON());
    } else {
      if (model is WithUID) {
        caches[model.runtimeType]?.add(model);
      }
      newUID= await DatabaseManager().post(path, model.toJSON());
    }
    if (model is WithUID && mode == SaveMode.put) {
      await IOManager().serializeObjects(DatabaseManager.collections[model.runtimeType]!, caches[model.runtimeType]!);
      print('📙 Ho scritto su disco ${caches[model.runtimeType]!.length} ${model.runtimeType}s');
    }
    return newUID;
  }
}
