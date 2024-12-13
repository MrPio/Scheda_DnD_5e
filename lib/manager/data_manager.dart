import 'dart:core' as core show Type;
import 'dart:core' hide Type;

import 'package:collection/collection.dart';
import 'package:scheda_dnd_5e/extension_function/int_extensions.dart';
import 'package:scheda_dnd_5e/extension_function/map_extensions.dart';
import 'package:scheda_dnd_5e/interface/with_uid.dart';
import 'package:scheda_dnd_5e/manager/account_manager.dart';
import 'package:scheda_dnd_5e/manager/database_manager.dart';
import 'package:scheda_dnd_5e/manager/io_manager.dart';
import 'package:scheda_dnd_5e/model/character.dart';
import 'package:scheda_dnd_5e/model/enchantment.dart';
import 'package:scheda_dnd_5e/model/loot.dart';
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
  List<Character> cachedCharacters = [];
  List<Campaign> cachedCampaigns = [];
  List<Weapon> cachedWeapons = [];
  List<Armor> cachedArmors = [];
  List<Item> cachedItems = [];
  List<Coin> cachedCoins = [];
  List<Equipment> cachedEquipments = [];
  List<Enchantment> cachedEnchantments = [];

  List<InventoryItem> get cachedInventoryItems =>
      (cachedWeapons.cast<InventoryItem>()) +
      (cachedArmors.cast<InventoryItem>()) +
      (cachedItems.cast<InventoryItem>()) +
      (cachedCoins.cast<InventoryItem>()) +
      (cachedEquipments.cast<InventoryItem>());

  List<InventoryItem> get appInventoryItems => cachedInventoryItems
      .where((item) => item.regDateTimestamp == null && item.authorUID == null)
      .toList();

  Map<core.Type, List<WithUID>> get caches => {
        User: cachedUsers,
        Campaign: cachedCampaigns,
        Character: cachedCharacters,
        Enchantment: cachedEnchantments,
        Weapon: cachedWeapons,
        Armor: cachedArmors,
        Item: cachedItems,
        Coin: cachedCoins,
        Equipment: cachedEquipments,
      };

  Map<core.Type, int> get cachesTTL => {
        User: 30 * 60,
        Campaign: 30 * 60,
        Character: 30 * 60,
        Enchantment: 7 * 24 * 60 * 60,
        Weapon: 7 * 24 * 60 * 60,
        Armor: 7 * 24 * 60 * 60,
        Item: 7 * 24 * 60 * 60,
        Coin: 7 * 24 * 60 * 60,
        Equipment: 7 * 24 * 60 * 60,
      };

  /// The functions used to deserialize cache from disk
  Map<core.Type, Function()> get cacheDeserializers => {
        User: () => IOManager().deserializeObjects<User>(DatabaseManager.collections[User]!),
        Campaign: () => IOManager().deserializeObjects<Campaign>(DatabaseManager.collections[Campaign]!),
        Character: () =>
            IOManager().deserializeObjects<Character>(DatabaseManager.collections[Character]!),
        Enchantment: () =>
            IOManager().deserializeObjects<Enchantment>(DatabaseManager.collections[Enchantment]!),
        Weapon: () => IOManager().deserializeObjects<Weapon>(DatabaseManager.collections[Weapon]!),
        Armor: () => IOManager().deserializeObjects<Armor>(DatabaseManager.collections[Armor]!),
        Item: () => IOManager().deserializeObjects<Item>(DatabaseManager.collections[Item]!),
        Coin: () => IOManager().deserializeObjects<Coin>(DatabaseManager.collections[Coin]!),
        Equipment: () =>
            IOManager().deserializeObjects<Equipment>(DatabaseManager.collections[Equipment]!),
      };

  /// The functions used to fetch cache data from db
  Map<core.Type, Future<List<WithUID>> Function()> get cacheSeeders => {
        Enchantment: () async =>
            await DatabaseManager()
                .getList<Enchantment>(DatabaseManager.collections[Enchantment]!, pageSize: 9999) ??
            [],
        Weapon: () async =>
            await DatabaseManager()
                .getList<Weapon>(DatabaseManager.collections[Weapon]!, pageSize: 9999) ??
            [],
        Armor: () async =>
            await DatabaseManager().getList<Armor>(DatabaseManager.collections[Armor]!, pageSize: 9999) ??
            [],
        Item: () async =>
            await DatabaseManager().getList<Item>(DatabaseManager.collections[Item]!, pageSize: 9999) ??
            [],
        Coin: () async =>
            await DatabaseManager().getList<Coin>(DatabaseManager.collections[Coin]!, pageSize: 9999) ??
            [],
        Equipment: () async =>
            await DatabaseManager()
                .getList<Equipment>(DatabaseManager.collections[Equipment]!, pageSize: 9999) ??
            [],
      };

  invalidateCache<T>() async {
    final path = DatabaseManager.collections[T]!.replaceAll('/', '');
    await IOManager().removeAll([path, '${path}_timestamp']);
  }

  /// This should be called after obtaining the auth
  fetchData() async {
    for (var cache in caches.entries) {
      final path = DatabaseManager.collections[cache.key]!.replaceAll('/', '');
      final timestamp = IOManager().get<int>('${path}_timestamp') ?? 0;
      if (timestamp.elapsedTime.inSeconds < cachesTTL[cache.key]!) {
        caches[cache.key]!.clear();
        caches[cache.key]!.addAll(await cacheDeserializers[cache.key]!());
        print('📘 I\'ve read ${caches[cache.key]!.length} ${cache.key}s locally');
      } else {
        await IOManager().removeAll([path, '${path}_timestamp']);
        print('❗ The ${cache.key} cache has been invalidated');
        // Seed the cache if a seeder is defined
        if (cacheSeeders.containsKey(cache.key)) {
          caches[cache.key]!.clear();
          caches[cache.key]!.addAll(await cacheSeeders[cache.key]!());
          IOManager().serializeObjects(DatabaseManager.collections[cache.key]!, caches[cache.key]!);
          print('⬇️ I\'ve downloaded ${caches[cache.key]!.length} ${cache.key}s');
        }
      }
    }
  }

  /// Fetch items created by the user TODO: (and their campaign buddies)
  fetchUserItems() async {
    AccountManager().user.inventoryItems.forEach((key, value) async {
      var leftovers =
          value.where((e) => caches[key]!.firstWhereOrNull((eCached) => eCached.uid == e) == null);
      if (leftovers.isNotEmpty) {
        final objs = await {
              Weapon: DatabaseManager().getListFromUIDs<Weapon>,
              Armor: DatabaseManager().getListFromUIDs<Armor>,
              Item: DatabaseManager().getListFromUIDs<Item>,
              Coin: DatabaseManager().getListFromUIDs<Coin>,
            }[key]!(DatabaseManager.collectionsPOST[key]!, leftovers.toList()) ??
            [];
        caches[key]!.addAll(objs);
        print('⬇️ I\'ve downloaded ${leftovers.length} user created ${key}s');
        // IOManager().serializeObjects(DatabaseManager.collectionsPOST[key]!, caches[key]!);
      }
    });
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
    T obj = await DatabaseManager().get<T>(DatabaseManager.collections[T]!, uid);
    caches[T]?.removeWhere((e) => e.uid == uid);
    caches[T]!.add(obj);
    // Write cache to disk
    await IOManager().serializeObjects(DatabaseManager.collections[T]!, caches[T]!);
    print('📙 I\'ve cached ${caches[T]!.length} ${T}s');
    return obj;
  }

  /// Load a multiple objects from a given list of UIDs
  Future<List<T>> loadList<T extends WithUID>(List<String> uids, {bool useCache = true}) async {
    List<T> objects = [];
    if (useCache) {
      for (var uid in uids) {
        if (T.runtimeType == User) {
          // Is current User?
          if (AccountManager().user.uid == uid) {
            objects.add(AccountManager().user as T);
          }
        }
        WithUID? obj = caches[T]?.firstWhereOrNull((e) => e.uid == uid);
        if (obj != null) objects.add(obj as T);
      }
    }
    final leftovers =
        uids.where((uid) => objects.firstWhereOrNull((obj) => obj.uid == uid) == null).toList();

    // Ask the database for the objects and caching it
    if (leftovers.isNotEmpty) {
      objects.addAll(
          await DatabaseManager().getListFromUIDs<T>(DatabaseManager.collections[T]!, leftovers) ?? []);
      caches[T]!.removeWhere((e) => leftovers.contains(e.uid));
      caches[T]!.addAll(objects);
      // Write cache to disk
      await IOManager().serializeObjects(DatabaseManager.collections[T]!, caches[T]!);
      print('📙 Ho scritto su cache ${caches[T]!.length} ${T}s');
    }
    return objects;
  }

  /// Load the characters of a given user
  loadUserCharacters(User user) async => user.characters.value = await loadList(user.charactersUIDs);

  /// Load the weapon, armor, item and coin objects of a given character
  loadCharacterInventory(Character character) async => character.inventory.value = {
        for (var entry in character.weaponsUIDs.entries)
          (await load<Weapon>(entry.key)) as InventoryItem: entry.value
      } +
      {
        for (var entry in character.armorsUIDs.entries)
          (await load<Armor>(entry.key)) as InventoryItem: entry.value
      } +
      {
        for (var entry in character.itemsUIDs.entries)
          (await load<Item>(entry.key)) as InventoryItem: entry.value
      } +
      {
        for (var entry in character.coinsUIDs.entries)
          (await load<Coin>(entry.key)) as InventoryItem: entry.value
      };

  /// Load the enchantments objects of a given character
  loadCharacterEnchantments(Character character) async => character.enchantments.value = {
        for (var id in character.enchantmentUIDs) await load<Enchantment>(id)
      };

  /// Save Model objects
  Future<String?> save<T extends WithUID>(T model, [SaveMode mode = SaveMode.put]) async {
    String path = mode == SaveMode.post
        ? DatabaseManager.collectionsPOST[model.runtimeType]!
        : DatabaseManager.collections[model.runtimeType]!;

    if (mode == SaveMode.put) path += model.uid?.replaceAll('/', ' ') ?? '';

    String? newUID;
    // Query the FirebaseRD
    if (mode == SaveMode.put) {
      DatabaseManager().put(path, model.toJSON());
      // Update cache value
      caches[model.runtimeType]!.removeWhere((e) => e.uid == model.uid);
      caches[model.runtimeType]!.add(model);
      await IOManager().serializeObjects(
          DatabaseManager.collections[model.runtimeType]!, (caches[model.runtimeType]!.cast<WithUID>()));
    } else {
      caches[model.runtimeType]!.add(model);
      newUID = await DatabaseManager().post(path, model.toJSON());
    }
    return newUID;
  }

  Future<void> checkNickname(String newNickname) async {
    try {
      // Check if the nickname is already taken
      final isTaken = await DatabaseManager().isNicknameTaken(newNickname);
      if (isTaken) {
        throw Exception("Nickname already taken.");
      }

      // Fetch the current user object
      final currentUser = await DataManager().load<User>(AccountManager().user.uid!);

      // Update username and save
      currentUser.username = newNickname;
      await DataManager().save(currentUser);

      print("Nickname updated successfully.");
    } catch (e) {
      print("Error updating nickname: ${e.toString()}");
      rethrow; // Optionally rethrow to propagate the error
    }
  }
}
